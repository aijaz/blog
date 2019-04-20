title: "PostgreSQL Advisory Locks"
date: 2013-11-14 09:15
comments: false
description: Advisory Locks in PostgreSQL can prevent concurrent instances of jobs.  But they may not be the ideal tool. 
Category: Computers
Tags: PostgreSQL, Databases, Concurrency, TaskForest, Locks

[A recent post](http://hashrocket.com/blog/posts/advisory-locks-in-postgres) by
[Derek Parker](http://hashrocket.com/blog/rocketeers/derek-parker) introduced me to 
[advisory locks in PostgreSQL](http://www.postgresql.org/docs/9.2/static/explicit-locking.html#ADVISORY-LOCKS).  
Advisory locks are a very straightforward way to prevent multiple instances of a program from running at the same
time.  However, there are some cases when you shouldn't use the database to enforce this constraint. 

<!-- more -->

Parker has done a fine job explaining how advisory locks work, so there's no need for me to explain it again here.

Despite being a long-time PostgreSQL user I didn't know about them and how to use them to prevent concurrency.
It's a very good idea, but I don't expect to use this technique for a few important reasons: 

In some environments database connections are expensive.  You may need to 
delay creating a connection to a database until you absolutely must retrieve or store data.  At times like this 
you should not create a connection to database as soon as a program starts and then hang on to it all they way 
until termination - just to prevent concurrency.  There are other ways to do this.  

Also, your database transactions may be transient.  You may need to connect to and disconnect from 
several databases over the course of a 
long-running program.  Every time you use use the database to manage concurrency, you're preventing another job
from accessing a resource it needs.  Depending on your program, some successful flows of control in your program
may not need to access the database at all - for example if the program looks for the availability of data
from a third party before retrieving it and uploading it to the database.  Again, you shouldn't hang on to a resource if you don't need to.

Perhaps your program should be able to run properly even if the database is not accessible.  In many cases 
databases are run on dedicated machines so a developer has to consider what to do if the program launches when the 
database server is down.  In those cases you probably don't want the program to fail just because it can't get an 
exclusive lock on itself.  You may need to prevent concurrency even if the database is unavailable.

For these reasons I think one should only use advisory locks to prevent concurrency in very simple systems.  For 
such programs this is a very convenient and effective approach.  For anything even moderately complex I would 
recommend either implementing this in your code or using an external job scheduling system.  To implement it within
your code you could use locks on semaphore files.  If you're using 
[TaskForest](http://www.taskforest.com), the job scheduling system I wrote, you can use
[tokens](http://www.taskforest.com/docs/tokens.html) easily and effectively to prevent concurrency.

My thanks to Parker for introducing me to advisory locks.  If you have any comments or questions on 
anything I wrote here you can find me on Twitter, where I'm [@\_aijaz\_](http://twitter.com/_aijaz_).