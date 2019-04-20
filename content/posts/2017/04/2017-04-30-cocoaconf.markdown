title: "CocoaConf: How I Prepared, & What I Learned"
date: 2017-04-30 20:00
Category: Computers
Tags: CocoaConf, Debugging, XCode, LLDB, Python, Speaking

Last week I attended [CocoaConf Chicago][ccc17] for the 6th year in a row. In this post I would like to share with you how I prepared as a [speaker](#speaker), and what I learned as an [attendee](#attendee). 

<!-- more -->

<!-- ai c /images/2017/04/aijaz800.jpg /images/2017/04/aijaz800.jpg 800 533 My CocoaConf Chicago Talk (CocoaConf PhotoStream - https://www.flickr.com/photos/cocoaconf/34089423592/in/photostream/) -->

## <a name="speaker"></a>How I Prepared as a Speaker


#### Choosing a topic that excited me

I was thrilled when I got the opportunity to speak at CocoaConf. I've spoken at conferences before, but CocoaConf is special because of our long shared history. I knew almost immediately what I wanted to talk about: [Advanced Debugging][talk]. This is a topic I have been very excited to learn about for the last couple of years and I have recently learned how to extend LLDB so that I can debug more efficiently. 

#### Logging good ideas

In the months leading up to the talk I kept a log of ideas in a simple text file. Whenever I thought about something that could be a good point to make in the talk I would jot it down in the file and move on to whatever it was I was supposed to be working on. It was at about a month before the talk that I really started thinking about the structure and focusing on the main idea. I decided not to make this a fact-rich talk, but to work on a sample app and focus on three things: the benefits of the tight integration of Clang and LLDB, debugging memory leaks, and extending LLDB to run third-party code from within the `(lldb)` prompt. 

#### Avoiding live-coding

I wrote a sample app, intentionally adding the bugs that I wanted to talk about. I didn't think live-coding would be a good idea: No one wants to see me type, especially while I'm standing up, and with the laptop on a desk that's too low for me to type at my normal speed. So I set up a bunch of text snippets using [TextExpander][te], and inserted the triggers as comments in the code. This way all I had to do was select the line that contains the comment, enter the trigger, and TextExpander would add the required code. Here's an example of the trigger named `cc2`.

```objc
-(instancetype)init {
    self = [super init];
    if (self) {
        //cc2
    }
    return self;
}
```

#### Abandoning presenter notes

When I started practicing my talk, I connected my external monitor as a secondary screen, so that I could show presenter notes on my laptop. Every so often I would have to stop the presentation, and switch over to XCode so that I could view and edit the code. As I practiced, I realized that the transition from Keynote to XCode took too long: I would have to go to my Display settings, turn on display mirroring, wait for the monitor (or projector) to sync with my laptop display, resize windows, and then continue. Then when I would have to switch back to Keynote I would have to revert all these changes. Each context switch took about 30 seconds. Anything longer than 3 or 4 seconds, and I would lose my audience to Twitter, Slack or just general boredom. 

That's when I decided the only foolproof thing to do was to keep the display mirrored at all times, abandon the presenter notes, and just memorize the talk entirely. It felt odd not having the help of the presenter notes, but I think memorizing made the talk flow better. I was actually able to look at the audience rather than steal glances at my laptop.


#### Remembering to set up properly 

Whenever I practiced my talk I realized that I had forgotten to complete at least one crucial set-up step. Maybe I didn't `git checkout` the correct starting commit of the code. Maybe I forgot to turn off `malloc` logging so I could talk about why we should turn it on. Every time I practiced I forgot something different. Soon I realized I needed a *Pre-Talk Checklist*.  This helped me a great deal. I wrote my checklist on a little piece of paper that I placed next to my laptop. My checklist looked something like this:

```
* git reset --hard demoBranch
* disable f.lux
* switch to large font in XCode
* exit web browsers and other unnecessary apps
* turn off malloc logging
* delete all breakpoints
* check that test slide displays correctly 
```

#### Removing slides that didn't serve the audience

I had jokes in my talk. Oh, I had hilarious jokes. Some of them were visual gags, some of them were self-deprecating. But as I practiced my talk I realized three things: 1) these jokes took time to deliver, 2) they didn't help the audience meet their stated goal: to learn advanced debugging, and 3) they were self-serving and were there more for me than for my audience. So I pulled them all out. Doing this got me from slightly over my allotted time to well below it. I also had a 2 minute anecdote on the importance of debugging. I pulled that out as well. If you're in the room listening to me when you could be next door learning about memory management in Swift from Mike Ash, it's pretty obvious you don't need to be convinced that debugging is important. With all that pruning I was able to get finish my practice talks with ten minutes to spare. That would give us enough time for questions. 

#### <a name="savino"></a>Taking a breather

When [Laura Savino][savinola] gave her talk on XCode tips at CocoaConf Chicago a few years ago, every so often she would pause her presentation and put up a picture of adorable animals. It was an opportunity for us to digest all the information we were being fed, and take a moment's break while our brains organized the facts. I liked those breaks and decided to incorporate them into my talk as well. Before every demo I put up a different picture from my recent trip to Yosemite National Park. The picture would be a cue to myself (and I hope the audience as well) to take a deep breath, slow down, sip a little water, and compose myself before context switching. 

<!-- ai c /images/2017/04/pano1000.jpg /images/2017/04/pano1000.jpg 1000 403 The audience files in -->

#### Asking for questions at specific times

After every demo I would recap what I did, and what we just learned. Then I would display a slide with the foreground and background colors swapped with "Any Questions?" written on it. This served two purposes: It prompted me to make sure that I hadn't lost the audience, and it also gave an implicit instruction to the audience to only ask questions when one of those slides was being displayed. This allowed me to keep the talk flowing in a predictable manner. 

#### Explaining code

At one point during my talk I had to explain 21 lines of Python code that would illustrate how to extend LLDB. One of the things I learned from [Damian Conway's Instantly Better Presentations][ibp] was to animate the presentation of the code, instead of just showing a wall of code and pointing to line after line. Using animations I was able to focus on just the lines of code I wanted to talk about while simultaneously shrinking other lines down. This way the audience knew where to look, while simultaneously learning where the snippet in question falls in the big picture. 

I used the Magic Move animation in Keynote with "Match by Character" set to animate the code. It took me about 8 hours of trial and error to get the animations just right, but I think they really helped in communicating to the audience. Several people came up to me afterwards and told me that the animations helped them understand the code. I strongly recommend this technique and plan to use it for all my talks moving forward. Here's a 22 second demo:

<div style="position:relative;height:0;padding-bottom:56.25%"><iframe src="https://www.youtube.com/embed/wFDu2XmkhWM?ecver=2" width="640" height="360" frameborder="0" style="position:absolute;width:100%;height:100%;left:0" allowfullscreen></iframe></div>

## <a name="attendee"></a>What I Learned as an Attendee

If there's any negative aspect to CocoaConf it's the fact that at any particular time there are three simultaneous talks. This means we are faced with very tough choices when we're trying to decide which session to attend. This year I decided to attend those sessions whose topics would likely help me with the projects I'm working on right now. There were many other sessions that I really wanted to attend, but I had to tell myself that I didn't have the luxury to attend a session merely to satisfy my curiosity; I had to choose the ones that had the most potential to change my daily coding habits right now. 

I work at [Fast Model Sports][fm] and our flagship app is due for an overhaul on how it uses push notifications.  [Ellen Shapiro's talk][push] addressed this well and I should be able to use what I learned there are soon as we decide to end support for iOS 9. From [Tom Harrington's talk on UIStackViews][tom], I learned a very neat trick on how to embed a UIStackView within a UIScrollView. This is not as obvious as it would appear. 

When I'm not at work I also help out my brother with his Food Catering business, [TurboTiffin][tt]. The web app and API are currently written in Python, but I suspect I will switch to writing web services in Swift before too long. The context switches that are required while writing in Swift, Objective-C and Python all in one day can be very taxing. [Jacob Van Order's talk on Kitura][kitura] showed my just how far we've come down the path of being able to write exclusively in Swift. Unfortunately, since I write in Objective-C at work, my Swift has gotten rusty. I will need to pick it up again. 

<a name="napier"></a>I am also very glad to say that other than one minor thing, I didn't learn anything new from [Rob Napier's talk entitled 'Practical Security'][sec]. It's not because the talk was no good - it was excellent. It's just that I have spent many years teaching myself secure software development and also picking up best practices when I worked at [VaporStream][vs]. I went to Rob's talk with no small amount of trepidation; have I been overlooking some basic tenet of security? Fortunately, the answer was no. With the exception of one minor 'judgement-call' issue, I have been doing things right for the past few years, when it comes to security. 

I was also reminded during Rob's talk that he's the "RN" in ["RNCryptor"][rncryptor]. I had used this excellent encryption library that he created when I worked at Vaporstream, and I was grateful to get the opportunity to thank him for the library in person. If you're looking to encrypt and decrypt data, use RNCryptor. 

The three other talks technical talks I attended are probably the most thought-provoking of them all. They all deal with how to architect your app. As someone who writes apps that have to be mantained for years, I'm always looking to learn how to minimize the pain I cause my future self by making the right architectural decisions today. James Dempsey spoke about [Using Small Protocols for Dependency Injection][jd], John Reid spoke on [Refactoring and the Model View Presenter pattern][mvp], and Jeff Roberts proposed [Removing the "M" from "MVC"][mvc]. 

It's that last session that's got me thinking a lot for the past few days. Jeff says that the Model can be replaced by a new entity called a ResultSet, which, if I understand correctly, is essentially an SQLite3 result set or a wrapper around it. The benefits he listed are: 

- Every view has the same model
- Just the data you want, in the order you want
- Works perfectly as the data source for UITableView/UICollectionView

It's that second one that's most intriguing to me. In a complex application a fully-specified model object could be very large. For example, if I were modeling a movie, I could make the claim that a fully-specified model object should include the synopsis, release dates, etc. But there may be individual views (like a cover flow) that only need a subset of that information. I understand that limiting myself to formal first-class model objects may be overkill, and in fact may also be wasteful in terms of memory used. What then? Should it be permissible to construct model objects that are only partially constructed? Should I create different kinds of model object for different kinds of UIViews? If I did that, aren't I just creating a model object of a database view? 

The more I think about it, the less _scandalous_ Jeff's proposal appears. The M in MVC doesn't necessarily refer to classes that model entities. Most definitions say that the Model is the Domain Data. Keeping that in mind, is it really that odd to use a result set as a Model? Perhaps the takeaway from all of this is: Use the right tool for the job. If it makes sense to use a domain object as a model, do it. If it makes more sense to use a result set rather than an expensive object, do that. I don't think we need to commit to either of the methodologies for a hundred percent of use cases. 

## <a name="thanks"></a> Until Next Time

Like all good conferences, CocoaConf has left me thinking long after the last session ended. These kinds of conferences serve a different purpose than, for example, WWDC. At conferences like CocoaConf we get to see how others use Apple's frameworks, and how they write their code. That is the real benefit to me, that I can approach someone who for years has been doing something that I'm thinking of doing, or that I have just started. And I can ask her, "Hey. How did you solve that problem?" So if you ever get the opportunity to attend conferences like this one, I strongly recommend it.

I would like to thank the Klein family for providing us this forum in which to learn. But the conference wouldn't be what it is without the the people who give it its character: the other attendees (including the speakers). I would like to thank everyone who attended, everyone with whom I shared a conversation, a smile, a laugh, a hug. Thank you for making this conference what it is: something to look forward to every year. 

[mvc]: http://cocoaconf.com/chicago-2017/sessions/Remove-the-M-from-MVC
[jd]: http://cocoaconf.com/chicago-2017/sessions/Using-Small-Protocols-to-Vend-App-Wide-Dependencies-in-Swift
[ibp]: https://www.youtube.com/watch?v=W_i_DrWic88
[code]: https://youtu.be/wFDu2XmkhWM
[te]: https://textexpander.com/
[ccc17]: http://cocoaconf.com/chicago-2017/home
[talk]: http://cocoaconf.com/chicago-2017/sessions/Beyond-Breakpoints
[push]: http://cocoaconf.com/chicago-2017/sessions/Pushing-the-Envelope-with-iOS-10-Notifications
[kitura]: http://cocoaconf.com/chicago-2017/sessions/Building-Web-Applications-with-Kitura
[fm]: http://fastmodelsports.com
[savinola]: http://cocoaconf.com/chicago-2017/speakers/130
[tom]: http://cocoaconf.com/chicago-2017/sessions/Mastering-Stack-Views
[sec]: http://cocoaconf.com/chicago-2017/sessions/practical-security
[mvp]: http://cocoaconf.com/chicago-2017/sessions/Model-View-Presenter-and-the-Power-of-Refactoring
[rncryptor]: https://github.com/RNCryptor/RNCryptor
[tt]: http://turbotiffin.com
[vs]: http://vaporstream.com
