---
title: "Who Wrote This?"
date: 2015-09-19 23:17
comments: false
Category:
- Computers
tags:
- 30days
- Programming
- Comments
description: "Is it ever a bad idea to sign your name on good code that you write?"
---

Is it ever a bad idea to sign your name on good code that you write?

<!-- more -->

This is the what I was wondering a few days ago when I was examining some legacy code for a friend. This code had changed owners several times. By the time I got to look at it, it was in pretty bad shape. For example, there were magic numbers that were being used as tags for views, and there were calls to functions that did not exist. Of course, building the code would result in dozens of warnings, all of which were apparently being ignored by the most recent developer. 

As I looked deeper into the code I was surprised to see that some files had `Created by: ` metadata in their comments that contained names that I recognized. In many cases these were names of developers who I know and trust to be very thorough and who wouldn't write code like this. 

It became apparent that the early versions of the code were written by my friends. That's why their names are in the file headers. But over the years others have come along and horribly defiled their clean code. And here's what's interesting: if you don't (or can't) look at the original commit history, you'll erroneously think that the people who first created the file are responsible for its current state.

So I wonder: If you're a consultant (or agency) who comes in and works on a project, could it actually hurt you to have your name in the comments in a file? In this case I think the answer is "Yes." For whatever reason I don't have the ability to look at the commit history from several years ago. So I cannot verify who, ultimately, is responsible for getting this code into this state. If my friends' names weren't in the file headers, at least then they wouldn't be 'suspects.'

See you tomorrow.

_This is the 19th of my [30 days][] posts._

[30 days]: /2015/08/31/30-days/
