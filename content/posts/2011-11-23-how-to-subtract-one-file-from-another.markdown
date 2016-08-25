---
comments: false
date: '2011-11-23 14:45:26'
slug: how-to-subtract-one-file-from-another
title: How To Subtract One File From Another
Category:
- Computers
tags:
- bash
- grep
- Text
---

Let's say you have two text files, FileA and FileB.  You want a file that has
all the lines of FileA that are_ not_ in FileB.  How do you do that?

The simple answer is ```grep```. The ```-v``` option inverts the search, and only prints
lines that do not match.  The ```-f``` option is used to specify a file that
contains a list of all the patterns for which to look - one pattern per line.
<!-- more -->

Let's say FileA looks like this:

    
    
    1 Alice 10
    2 Bob   15
    3 Alice 16
    4 Carl  10
    5 Dave  20
    

  
and FileB looks like this:

    
    
    2 Bob   15
    4 Carl  10
    

  
Then, you can use the following command to print out all lines from FileA that
are not in FileB:

    
{% codeblock lang:bash %}
    $ grep -vf FileB FileA
    1 Alice 10
    3 Alice 16
    5 Dave  20
    $ 
{% endcodeblock %}    

  
You could, alternatively, have gotten the same results if FileB looked like
this:

    
    
    .*Bob.*
    .*Carl.*
    
