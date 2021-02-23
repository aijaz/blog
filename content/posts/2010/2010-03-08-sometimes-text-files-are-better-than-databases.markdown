comments: false
date: '2010-03-08 21:08:33'
slug: sometimes-text-files-are-better-than-databases
title: Sometimes Text Files Are Better Than Databases
Category: Computers
Tags: Data, Database, Diff, Editors, GUI, Persistence, Programming, RDBMS, Representation, SSH, TaskForest, Text

<!-- ai l /wp/File.png /wp/File.png 108 136 A File -->

I remember in my first
Computer Programming class in college, the instructors wanted to make sure we
understood the concept of persistence by saving application data to disk.  To
keep things simple we would serialize data and save it to text files.  Once we
learned advanced concepts we migrated to using relational databases.  As a
professional, most of the apps I see use an RDBMS like DB2, PostgreSQL, Sybase
or Oracle.  Text files have been relegated to the simple homework assignments
of Programming 101.

There are, however, many classes of applications for which text files are the
preferred means of storing data.  One of the main reasons is that **when data
is stored in a relational database, editing it is not a trivial task**.  A
well-normalized database is not easily updated via an SQL command line.  More
often than not, a dedicated, graphical editor is needed to model the complex
relationships.
<!-- more -->

Several years ago, when I wrote [TaskForest](http://www.taskforest.aijaz.net/), one
of the initial design requirements was that it be easily configurable with
just a shell prompt and one's favorite text editor. Many of the servers I
cared for for schools and non-profits were old boxes which I administered by
logging into them via ssh. So when it came to designing job definitions and
dependencies, I chose a text file representation. The benefits of text files
over a graphical user interface for this include:

### Easy Remote Access

All you need is the ability to get to a command line and a text editor on the machine that holds the data files. With the such low client access requirements, virtually any old machine that has internet access and an ssh client can be used to administer the system. I have often worked on my own taskforestd server from a local internet cafe using a Putty.exe downloaded minutes earlier.

### Mobile Access

Text files also make work relatively easy using a mobile ssh client like Idokorro Mobile SSH. A dedicated mobile client would be ideal, but short of that, the text file approach assures low bandwidth usage and easy-to-make changes.

### Flexibility

 The simple, easily parseable format of text files allows us to build richer graphical clients later that would use a graphical interface to specify relationships between jobs.

### Source Control

The text based format makes it easy to place the data files under source control. You can also easily _diff_ different versions of the same data file.

### _Grep_

When you have dozens of job group files and hundreds of jobs, you may need to answer questions like: "Are we still running Job J?" This can easily be answered by _grep_ping the files for job J.

### Low footprint

When you're designing an open-source application you may want to minimize the complexity of the system by not forcing dependencies on major subsystems like GUI libraries and Relational Databases.  Of course there is a point at which a such dependencies are inevitable - you have to periodically re-evaluate your decisions and determine whether decisions that were correct, say, a year ago are still correct today.

## Choosing A Text Format

In the case of the TaskForest project, the most difficult task by far was
choosing which text format to use.  I went through several iterations trying
to find one that was simple to read and write, and yet rich enough to model
the domain space completely.  What worked for me (and might work for you) was
to ask myself how I would represent the data I'm trying to save given just a
pencil and paper.  Drawing in a notebook gave me the flexibility to sketch and
edit easily, and once I had a good representation, converting that to a text
file was a simple task.
