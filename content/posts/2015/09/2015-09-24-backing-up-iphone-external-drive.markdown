title: "Backing Up your iPhone to an External Drive"
date: 2015-09-24 22:10
comments: false
description: "This short post shows you how to back up your iPhone to an external drive."
Category: Computers
Tags: iPhone, Backups

Some of you may not have room on your hard drive to back up your iPhone. This short post shows you how I backed up my iPhone to an external drive (on a Mac).

<!-- more -->

Backups are stored in `~/Library/Application Support/MobileSync/Backup`. I have an external drive named `SG3`.

1. First, I made a backup of that `Backup` folder
2. Then I created an empty folder at `/Volumes/SG3/Library/Application Support/MobileSync`
3. Then I copied the `Backup` folder into the `MobileSync` folder on `SG3`
4. Then I deleted the `Backup` folder at `~/Library/Application Support/MobileSync`
5. Then I launched terminal and typed in `cd ~/Library/Application\ Support/MobileSync`
6. Then I typed in `ln -s /Volumes/SG3/Library/Application\ Support/MobileSync`

That's it! That last command made a symbolic link to an external drive. From now on all backups will be stored on the external drive. Conversely, if the external drive isn't attached, iTunes will not be able to either create or read backups.

There are other ways to chose a library residing on an external drive, but I wanted to use the library on my local SSD drive, and only use the external drive for backups. This method worked well for me. 

See you tomorrow.

_This is the 24th of my [30 days][] posts._

[30 days]: /2015/08/31/30-days/
