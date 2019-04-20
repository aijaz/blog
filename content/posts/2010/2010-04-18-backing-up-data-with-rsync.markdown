comments: false
date: '2010-04-18 22:46:03'
slug: backing-up-data-with-rsync
title: Backing Up Data With rsync
Category: Computers
Tags: Backups, linux, Macs, rsync

<!-- ai l /wp/20081224-IMG_4891-Edit.jpg /wp/20081224-IMG_4891-Edit-285x190.jpg 285 190 At the Agra Fort, on the way to the Public Hall -->

In a [earlier post](/2009/12/24/what-to-do-when-your-mac-is-temporarily-disabled/) I wrote about how important it is to have
your data backed up.  On my Macs, my main backup utility is [Time Machine](http://www.apple.com/macosx/what-is-macosx/time-machine.html), which
comes pre-installed with the Mac OS.  Time Machine can also back up external
hard drives, even though it may not be obvious how to do it.  [This article](http://www.onedigitallife.com/2007/10/30/does-time-machine-backup-external-drives/) shows you how to change the default settings to do this.
<!-- more -->

If you don't have Time Machine - for example, if you're using Linux -  the
_rsync_ command can be almost as easy to use and it can be used to back up
your data.  Now, rsync is a very powerful command that has dozens of options,
but three options are all you need for simple backups.  Let's say you save all
your photos on an external drive visible at /Volumes/Media.      And  you want
to back it up on another drive located at /Volumes/Backup.  The following
command would do this for you:

    rsync -avh /Volumes/Media /Volumes/Backup  
  
The preceding command will copy all of /Volumes/Media, and place it inside a
subdirectory of /Volumes/Backup, called Media.  In other words,
/Volume/Backup/Media will contain everything that /Volumes/Media contains.
But here's the really neat part: Every subsequent time you invoke this
command, rsync will only copy those files that are different from what is
already in the destination directory (or those files that are new).  So if you
copy 500 pictures on one day, and then back up the directory as shown above,
and then import 10 new pictures into /Volumes/Media, and then back up again,
the second backup will only copy the 10 new pictures, not all 510.

Since Mac OS X is also based on UNIX, the above command will work on the Mac
OS just as well as it works on Linux or UNIX.

For more details on the rsync command, please see the [rsync documentation page](http://samba.anu.edu.au/rsync/documentation.html).
