comments: false
date: '2011-12-07 07:00:01'
slug: how-to-wrap-text-in-vim
title: How To Wrap Text In Vim
Category: Computers
Tags: Editors, Vim, Wrap

[Another in my [series of posts on Vim](/2011/11/21/there-and-back-again-a-hackers-switch-from-emacs-back-to-vi/)]

If you're writing natural language text you may wish to format your paragraph
so that the text wraps before lines get too long. Here's how you do it:

To set the maximum width of a line of text, go to Normal mode and enter

    
    
    :set textwidth=72
    
<!-- more -->
  
This will set the maximum width of a line to 72.  If you want to reformat a
paragraph you have already typed, one easy way to do this is to type in ```{gw}```.
    
The first ```{``` takes you to the beginning of the paragraph. ```gw``` formats all
the text between the current location and the point you would be taken to had
you typed in the motion command that follows the gq.  In this case the motion
command is ```}``` which means go to the beginning of the next paragraph.  So, ```gw}```
formats the rest of the paragraph but leaves the cursor where it was.  If you
want to move the cursor to the the location indicated by the motion command,
then use ```gq``` instead of ```gw```.

Why would you want to use ```gq```?  Simple: when you have a bunch of paragraphs you
want to format or reformat, you can use ```gq}``` once and then hit ```.``` to repeat
the previous command over and over again.  There are other shortcuts to
reformat an entire file.  We'll look into those later.

Like emacs, Vim has very powerful paragraph reformatting commands.  In future
blog posts we'll look at some of them in more detail.  If you want to explore
them on your own, I would suggest you enter

    :help gq 
    :help formatoptions
