title: Rotation and Adaptive Layouts
date: 2016-12-27 22:15
Category: Computers
Tags: QuranMemorizer, QMUpgrade, Programming, MultiTasking, iPad, AutoLayout, AdaptiveLayout, iOS

*Another in a series of posts documenting my process of updating an aging app.*

For this rewrite of [Qur'an Memorizer][qm] I'm using Auto Layout. This is the first time I've used Auto Layout for this app. You know when the Apple Engineers said Auto Layout makes things easy? They weren't kidding. Even though Qur'an Memorizer has some unique behaviors for autorotation, I was able to implement this in a few hours with Auto Layout and about 25 lines of code. Read on to see what I did. 

<!-- more -->

This app is about as skeuomorphic as it gets. Its goal is to present one or two pages exactly as they would appear in the actual book. So the app has to decide whether to display two pages side by side, or just a single page. Auto Layout by itself isn't sufficient for this. I found the hint I needed in [session 233 of the 2016 WWDC (Making Apps Adaptive, part 2)][s233] (also available at [ASCIIwwdc][s233a]).

I set up my constraints, and made IBOutlets to a couple of key constraints. Then, in `viewWillTransitionToSize:withTransitionCoordinator:` I reset all my constraints' constants and set a variable instructing that a page layout recomputation was due. 

Finally, in `viewDidLayoutSubviews` I checked that variable. If it's set, I read the size of my main canvas view, and calculate its aspect ratio. Depending on the aspect ratio, I set my constraints' constants to values that will make the displayed pages' aspect ratios fall within readable boundaries. The Auto Layout engine takes care of the rest. 

```objc
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.canvasTrailingConstraint.constant = defaultConstraintConstant;
    self.canvasLeadingConstraint.constant = defaultConstraintConstant;
    self.computationDue = YES;
}

-(void)viewDidLayoutSubviews {
    [self figureOutSizes];
}

-(void)figureOutSizes {
    if (self.computationDue) {
        self.computationDue = NO;
        CGRect rect = self.canvasView.bounds;
        CGFloat ratio = rect.size.width / rect.size.height;
        CGFloat newRatio = ratio;
        
        CGFloat padding;
        if (ratio > maxSmallRatio && ratio < minLargeRatio) {
            padding = rect.size.width * 0.15; // make the ratio more pleasing
            newRatio *= 0.7; // 1 - (padding * 2)
        }
        else {
            padding = defaultConstraintConstant;
        }
        if (self.canvasTrailingConstraint.constant != padding) {
            self.canvasTrailingConstraint.constant = self.canvasLeadingConstraint.constant = padding;
        }
        
        [self resetViewsWithRatio:newRatio];
    }
}

-(void) resetViewsWithRatio: (CGFloat) ratio {
    self.leftPage.hidden = (ratio < minLargeRatio || ratio > maxLargeRatio);
}

```

All of this is done in about 20 lines of code, as opposed to 130 without Auto Layout. And as a bonus, I get multitasking on the iPad. 

If you'd like to see the prototype code in action, have a look here: 

<iframe width="560" height="315" src="https://www.youtube.com/embed/uBv2zlbBR4E" frameborder="0" allowfullscreen></iframe>


[qm]: http://quranmemorizer.com/
[s233]: https://developer.apple.com/videos/play/wwdc2016/233/
[s233a]: http://asciiwwdc.com/2016/sessions/233
