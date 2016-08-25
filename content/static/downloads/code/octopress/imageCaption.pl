#!/usr/bin/perl

use strict;
use warnings;

# The file that was specified on the command line
#
my $file = shift;

# Read all lines from the file into a list named 'lines'
#
open (I, $file) || die;
my @lines = <I>;
close I;

# Scan each line for our special markup: 
# a comment that starts with ai and then has upto 6
# space-separated components
#
# For each such line, call makeDiv on the components and 
# replace the markup with the output of that function
#
foreach my $line (@lines) { 
    $line =~ s^<!-- ai\s+(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->^makeDiv($1, $2, $3, $4, $5, $6)^ge;
}

# Save the possibly modified contents of the 'lines' array
# back to the original file
#
open (O, ">$file") || die;
print O join("", @lines);
close O;


sub makeDiv {

    # The enclosing div should be this much bigger
    # than the image.  This accounts for the white margin
    # that octopress puts around the image
    #
    my $width_inc = 20;

    # The 6 components in our markup are
    # align:   'l', 'c' or 'r'.  Used to specify the
    #          css class
    # target:  The href of the a tag that's put around
    #          the image
    # image:   The URL of the image 
    # width:   The width of the image
    # height:  The height of the image
    # caption: This is used as the alt tag of the image, 
    #          the title of the a tag as well as the 
    #          caption that's displayed under the image.
    #          This field may be blank, but don't do that 
    #          because really, that's the whole point of 
    #          this exercise.
    #
    my ($align, $target, $image, 
        $width, $height, $caption) = @_;
    
    my $div_width = $width + $width_inc;

    # Construct the html.  Note that the css class is
    # 'ai' followed by the value of the 'align' component.
    #
    return join("",
        qq^<div class="ai$align" style="width:${div_width}px">^,
            qq^<a href="$target" title="$caption">^,
                qq^<img src="$image" ^,
                    qq^width="$width" ^,
                    qq^height="$height" ^,
                    qq^alt="$caption" ^,
                    qq^border=0></a><br>^,
            qq^$caption</div>^);
}

