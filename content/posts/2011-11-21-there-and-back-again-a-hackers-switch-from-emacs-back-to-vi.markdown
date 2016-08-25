---
comments: false
date: '2011-11-21 14:55:49'
slug: there-and-back-again-a-hackers-switch-from-emacs-back-to-vi
title: There and Back Again - A Hacker's Switch from Emacs Back to Vi
Category:
- Computers
tags:
- Editors
- Emacs
- Stallman
- VI
- Vim
---

When I first learned how to exist on UNIX, in 1988, I used
[vi](http://en.wikipedia.org/wiki/Vi) as my primary editor. During the next
nine years I taught myself how to become a power user - migrating from the
simple motion and copy and paste to more complex skills like marks and named
registers. When I started graduate school I saw many of the professors and
grad students using [emacs](http://www.gnu.org/s/emacs/).  I tried it out a
couple of times, but it was not until 1997 that I decided to take the time to
stick with emacs and take the time to learn the right way to do things even
when I could get the job done faster in vi.
<!-- more -->

I used emacs almost exclusively after that. I got myself a couple of books,
browsed the gnu.emacs newsgroup and wrote my own elisp code for matching HTML
tags, among other things. For a while I used rmail from within emacs as my
primary news client, used org-mode as an issue and task manager and even
flirted with the idea of using emacs as a web browser. I used emacs for half a
generation and didn't think I would switch back to vi for daily work.

But switch back I did, in November of 2011.  After Richard Stallman, the
inventor of emacs made some controversial comments about the passing of Steve
Jobs, the angered Mac and iOS developer community starting posting some of the
more polarizing of his writings.  Reading them I realized that Stallman and I
held conflicting opinions about some issues I consider very important - namely
the importance of one's family and the relative importance of emacs in the
Grand Scheme Of Things.

I was surprised by my reaction to Stallman's opinions.  Like him, I care
deeply about the skill of editing text. But I could not separate my dislike
for Stallman's worldview from my enthusiasm towards the platform. To me it was
inevitable that I would switch away from emacs. I wanted to show myself that
to me, at least, emacs was never a religion - it was never the One True Way.
It is a fantastic editor, but no more. I wanted to convince myself that there
could be life after emacs - that Stallman was wrong - that I could continue to
be productive and excel with an editor other than emacs. So I decided to
switch to [vim](http://www.vim.org).

As I relearn vi through vim I'll post what I learn here.  If you're a vim
user, please join the discussion and post your comments, suggestions,
disagreements, etc.  That will not just help you and me, but others who happen
upon this page while trying to learn something.

## The First Vim Tip

I'll start off with a discussion how to do something in vim that I could never
do in vi, and that I did all the time in emacs - rectangular selections. In my
line of work I often need to select a rectangle of text and operate upon it; I
may need to delete the rectangle of text, or I may have to append something to
either of the two edges, or delete something from either of the two edges. In
emacs I would use C-x r k and C-x r y to kill and yank, for example. In vim
we can use visual mode.

There are three different kinds of visual modes.  Each operates on text
differently, and each is invoked differently.  To get to 'normal' visual mode,
hit 'v' when in command mode. To get to the 'rectangular' visual mode, hit C-v
(hit Shift-V for line visual mode).  This will allow you to use your cursor to
highlight a rectangle of text and easily see the scope of your next commands.

Once you have the proper rectangle highlighted, you can delete it by hitting
'd'.  You can insert text to the left edge of every line by hitting 'I' and
inserting the text.  You will have to end with an ESC, and not enter any
newlines (or else the editor will treat it like a normal insertion).  You can
also insert text to the right edge of every line by hitting I and inserting
the text.  Again you will have to end with an ESC, for the same reasons as
before.  You can copy (yank) the rectangle by hitting 'y'.

[Update 11/29 - Changed header to "The first Vim Tip"]

---

### Update 2012/06/30

Ok.  I tried.  I really did.  Real hard.  But I wound up switching back to
emacs.  The main reason was that using vim was making me less productive.
That's not because vim makes one less productive, but because the frequent
context switching between vim and XCode and other Mac Editors like Coda
was getting me confused.  I was using vim keystrokes in XCode and
vice-versa.  Almost all Mac OS X apps (including system apps) understand
emacs cursor movement key bindings, and teaching myself conflicting
commands was slowing down the entire process.

As they say on _Mythbusters_, the experiment didn't achieve the intended
results, but that in itself is not a failure, because I learned something
along the way.  So until further notice, I'm back to emacs.
