#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $file = "";
my $publish = 0;
&Getopt::Long::GetOptions (
            "file=s"   => \$file,      # string
            "publish"  => \$publish)   # flag
or die("Error in command line arguments\n");

my $CDNURL = "";
if ($publish) {
    $CDNURL = 'https://d6lhccxzavsvw.cloudfront.net';
}
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
if ($file =~ /2009/ || $file =~ /201[012345678]/) {
    foreach my $line (@lines) { 
        # 30 or so
        $line =~ s^<!-- ([lcr])\s+(\S+)\s+(.*?)\s*-->^makeSimpleImageDiv($2, $3, $1)^ge;

        # 109
        $line =~ s^<!-- ai\s+(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->^makeDiv($1, $2, $3, $4, $5, $6)^ge;

        # not used
        $line =~ s#<!-- photo\s+\^([^\^]+)\^\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->#makePhoto($1, $2, $3, $4, $5, $6)#ge;
    }
}
else {
    foreach my $line (@lines) { 
        # i imageURL caption
        # $line =~ s^<!-- ([lcr])\s+(\S+)\s+(.*?)\s*-->^makeSimpleImageDiv($2, $3, $1)^ge;
        # $line =~ s^<!-- ai\s+(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->^makeDiv($1, $2, $3, $4, $5, $6)^ge;
        # $line =~ s#<!-- photo\s+\^([^\^]+)\^\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(.*?)\s*-->#makePhoto($1, $2, $3, $4, $5, $6)#ge;
        # 1
        $line =~ s^<!--\s*img\s+(\S+)\s+(\S+)\s+(\S+)\s+(.*?)\s*-->^makeResponsiveDiv($1, $2, $3, $4)^ge;

        # 1 (about)
        $line =~ s^<!--\s*il\s+(\S+)\s+(\S+)\s+(\S+)\s+(.*?)\s*-->^makeResponsiveLeftDiv($1, $2, $3, $4)^ge;

        # 0
        $line =~ s^<!--\s*yt\s+(\S+)\s+(.*?)\s*-->^makeResponsiveYTDiv($1, $2, $3, $4)^ge;

        # 3 or so
        $line =~ s[\(\s*AijazCC\s*\)][&copy; 2019 <a xmlns:cc="http://creativecommons.org/ns#" href="https://aijaz.net" property="cc:attributionName" rel="cc:attributionURL">Aijaz Ansari</a>, and is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>]ig;
    }
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

sub makeResponsiveYTDiv {
    my ($vid, $caption) = @_;

    $caption =~ s/[^a-zA-Z0-9 \*\+\,\.\:\-\;\!\[\]\(\)\&]//g;

    return qq[
        <div class="respImg">
            <div class="video-container">
                <iframe width="320" height="180" src="https://www.youtube.com/embed/$vid" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
            </div>
            $caption
        </div>
];

}
sub makeResponsiveDiv {

    # The enclosing div should be this much bigger
    # than the image.  This accounts for the white margin
    # that octopress puts around the image
    #
    my $width_inc = 20;

    # The 6 components in our markup are
    # dir:      The directory that the images are stored in
    # ext:      The extension of the image
    # footnote: The number of the footnote to be used for
    #           credit
    # caption:  This is used as the alt tag of the image, 
    #           and the caption that's displayed under it.
    #           This field may be blank, but don't do that 
    #           because really, that's the whole point of 
    #           this exercise.
    #


    my ($dir, $ext, $footnote, $caption) = @_;

    $caption =~ s/[^a-zA-Z0-9 \*\+\,\.\:\-\;\!\[\]\(\)\&]//g;
    
    # make resized images if necessary
    # the images need to have the following widths: 
    # 1x:  320px,  480px,  640px,  714px
    # 2x:  640px,  960px, 1280px, 1428px
    # 3x:  960px, 1440px, 1920px, 2142px
    # 4x: 1280px, 1920px, 2560px, 2856px
    my @requiredWidths = (320, 480, 640, 714, 960, 1280, 1428, 1440, 1920, 2142, 2560, 2856);

    $dir = "static/images/$dir";

    foreach my $width (@requiredWidths) {
        my $fileName = "content/$dir/gen/$width.$ext";
        next if -e $fileName;
        if (! -d "content/$dir/gen") { `mkdir "content/$dir/gen"`; }
        my $widthIfGreater = $width.">";
        my $command = "convert content/$dir/original.$ext -resize '$widthIfGreater' $fileName";
        `$command`;
        `mkdir -p output/$dir/gen`;
        `cp $fileName output/$dir/gen/$width.$ext`;
        print ("Generated $fileName\n");
    }

    my @srcSets = map { "$CDNURL/$dir/gen/$_.$ext ${_}w" } @requiredWidths;
    my $srcSetString = join (",\n         ", @srcSets);
    my $sizes = qq[(max-width: 320px) 320px, 
         (max-width: 480px) 480px, 
         (max-width: 640px) 640px, 
         714px];
    my $imageStr = qq[
<img class="pure-img" 
     src="$CDNURL/$dir/gen/320.$ext" 
     alt="$caption" 
     srcset="
         $srcSetString
     " 
     sizes="
         $sizes  
     "
     >
];

    my $footNoteString = qq[<sup id="fnref:$footnote"><a class="footnote-ref" href="#fn:$footnote">$footnote</a></sup>];
    return qq[<div class="respImg"><div class="pure-img">$imageStr</div>$caption&nbsp;$footNoteString</div>];
}

sub makeResponsiveLeftDiv {

    # The enclosing div should be this much bigger
    # than the image.  This accounts for the white margin
    # that octopress puts around the image
    #
    my $width_inc = 20;

    # The 6 components in our markup are
    # dir:      The directory that the images are stored in
    # ext:      The extension of the image
    # footnote: The number of the footnote to be used for
    #           credit
    # caption:  This is used as the alt tag of the image, 
    #           and the caption that's displayed under it.
    #           This field may be blank, but don't do that 
    #           because really, that's the whole point of 
    #           this exercise.
    #


    my ($dir, $ext, $footnote, $caption) = @_;

    $caption =~ s/[^a-zA-Z0-9 \*\+\,\.\:\-\;\!\[\]\(\)\&]//g;
    
    # make resized images if necessary
    # the images need to have the following widths: 
    # 1x:  320px,  480px,  640px,  714px
    # 2x:  640px,  960px, 1280px, 1428px
    # 3x:  960px, 1440px, 1920px, 2142px
    # 4x: 1280px, 1920px, 2560px, 2856px
    my @requiredWidths = (320, 480, 640, 714, 960, 1280, 1428, 1440, 1920, 2142, 2560, 2856);

    $dir = "static/images/$dir";

    foreach my $width (@requiredWidths) {
        my $fileName = "content/$dir/gen/$width.$ext";
        next if -e $fileName;
        if (! -d "content/$dir/gen") { `mkdir "content/$dir/gen"`; }
        my $widthIfGreater = $width.">";
        my $command = "convert content/$dir/original.$ext -resize '$widthIfGreater' $fileName";
        `$command`;
        `mkdir -p output/$dir/gen`;
        `cp $fileName output/$dir/gen/$width.$ext`;
        print ("Generated $fileName\n");
    }

    my @srcSets = map { "$CDNURL/$dir/gen/$_.$ext ${_}w" } @requiredWidths;
    my $srcSetString = join (",\n         ", @srcSets);
    my $sizes = qq[(max-width: 320px) 320px, 
         (max-width: 480px) 480px, 
         (max-width: 640px) 640px, 
         714px];
    my $imageStr = qq[
<img width=160 height=160 align=left style="margin-right: 1em" 
     src="$CDNURL/$dir/gen/320.$ext" 
     alt="$caption" 
     srcset="
         $srcSetString
     " 
     sizes="
         $sizes  
     "
     >
];

    my $footNoteString = qq[];
    return qq[<div class="pure-img">$imageStr</div>];
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

