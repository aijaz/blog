---
comments: false
date: '2010-02-20 17:40:22'
slug: navigating-the-directory-stack-in-bash
title: Navigating the Directory Stack in 'bash'
Category:
- Computers
tags:
- bash
- Code
- My Software
- Productivity
- Shell
---

If you're like me, you spend a lot of time jumping from project to project in
a Linux shell.  I find that I have to switch back and forth between
directories.  The _bash_ shell has commands to maintain a
[stack](http://www.ece.cmu.edu/~koopman/stack_computers/sec1_2.html) of
directories.  I've written some functions that use these utilities to make
directory navigation easier. I've found these functions very useful, and
perhaps you will too. Let's see them in action first with some examples, and
then look at the code:
<!-- more -->

In this first snippet, I start working in the Documents/Training/qt/ch1
directory:

    
    
    {% codeblock lang:bash %}
    $ pwd
    /Users/aijaz
    $ cd Documents/Training/qt/ch1/
    $ ls
    p1    t2
    $
    {% endcodeblock %}
    

  
Now let's say I have to work in the TaskForest lib directory for a while:

    
    
    {% codeblock lang:bash %}
    $ cd ~/Projects/projects/taskforest/lib/TaskForest/
    $ ls -l
    total 352
    -rw-r--r--   1 aijaz  aijaz   8816 May 25  2009 Calendar.pm
    ...
    -rw-r--r--   1 aijaz  aijaz   4558 May 25  2009 TimeDependency.pm
    $
    {% endcodeblock %}
    

  
Now my work gets preempted because I have to work in the 'rates' directory:

    
    
    {% codeblock lang:bash %}
    $ cd ~/tc/config/rates/
    $ ls -l
    total 27544
    drwxr-xr-x  21 aijaz  aijaz       714 Sep  3  2007 Text
    ...
    -rwxr-xr-x   1 aijaz  aijaz       569 Sep  3  2007 findVoipAccess.pl
    $
    {% endcodeblock %}
    

  
After finishing my work in the rates directory, I want to get back to what I
was doing, but I can't remember exactly what where I was before I got
interrupted. So I enter the 'd' command which displays the stack of
directories. Every time I used the 'cd' command, the system pushed the
directory I was in onto a stack. The 'd' command displays the stack and
prompts me for an entry. If I enter a number, it pushes the directory that's
at that position in the stack to the top, and enters that directory.

    
    
    {% codeblock lang:bash %}
    $ d
     0  ~/tc/config/rates
     1  ~/Projects/projects/taskforest/lib/TaskForest
     2  ~/Documents/Training/qt/ch1
     3  ~
    #: 2
    $ pwd
    /Users/aijaz/Documents/Training/qt/ch1
    $ d
     0  ~/Documents/Training/qt/ch1
     1  ~/tc/config/rates
     2  ~/Projects/projects/taskforest/lib/TaskForest
     3  ~
    #: q
    $
    {% endcodeblock %}
    

  
You can see that when I entered '2' above, the 'd' command pushed the
'~/Documents/Training/qt/ch1' directory to the top of the stack and entered
that directory. You can see the modified directory stack above. I entered 'd'
again to view the directory stack, but this time entered 'q' to do nothing.

I've also created the 'p' command, which pops the current directory off the
top of the stack and enters the directory that was under it.

    
    
    {% codeblock lang:bash %}
    $ p
    $ pwd
    /Users/aijaz/tc/config/rates
    $ d
     0  ~/tc/config/rates
     1  ~/Projects/projects/taskforest/lib/TaskForest
     2  ~
    #: q
    $
    {% endcodeblock %}
    

  
Now let's have a look at the code that makes this work. You can copy and paste
this code directly into your _.bashrc_ file.

    
    
    {% codeblock lang:bash %}
    # An enhanced 'cd' - push directories
    # onto a stack as you navigate to it.
    #
    # The current directory is at the top
    # of the stack.
    #
    function stack_cd {
        if [ $1 ]; then
            # use the pushd bash command to push the directory
            # to the top of the stack, and enter that directory
            pushd "$1" > /dev/null
        else
            # the normal cd behavior is to enter $HOME if no
            # arguments are specified
            pushd $HOME > /dev/null
        fi
    }
    # the cd command is now an alias to the stack_cd function
    #
    alias cd=stack_cd  
    # Swap the top two directories on the stack
    #
    function swap {
        pushd > /dev/null
    }
    # s is an alias to the swap function
    alias s=swap  
    # Pop the top (current) directory off the stack
    # and move to the next directory
    #
    function pop_stack {
        popd > /dev/null
    }
    alias p=pop_stack  
    # Display the stack of directories and prompt
    # the user for an entry.
    #
    # If the user enters 'p', pop the stack.
    # If the user enters a number, move that
    # directory to the top of the stack
    # If the user enters 'q', don't do anything.
    #
    function display_stack
    {
        dirs -v
        echo -n "#: "
        read dir
        if [[ $dir = 'p' ]]; then
            pushd > /dev/null
        elif [[ $dir != 'q' ]]; then
            d=$(dirs -l +$dir);
            popd +$dir > /dev/null
            pushd "$d" > /dev/null
        fi
    }
    alias d=display_stack
    {% endcodeblock %}
    
