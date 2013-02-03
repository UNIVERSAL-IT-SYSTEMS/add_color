 ----- add_color:

 takes a stream or a filename as input and outputs with ansi color
 codes added to individual lines of text.

 use:

    $ ./add_color.pl /text/file/with/custom_tags.txt
    $ ping google.com | ./add_color.pl

 params:

    -h --help   print this message
    <filename>  the file to be read and ouput with color

 notes:

    usually i use this to highlight certain messages in logs.
    By piping the output of this script into less -r you can get
    a much nicer ui for analyzing logs.

    You can configure this script by modifying it manually. The
    %modifications hash is used to set regular expressions for
    matching lines of text.

