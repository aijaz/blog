---
comments: false
date: '2011-12-02 09:00:52'
slug: how-to-quickly-delete-words-while-in-insert-mode-in-vim
title: How To Quickly Delete Words While In Insert Mode In Vim
Category:
- Computers
tags:
- Editors
- Productivity
- Vim
---

[Another in my [series of posts on Vim](/2011/11/21/there-and-back-again-a-hackers-switch-from-emacs-back-to-vi/)]

Sometimes when you're typing natural language text, you find yourself wanting
to rephrase the sentence you've written so far.  You could hit backspace many
times to delete the characters to the left of the cursor, or you could type
Ctrl-W.  When you're in Insert mode, Ctrl-W will delete from the cursor to the
beginning of the previous word.
<!-- more -->

If, instead, you type in Ctrl-U, you will delete everything to the left of the
cursor on that line (everything before it), and preserve everything to the
right of the cursor (everything after it).

Let's try this out.  Open a test file in Vim and enter Insert mode by hitting
```a``` or ```i``` or ```o```.  Then type in the following sentence (don't hit ```<ESC>```):

    
    
    A slow brown dog lazed 
    

  
Then hit ```Ctrl-W``` twice.  You'll see that each time you hit ```Ctrl-W```, you delete
the word to the left of the cursor.  After hitting ```Ctrl-W``` twice, you should
see:

    
    
    A slow brown 
    

  
Then continue with the rest of the sentence.  Type in 'fox jumps over a lazy
dog.'  After typing that in, still in Insert mode, use the arrow keys to move
your cursor just before the 'b' in 'brown':

    
    
    A slow brown fox jumps over a lazy dog
           ^
           Your cursor should be just to the left of the 'b'
    

  
The hit ```Ctrl-U```.  Everything to the left of the cursor will be deleted, leaving
you with:

    
    
    brown fox jumps over a lazy dog
    

  
Then you an continue typing in 'The quick' , which will get you:

    
    
    The quick brown fox jumps over a lazy dog
    

  
I've found that learning these little shortcuts really helps me type
efficiently and keep my typing in sync with my thoughts.
