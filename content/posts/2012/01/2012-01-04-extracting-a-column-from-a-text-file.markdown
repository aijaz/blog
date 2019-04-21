title: Shell Tricks - Extracting A Column From A Text File
date: 2012-01-04 21:25
comments: false
Category: Computers
Tags: UNIX, Text, cut, nl

There have been times when I've had to extract a particular column from a
tab-separated or comma-separated file.  The best way to do this is to use the
shell command ```cut```.  Let's say I have a file named ```input.txt``` that looks like this: 

<!-- more -->

{% include_code cut/input.txt lang:apacheconf %}

If I want to extract just the ```User Id``` column, I could type in the following:

    cut -d ',' -f 3 input.txt

Here the ```-d``` option specifies the delimeter and the ```-f``` option specifies the field(s) to be extracted. 
The command above would generate the following output:

    User Id
    aijaz
    js
    guptas
    
If I want to include line numbers, I can use the ```nl``` shell filter:

    $ cut -d ',' -f 3 input.txt | nl -ba
         1	User Id
         2	aijaz
         3	js
         4	guptas
    $ 

If I want the ```User Id``` and ```Used``` columns, I could do:

    $ cut -d ',' -f 3,5 input.txt 
    User Id,Used
    aijaz,2200
    js,3300
    guptas,1500
    $ 

As one would expect, I can change the order in which fields appear by using ```-f 3,5,1```, for instance.

Look at the _man_ page for ```cut``` for more options, including how to extract specific bytes from each line.

