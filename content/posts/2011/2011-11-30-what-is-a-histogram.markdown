---
comments: false
date: '2011-11-30 20:16:45'
slug: what-is-a-histogram
title: What Is A Histogram?
Category:
- Photography
tags:
- Histogram
---

A key aspect of good photography is exposure - the amount of light that enters
the lens.  One of the most useful tools a digital cameras has to help you
measure a photograph's exposure is the histogram. In order to learn how to use
it, you must first learn understand what a histogram is.

Let's pretend I teach a class of 20 students. One day I decide to give the
students a test in which they can score anywhere from 0 to 100 points.  After
grading the tests I want to see how the population of students did.  So I
graph the scores in a histogram. A histogram displays the distribution of
measured values across a population.  Let's make one now.
<!-- more -->

The following table lists my fictional students' scores:

    
    
    Alice       82
    Bob         79
    Chetan      88
    Darla       94
    Evan       100
    Fatima      89
    Gerard      96
    Harry       43
    Ibtissam    68
    Jack        56
    Kate        93
    Labiba      70
    Mary        76
    Noreen      83
    Ophelia     92
    Pablo       63
    Qazveen     84
    Rick        89
    Sophia      73
    Taline      89
    

  
The first thing I do is make a bunch of 'buckets' of values into which each
score should go.  The larger the bucket size the more scores it will have.
The smaller the bucket size the fewer scores it will have.  I choose a bucket
size of 5 points because that seems like a nice level of granularity.  5
points gives me the following 20 buckets:

    
    
    0-5
    6-10
    11-15
    16-20
    21-25
    26-30
    31-35
    36-40
    41-45
    46-50
    51-55
    56-60
    61-65
    66-70
    71-75
    76-80
    81-85
    86-90
    91-95
    96-100
    

  
I draw these buckets horizontally because that's how histograms are almost
always drawn:

    
    
    | | | | | | | | | | | | | | | | | | | | |
    0 5 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 1
        0 5 0 5 0 5 0 5 0 5 0 5 0 5 0 5 0 5 0
                                            0
    

  
The next thing I do is go through the list of scores and put each score in its
appropriate bucket.  I do this by marking an X in the appropriate bucket.
Alice scored 82, so I mark an X in the bucket between 80 and 85.  Bob got 79,
so I put an X in the bucket between 75 and 80.  When I'm done, the histogram
looks like this:

    
    
                                      X
                                    X X X
                                X X X X X X
                     X     X X X X X X X X X
    | | | | | | | | | | | | | | | | | | | | |
    0 5 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 1
        0 5 0 5 0 5 0 5 0 5 0 5 0 5 0 5 0 5 0
                                            0
    

  
The x axis of this histogram has the ranges of values (scores) and the y axis
represents the number of data points that have that value.

If you think about it, this histogram has less data than the original table
did - It doesn't map a student's name to their score.  However, it does
illustrate the distribution of the scores in a manner that isn't obvious from
the table: Looking at this histogram you can see that most students scored 75
or higher, and that more students scored in the 85-90 bucket than in any other
bucket.  We call distributions that look like this 'skewed to the right' -
most of the data points are towards the right end of the histogram.

Now that you know what histograms are, you're ready to use them to take better
photos.  I'll cover that in Monday's blog post.

## References

[Wikipedia entry on histograms.](http://en.wikipedia.org/wiki/Histogram)
