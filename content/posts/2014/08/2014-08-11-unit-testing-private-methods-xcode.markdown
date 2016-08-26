---
published: true
title: "Unit Testing Private Methods with XCode"
date: 2014-08-11 22:00
comments: false
Category:
- Computers
tags:
- iOS
- XCode
- ObjectiveC
- Testing
- TDD
description: "This post illustrates what I did to test a private method using XCode 5."
---


Now that I'm starting a new iOS development project, I'm trying to have close-to-complete test coverage of critical parts of my code. I'm using XCTest pretty extensively, and found that I needed to test a rather complicated private method that is critical to my app's user experience. This post shows you how I did it.

<!-- more -->

Before we get started, I know that some people [feel very strongly](http://shoulditestprivatemethods.com/) about testing private methods. I don't want to get into that discussion. I just know that there is one private method that I need to test thoroughly. It's pretty simple, really. 

The first thing I did was go to my project settings. I duplicated the ```Debug``` configuration by clicking on that '+' and called the new configuration ```Unit Testing```.

<!-- ai c /images/2014/08/configurations.png /images/2014/08/configurationsSmall.png 771 271 Build configurations -->

Then I edited my schemes and for the ```Test``` action I directed XCode to use the newly-created ```Unit Testing``` scheme: 

<!-- ai c /images/2014/08/scheme.png /images/2014/08/schemeSmall.png 733 563 Editing Schemes -->

Then I went back to my project and added a ```TESTING=1``` preprocessor directive for the ```UnitTesting``` configuration

<!-- ai c /images/2014/08/preprocessor.png /images/2014/08/preprocessorSmall.png 770 357 Adding Preprocessor Directives -->

Since I use CocoaPods, I had to create a ```UnitTesting``` configuration for the ```Pods``` project as well. I didn't need to modify schemes any further or add any preprocessor directives for CocoaPods. 

With this in place, I was able to use preprocessor directives to make my private methods public (only when testing) in my ```.h``` (interface) file: 

    :::objc
    #ifdef TESTING
    -(void) myPrivateMethod;
    #endif

### UPDATE 2014/08/12 08:34

Earlier this morning I mentioned this post to [Brad Heintz](https://twitter.com/bradheintz), whose talk on automated unit testing I attended at the recent [CocoaConf](http://cocoaconf.com) in Columbus. Brad suggested an even simpler solution, which I present here with his permission: 

> Declare a local category for the class under test in your test case file. Inside that category, you can re-declare the private methods so that your test case can see them. BUT: When you find yourself wanting to do that, you should step back & consider whether you're testing behavior (which is good) or implementation. 

Since the method I'm testing generates ```CGPoint```s that are fed to a UIView's ```drawRect```, I feel justified violating that rule of thumb this one time. It's a *lot* easier to test this critical method when I have an array of points than when all I have is a UIView.
