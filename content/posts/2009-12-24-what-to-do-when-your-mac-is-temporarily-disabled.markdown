---
author: Aijaz Ansari
date: '2009-12-24 04:05:21'
slug: what-to-do-when-your-mac-is-temporarily-disabled
title: What To Do When Your Mac Is Temporarily Disabled
category:
- Computers
tags:
- Apple
- Backups
- Computers
- Macs
- Service
---


<!-- ai l /wp/sad_mac1.png /wp/sad_mac1-170x170.png 170 170 Sad Mac -->

Last night my Macbook Pro would not wake up from sleep. After jiggling the mouse and hitting the
space bar a few times I powered it down. I powered it back up, and I could
hear it booting up, and could feel the hard disk move, but there was nothing
on the screen. After a little Googling I suspected the video driver was dead.
<!-- more -->

So, I went to the Apple web site and set up an appointment with a 'Mac Genius'
for 9:20 this morning (I had the day off). He made sure it wasn't corrupted
RAM and confirmed that the NVIDIA driver was faulty. There have been some
issues with this nvidia drivers on this model of MacBookPro. My warranty had
expired about 15 months ago, but since this is a known issue, they said they'd
replace it for free. However, I would have to leave my laptop behind and they
would ship it to the repair center. Now, I'm leaving the country with my
brother, and was planning on using the laptop to work on his restaurant's web
site and menu.

So here's what I did: I bought a $129 320Gb FireWire 8 Lacie pocket external
hard drive. Fortunately, I was using Time Machine and had everything backed
up. That last sentence bears repeating. Fortunately, I was using Time Machine
and had everything backed up. I had another iMac at home. I plugged in and
formatted the new drive, inserted my Snow Leopard (OS X) CD into it, and
installed the system onto the new drive. I created a new user called 'aijaz2'
- I didn't want to use a name that would conflict with a name on the laptop.

Then, I made sure I booted off the new hard drive, logged in as aijaz2,
attached my Time Machine external drive to the iMac as well and ran 'Migration
Assistant.' One of the options is to migrate from another drive or from a Time
Machine backup. I chose that option and was presented with two options -
migrate from the internal hard drive or from my Time Machine Backup. I chose
the latter, and about 90 minutes later had restored the my entire laptop on
this external hard drive.

The reason for all this is that I don't think my MacBook Pro will be ready
before I leave. I'm gonna use my brother's laptop instead. All I need to do is
attach the new Lacie hard drive to his MacBook Pro, boot off the external
drive and voila! I'm good to go.

I writing this up so that it might help someone else if they're faced with the
same problem.

To sum up: a) I really like Apple's service, and this is the third time I have
taken my MacBook to them and have had them rescue it for free - after the
warranty expired. Once it was a faulty battery, once it was me messing up the
system files, and now a video driver issue.

b) (and this really important) Back up your files. You don't have to use Time
Machine. You could use the Finder, rsync, scp, or any 3rd party service. I
like Time Machine because it's simple and 'always on.' And I have been a
system and network administrator. There is no shame in liking 'simple' :)
