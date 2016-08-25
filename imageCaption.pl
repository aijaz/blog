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
    # i imageURL caption
    $line =~ s^<!-- ([lcr])\s+(\S+)\s+(.*?)\s*-->^makeSimpleImageDiv($2, $3, $1)^ge;

    $line =~ s^<!-- ai\s+(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->^makeDiv($1, $2, $3, $4, $5, $6)^ge;
    $line =~ s#<!-- photo\s+\^([^\^]+)\^\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->#makePhoto($1, $2, $3, $4, $5, $6)#ge;
}

# Save the possibly modified contents of the 'lines' array
# back to the original file
#
open (O, ">$file") || die;
print O join("", @lines);
close O;

sub getSizeOfImage {
    my ($image) = @_;

    my $size = `identify $image | cut -d ' ' -f 3`;

    my ($w, $h) = $size =~ /(\d+)x(\d+)/;

    #print STDERR "SIZE OF IMAGE: $image is $w x $h\n";

    return ($w, $h);
}

sub makeSimpleImageDiv {

    my ($image, $caption, $align) = @_;

    #print STDERR "In makeSimpleImageDiv\n";

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
    
    my $maxWidthInPoints = 720;
    my $maxWidthInPixels = $maxWidthInPoints * 2;
    my $originalFileName = "./content/$image";
    my ($width, $height) = getSizeOfImage($originalFileName);

    if ($image =~ /\@2x/) {
        # make lowerResImage if necessary
        my $nonRetinaFileName = $originalFileName;
        $nonRetinaFileName =~ s/\@2x//;

        if (-e $nonRetinaFileName) { 
            # don't do anything
                my $nonRetinaWidth = int($width / 2);
                my $nonRetinaHeight = int($height / 2);
                $width = $nonRetinaWidth;
                $height = $nonRetinaHeight;
        }
        else { 
            # resize if necessary
            if ($width > $maxWidthInPixels) {
                #print STDERR "RETINA TOO WIDE: $width\n";
                my $newWidth = $maxWidthInPixels;
                my $newHeight = int($newWidth * $height / $width);
                my $convertedFileName = $originalFileName.".temp";
                `convert $originalFileName -resize ${newWidth}x${newHeight} $convertedFileName`;
                `mv $convertedFileName $originalFileName`;
                my $nonRetinaWidth = int($newWidth / 2);
                my $nonRetinaHeight = int($newHeight / 2);
                `convert $originalFileName -resize ${nonRetinaWidth}x${nonRetinaHeight} $nonRetinaFileName`;
                $width = $nonRetinaWidth;
                $height = $nonRetinaHeight;
            }
            else { 
                #print STDERR "RETINA NOT TOO WIDE: $width\n";
                my $nonRetinaWidth = int($width / 2);
                my $nonRetinaHeight = int($height / 2);
                `convert $originalFileName -resize ${nonRetinaWidth}x${nonRetinaHeight} $nonRetinaFileName`;
                $width = $nonRetinaWidth;
                $height = $nonRetinaHeight;
            }
        }
        $image =~ s/\@2x//;

    }
    else {
        if ($width > $maxWidthInPoints) { 
            # resize
                my $newWidth = $maxWidthInPoints;
                my $newHeight = int($newWidth * $height / $width);
                my $convertedFileName = $originalFileName.".temp";
                `convert $originalFileName -resize ${newWidth}x${newHeight} $convertedFileName`;
                `mv $convertedFileName $originalFileName`;
                $width = $newWidth;
                $height = $newHeight;
        }
    }
    
    my $div_width = $width + $width_inc;

    # Construct the html.  Note that the css class is
    # 'ai' followed by the value of the 'align' component.
    #
    return join("",
        qq^<div class="ai$align" style="width:${div_width}px">^,
                qq^<img src="$image" ^,
                    qq^width="$width" ^,
                    qq^height="$height" ^,
                    qq^alt="$caption" ^,
                    qq^border=0><br>^,
            qq^$caption</div>^);
}


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

sub makePhoto {

    # The enclosing div should be this much bigger
    # than the image.  This accounts for the white margin
    # that octopress puts around the image
    #
    my $width_inc = 20;

    my ($alt, $target, $image, 
        $width, $height, $caption) = @_;
    
    my $div_width = $width + $width_inc;

    # Construct the html.  Note that the css class is
    # 'ai' followed by the value of the 'align' component.
    #
    return join("",
        qq^<div> <div class="aic" style="width:${div_width}px">^,
            qq^<a href="$target" title="$alt">^,
                qq^<img src="$image" ^,
                    qq^width="$width" ^,
                    qq^height="$height" ^,
                    qq^alt="$alt" ^,
                    qq^border=0></a><br>^,
            qq^</div><div class=photoExifCenter>$caption</div></div>^);
}

