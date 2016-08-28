---
comments: false
date: '2011-11-28 23:02:08'
slug: how-to-insert-a-line-of-dashes-in-vim
title: How To Insert A Line Of Dashes In Vim
Category:
- Computers
tags:
- Coding
- Editors
- Productivity
- Vim
---

[Another in my [series of posts on Vim](/2011/11/21/there-and-back-again-a-hackers-switch-from-emacs-back-to-vi/)]

If you're a developer, you will often find yourself having to insert a line of
dashes or hashes (#) or asterisks into your comments.  In this post I'll show
you how to do this quickly.  Memorize this because you'll wind up doing this
often.  Position the cursor to the beginning of a blank like (in command mode)
and enter the following:

    80a#<ESC>
<!-- more -->

The '80' tells Vim that you want to repeat the next command 80 times.  The
command immediately follows: ```a#```.  This command instructs vi to add a hash
character to the right of the cursor.  You terminate the command with the
```<ESC>```.
