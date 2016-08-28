---
comments: false
date: '2010-07-17 00:21:53'
slug: processing-a-list-of-files-in-bash
title: Processing A List Of Files In bash
Category:
- Computers
tags:
- bash
- Productivity
- Shell
---

When you're working in Unix or Linux or even Mac OS X, there are often times
when you need to apply the same command to a list of files.  In this post I'll
show you a couple of quick ways to do this using the bash shell.
<!-- more -->

Let's assume you have a command called _process_ that takes a file name
as its input and processes the file in place.  For example, if you want to
process the file at _/tmp/f1_, the command would be
    
~~~~{.bash}
process /tmp/f1
~~~~
  
Let's also say that after processing a file you want to archive it, using
the _archive_ command.

Now, if you want to process and archive files _/tmp/f1_,
_/tmp/f2_ and _/tmp/f3_ you could either do this:

~~~~{.bash}
./process /tmp/f1
./archive /tmp/f1
./process /tmp/f2
./archive /tmp/f2
./process /tmp/f3
./archive /tmp/f3
~~~~
    
or, you could use the bash keyword _for_ and process all files in a
loop like this:

~~~~{.bash}
for f in /tmp/f1 /tmp/f2 /tmp/f3
do
    ./process $f
    ./archive $f
done
~~~~
    
That's a lot less typing.  Let's look at this loop closely:

A _for_ loop used like this has three key components: the loop
variable, the loop list and the loop body.  Let's identify them in reverse
order: The loop body is the part between the _do_ and _done_
keywords.  The loop list is the list of 'things' over which you want the for
loop to iterate.  In this case, the loop list is the list of files _/tmp/f1_
through _/tmp/f3_.  Note that the items in the loop list are separated by
spaces.

The last component that makes the for loop work is the loop variable.  In this
example the loop variable is called _f_.  This means that in the body
of the loop, the loop variable _f_ will be used as a placeholder for
each of the items in the loop list.

The first time through the loop, the loop variable _f_ will have the
value _/tmp/f1_.  To refer to the value of the loop variable, you put a
'$' before its name.  That's why the body of the loop contains _process
$f_ and not _process f_.  _process f_ would attempt to
process a file named 'f', while _process $f_ processes _/tmp/f1_ (in the
first iteration of the loop).

Let's test this out just to be sure.  Let's create a dummy _process_
program that does nothing other than print out the name of the file it's
processing.

~~~~{.bash}
#!/bin/bash  
echo "process - processing file $1";
~~~~
  
Let's also create an _archive_ program that prints out the name of the
file it's archiving:

~~~~{.bash}
#!/bin/bash  
echo "archive - archiving file $1";
~~~~
  
Now, you could type the following on the command line:

~~~~{.bash}
for f in /tmp/f1 /tmp/f2 /tmp/f3
do
    ./process $f
    ./archive $f
done
~~~~
    
but if you're like me and you prefer to see everything on the same line, you
could instead type in the following one line:

~~~~{.bash}
for f in /tmp/f1 /tmp/f2 /tmp/f3; do ./process $f; ./archive $f; done
~~~~
    
What's different here is that you need the two semicolons (;) to tell bash
where the loop list and loop body end.

Whichever method you choose, you'll see the following output:

~~~~{.bash}
process - processing file /tmp/f1
archive - archiving file /tmp/f1
process - processing file /tmp/f2
archive - archiving file /tmp/f2
process - processing file /tmp/f3
archive - archiving file /tmp/f3
~~~~

As you can see, the loop body was executed three times, and each time the
value of the loop variable f was used wherever there was a _$f_ in the
loop body.

### Using Wildcards With Loops

Sometimes you may have so many files in the loop list that you don't want to
type all their names onto the comand line.  In cases like this you could use
wildcards.

Let's say you want to process all files whose names end with _.txt_.
You can do that by replacing the loop list with the appropriate regular
expression:

~~~~{.bash}
for f in *.txt; do ./process $f; ./archive $f; done
~~~~
    
Now, even if you have a hundred _.txt_ files to process, this short
command line will still work for you.

If you want to process all _.txt_ and _.jpg_ files, you could
use either of the following two methods:

~~~~{.bash}
for f in *.txt *.jpg ; do ./process $f; ./archive $f; done
~~~~

or

~~~~{.bash}
for f in *.{txt,jpg}; do ./process $f; ./archive $f; done
~~~~

### In Conclusion

As you can see, it's easy to perform the same operations on a bunch of files
when you use loops.  Loops are exceptionally useful as one-time command-line
hacks.  It is important to remember that loops are not appropriate for every
task.  There are times when the loop body is so complex that it's safer to
abandon the command line method and instead 'factor out' the complexity into a
script in bash or other scripting language.

There are also times when the files on which you want to operate are all over
the disk drive, or in many subdirectories of the current directory.  As we'll
see in a later post, there are other common programs like 'find' that are
perfect in this case.
