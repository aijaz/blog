#!/usr/bin/perl
if (/^---/) { $dashes++; }
    s/^author:.*//i;
    s/^layout:.*//i;
    s/^status:.*//i;
    s/^categories:/Category:/i;

    # s/\<\!\-\- +ai +c +(\S+) +(.*) +\-\-\>/\[\{\% img img-center $2 %}]($1)/g;
    # s/\<\!\-\- +ai +l +(\S+) +(.*) +\-\-\>/\[\{\% img pull-left $2 %}]($1)/g;
    # s/\<\!\-\- +ai +r +(\S+) +(.*) +\-\-\>/\[\{\% img pull-right $2 %}]($1)/g;

s/<!-- *more *-->/<!-- more -->/;

    if ($dashes > 1 || /\S/) { print; }