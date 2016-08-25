---
comments: false
date: '2011-04-25 21:36:25'
slug: implementing-inertial-scrolling-in-ios
title: Implementing Inertial Scrolling in iOS
Category:
- Computers
tags:
- iOS
- Scrolling
---

I hadn't really given much thought to how the iPhone handles scrolling until I
recently had to implement it myself. I needed to add vertical scrolling to a
UIView that models a real-life metaphor. In my particular case I feel using a
UIScrollView would break the metaphor - the user would "snap out" of the
immersive app and realize they're merely using an iPhone app with a pretty
skin. So the natural solution was to implement scrolling myself. This is how
it went from simple, unnatural scrolling to its current state of acceptable
inertial scrolling.
<!-- more -->

## Version 1 - Hit By The Ugly Stick

I started off with my view controller's existing implementations of ```touchesBegan:withEvent:```, ```touchesMoved:withEvent:``` and ```touchesEnded:withEvent:```.
In ```touchesBegan``` I saved the starting y location of the view controller
(```self.frame.origin.y```) into an instance variable. I also saved the total amount
moved in another variable:

    
    
    {% codeblock lang:cpp %}
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        self.lastFrameOriginY = canvasView.frame.origin.y;
        self.cumulativeDeltaY = 0;
    }
    {% endcodeblock %}
    

  
In ```touchesMoved``` I tracked the location of the touch in the view, as well as
the location of the previous touch in the view.  Subtracting one from the
other I was able to see how much the touch had moved in between invocations
and in what direction:

    
    
    {% codeblock lang:cpp %}
    - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
        NSObject * obj = [touches anyObject];
        CGPoint p      = [(UITouch *)obj locationInView: canvasView];
        CGPoint o      = [(UITouch *)obj previousLocationInView: canvasView];  
        // Translation only, not real distance between points
        //
        int deltay = p.y - o.y;  
        // This is how much we have moved since we started dragging
        // defined as an integer property of the view controller
        //
        [self setCumulativeDeltaY: self.cumulativeDeltaY + deltay];  
        if (obj != nil) {
            CGRect r = [canvasView frame];  
            // Move the view according to how much the touch has moved
            //
            r.origin.y = self.lastFrameOriginY + self.cumulativeDeltaY;
            [canvasView setFrame:r];
        }
    }
    {% endcodeblock %}
    

  
I didn't really need to implement ```touchesEnded``` because by the time the touches
ended, the view was already where it needed to be.  That's the whole point of
dragging, right?  Well, yeah, but just leaving the view where it was made for
a very abrupt and unnatural stop.  There was no gentle stop. Ironically, the
immediate stop made the application feel more sluggish than if I had the
inertial stop we're all used to with UIScrollView.  Clearly it was time for
plan B.

## Plan B - Well, At Least Your Intentions Were Honorable.

How difficult can it be?  Just implement a ```touchesEnded:withEvent:``` and use
animation to move the view a certain distance before stopping, depending on
how fast it was going in the first place.

This is where I donned my Engineer hat and told myself "Obviously, speed is
distance divided by time so, I need to find the distance moved so far and
divide it by the time between when the touchdown event and the touchup event,
and (as my music teacher would say) Viola! That's my speed."

Turns out that's wrong.  I looked at the UIScrollView, and what matters is not
how fast you got from touchdown to touchup, but how fast you were moving right
before touchup.  Okay, we have a really good approximation of that already -
that's the distance between locationInView and previousLocationInView (what I
call deltay).  So that was chosen to be my speed.  I decide to choose
reasonable approximations rather than model the physics perfectly.  The
scrolling just needs to 'look right' and it should not slow the app down or be
computationally intensive.  Here's what it looked like:

    
    
    {% codeblock lang:cpp %}
    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
        NSObject * obj = [touches anyObject];
        if (obj != nil) {
            CGPoint p = [(UITouch *)obj locationInView: canvasView];
            CGPoint o = [(UITouch *)obj previousLocationInView: canvasView];  
            // Translation only, not real distance between points
            //
            int deltay = p.y - o.y;  
            // This is how much we have moved since we started dragging
            // defined as an integer property of the view controller
            //
            [self setCumulativeDeltaY:self.cumulativeDeltaY + deltay];  
            CGRect r = [canvasView frame];  
            // Put a cap on what the speed can be, so we
            // don't have to deal with absurdly fast flicks.
            // Also, treat a tiny move as no move at all - you don't want a
            // tiny move causing a large drift.
            //
            int maxSpeed = 80;  
             if      (deltay > maxSpeed)         { deltay =  maxSpeed; }
             else if (deltay < -maxSpeed)        { deltay = -maxSpeed; }
             else if (deltay > -5 && deltay < 5) { return; }  
             double duration = 0.5;  
             // Chose 10 after trial and error because
             // the results 'looked right'
             //
             int finalDistance = deltay * 10;
             r.origin.y += finalDistance;  
             // Animate the view with an EaseOut curve so that it slows down.
             //
             [UIView beginAnimations:@"inertialSlide" context:NULL];
             [UIView setAnimationDuration:duration];
             [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
             [canvasView setFrame:r];
             [UIView commitAnimations];
        }
    }
    {% endcodeblock %}
    

  
Now that's better!  The scrolling came to a gentle stop as I gingerly tested
it.  Then I tried a few fast flicks of the view, and the scrolling just
stopped abruptly (see Ugly Stick).  There was no inertia here.  It was like
the fast flicks were being treated as really slow scrolls.

Sure enough, when I started debugging, the value of ```deltay``` inexplicably moved
to -2 or 2 when the scrolling was really fast.  [This post at Opetopic Blog](http://opetopic.com/blog/2010/05/26/implementing-drag-and-throw-behavior-with-touches/) confirmed my suspicions: the events were happening so
fast that ```previousLocationInView``` could not be trusted.

So then I decided to go with a hybrid solution - Keep what I have for slow
scrolls, and use something else for fast scrolls.  First, I would need to know
how to differentiate between slow and fast scrolls.  Then I would need to
figure out how to handle fast scrolls.  Here's what I did:

## Final Version: That's More Like It

I added two new instance variables to my view controller: ```startTime``` and
```endTime```, whose difference would give me the duration between the touchdown and
touchup events.  I also added a CGPoint called ```previousLocation``` that saved the
starting location of the touchdown event.

    
    
    {% codeblock lang:cpp %}
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        self.cumulativeDeltaY = 0;
        self.lastFrameOriginY = canvasView.frame.origin.y;  
        // Save the time at which the touches started
        //
        startTime = CACurrentMediaTime();  
        NSObject * obj = [touches anyObject];
        if (obj != nil) {
            // Save the location at which the touches started
            // (in the parent view)
            //
            previousLocation = [(UITouch *)obj locationInView: bgView];
        }
    }
    {% endcodeblock %}
    

  
Now that the starting location and time are saved, we can use these variables
to figure out whether the flick was 'too fast.'

    
    
    {% codeblock lang:cpp %}
    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
        NSObject * obj = [touches anyObject];  
        // The time at which the touches ended
        //
        endTime = CACurrentMediaTime();  
        if (obj != nil) {
            CGPoint p = [(UITouch *)obj locationInView: canvasView];
            CGPoint o = [(UITouch *)obj previousLocationInView: canvasView];  
            // Translation only, not real distance between points
            //
            int deltay = p.y - o.y;  
            // This is how much we have moved since we started dragging
            // defined as an integer property of the view controller
            //
            [self setCumulativeDeltaY:self.cumulativeDeltaY + deltay];  
            CGRect r = [canvasView frame];  
            // Put a cap on what the speed can be, so we
            // don't have to deal with absurdly fast flicks.
            // Also, treat a tiny move as no move at all - you don't want a
            // tiny move causing a large drift.
            //
            int maxSpeed = 80;  
            // Find out the how long the touches lasted
            //
            float timeDifference = endTime - startTime;  
            // Chose 0.35 after some trial and error.  It seemed like the most
            // natural amount
            //
            if (timeDifference < 0.35) {
                // The flick was really fast.  Use Distance/Time to
                // calculate speed.  It will likely be accurate.  
                // Get the current location in the parent view
                //
                o = [(UITouch *)obj locationInView: bgView];  
                // Calculate the speed as distance/time.  Use some scaling
                // to get the speed to be comparable to a normal flick.
                //
                deltay = (o.y - previousLocation.y) / (timeDifference * 10);
            }  
             if      (deltay > maxSpeed)         { deltay =  maxSpeed; }
             else if (deltay < -maxSpeed)        { deltay = -maxSpeed; }
             else if (deltay > -5 && deltay < 5) { return; }  
             double duration = 0.5;  
             // Chose 10 after trial and error because
             // the results 'looked right'
             //
             int finalDistance = deltay * 10;
             r.origin.y += finalDistance;  
             // Animate the view with an EaseOut curve so that it slows down.
             //
             [UIView beginAnimations:@"inertialSlide" context:NULL];
             [UIView setAnimationDuration:duration];
             [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
             [canvasView setFrame:r];
             [UIView commitAnimations];
        }
    }
    {% endcodeblock %}
    

  
With these new changes the speed is calculated acceptably well in both cases -
slow scrolls and super-fast flicks.  Note that I used trial and error to come
up with the 0.35 second threshold and also to calculate the speed (```deltay```) in
that case. These values work on the device that I have tested with, but more
testing will be needed to see if this is a solution that will work for all the
devices out there.

## Summary

I was certainly surprised at how important the 'little' things like inertial
scrolling are to a satisfying user experience.  While my crude attempt at
implementing it may not be technically accurate, it appears to be good enough.
And that's really what I'm looking for.  If I've done my job well, no one will
notice the scrolling.  I'm not designing a user interface toolkit; I just
don't want it to stick out like a sore thumb.  Please keep in mind that this
isn't exactly the code that's in my app - I've modified it for display here.
I may have introduced some minor syntax errors while formatting the code for
this blog post.  Also, I can't stress enough that this isn't a default
solution.  Whenever possible, use the UIScrollView.  It's there because it
works.  It's Apple's gift to you.  If you can use it, don't roll your own
implementation.  Just use UIScrollView.
