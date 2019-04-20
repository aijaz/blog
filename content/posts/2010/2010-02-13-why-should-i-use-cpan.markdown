comments: false
date: '2010-02-13 19:01:08'
slug: why-should-i-use-cpan
title: Why Should I Use CPAN?
Category: Computers
Tags: CPAN, Perl, TaskForest, Testing

I came across some comments made about an open source program that I had
written in perl.  The user was complaining about how he couldn't get it to
install.  The reason was that the program relies on other modules from the
archive of open source perl software known as [CPAN (Comprehensive Perl Archive Network)](http://www.cpan.org/), and one of them failed to install.
<!-- more -->

This got me thinking about the benefits of using third-party libraries in our
own code.  Why should a program depend on so many external modules when it
could implement what it needs itself?

The answer, in one word, is "Testing."  A well-written piece of software isn't
considered complete if it doesn't have well-documented tests that exercise
every part of the program.

There are many common tasks that most programs perform - such as reading
configuration food, performing date arithmetic and writing to log files.
Every popular language has third-party libraries that perform these tasks
correctly and reliably.  If I were to try to duplicate them, it would almost
certainly result in inferior code; the mature libraries have had the benefits
of extensive testing as well as enhancements and fixes of bugs reported by
users.  Using third-party software allows me to focus on my program and what
makes it unique.

<!-- ai c /wp/camel.jpg /wp/camel-439x293.jpg 439 293 Perl can be a little stubborn, sometimes. -->
