---
title: "Updating an Aging App"
date: 2016-12-25 11:30
category:
- Computers
tags:
- QuranMemorizer
- QMUpgrade
- Programming
- iOS
---

It's been more than three years, but I'm finally updating my most popular app, [Qur'an Memorizer][qm]. This is the first in a series of blog posts tagged with [QMUpgrade][qmu], where I'll write about the issues I faced updating an aging app. 

<!-- more -->

The first thing I realized is that I can't even build the app in XCode 8. Header files can't be found, valid architectures can't be found, etc. 

I decided to start from scratch and create a new project. I can reuse a lot of the critical animation code, and improve the rest of the code with what I've learned over the past few years. 

At the most basic level, I chose to stay with Objective-C because there is too much else to change, and I would like to reuse as much code as possible. For testing I've decided to use [Specta][] and [Expecta][] and XCode's native User Interface testing framework. 

My coding style has changed a lot over the last few years, along with my adoption of modernizations to Objective-C, so I'm really looking forward to using [nullability qualifiers][nullability], [lightweight generics][generics] and [kindof types][kindof].   

My strategy for the the update is as follows: start with the core 'business' logic first, and add the user interface later. Aim for 100% coverage of code in the test cases. I don't know if that's possible, but we'll see in the next few weeks. 

One of the first issues I ran into is a consequence of my decision to use two sqlite3 databases, one for the domain-level data, and the other for user data (bookmarks, notes, preferences, etc). Over the past few years I've started using [FMDBMigrationManager][] along with [FMDB][] to handle the migration of database versions. By default, FMDBMigrationManager looks for sql files in the default bundle and applies them in order. But now, with two databases, I need to partition the sql files so that the two database schemas can be migrated independently. So I needed to create two new bundles, one for the main database, and one for the preference database. 

To do this I created two folders named `qmSql.bundle` and `prefsSql.bundle`. Each folder has its own set of sql files. Each folder also has its own `Info.plist` file. Here's the one for `qmSql.bundle`:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>CFBundleIdentifier</key>
        <string>com.euclid.quranmemorizer.sql.qm</string>
</dict>
</plist>
```

With these bundles included in my app, I thought I would be able to get pointers to them using something like this: 

```objc
NSBundle * bundle = [NSBundle bundleWithIdentifier:@"com.euclid.quranmemorizer.sql.qm"];
```

But that didn't work. Even when I created new targets and added them as dependencies to the main app and test targets, ```bundle``` would always be `nil`. 

I got it to work by using the path instead: 

```objc
NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"qmSql" ofType:@"bundle"];
NSBundle *bundle = [NSBundle bundleWithPath:resourceBundlePath];
```

If anyone knows why using the `CFBundleIdentifier` didn't work, please let me know. 

Well, that's it for now. I'll keep posting notes on the rewrite at this blog. 

[qm]: http://quranmemorizer.com/
[qmu]: http://aijaz.net/tag/qmupgrade.html
[Specta]: https://github.com/specta/specta
[Expecta]: https://github.com/specta/expecta/
[nullability]: https://developer.apple.com/swift/blog/?id=25
[generics]: http://useyourloaf.com/blog/using-objective-c-lightweight-generics/
[kindof]: https://medium.com/the-traveled-ios-developers-guide/objective-c-in-2015-3cb7dab3690c
[FMDBMigrationManager]: https://github.com/layerhq/FMDBMigrationManager
[FMDB]: https://github.com/ccgus/fmdb
