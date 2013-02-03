#!/usr/bin/perl

my %colors = (
   black          => '\x1b[30m&\x1b[0m',
   white          => '\x1b[37m&\x1b[0m',
   cyan           => '\x1b[36m&\x1b[0m',
   green          => '\x1b[32m&\x1b[0m',
   red            => '\x1b[31m&\x1b[0m',
   yellow         => '\x1b[33m&\x1b[0m',
   magenta        => '\x1b[35m&\x1b[0m',
   blue           => '\x1b[34m&\x1b[0m',
   cyan_bg        => '\x1b[46m&\x1b[0m',
   blue_bg        => '\x1b[44m&\x1b[0m',
   purple_bg      => '\x1b[45m&\x1b[0m',
   green_bg       => '\x1b[42m&\x1b[0m',
   yellow_bg      => '\x1b[43m&\x1b[0m',
   red_bg         => '\x1b[41m&\x1b[0m',
   white_bg       => '\x1b[47m&\x1b[0m',
   bold           => '\x1b[1m&\x1b[0m',

);

# any key found in this hash must also be a key in the %colors hash
# Each key corresponds to an array of tags. Any time a tag is found
# in a line that line will be wrapped in the appropriate color code.
# feel free to modify this hash. At some point i would like to make this
# configurable from the command line. so that people don't need to know
# perl and sed just to configure the thing.
#
# currently this hash is configured to color lines of output 
# from ping website.com
my %modifications = (
   cyan      => [ # color code
      'icmp_seq=1', # regular expression
   ],
   red => [
      'red', 
      'icmp_seq=' . 2,
   ],
   red_bg => [
      'red background',
      'icmp.seq=.\?4 ',
   ],
   yellow => [
      'icm..seq=5',
   ],
   green => [
      '\.com',
   ],
);

my $cmd;

if ($ARGV[0] eq "-h" || $ARGV[0] eq "--help") {
   %modifications = ();
   $modifications{cyan} = [".*"];
   $modifications{green} = [":"];

   my $help_msg = " ----- add_color:\n\n"
      . " takes a stream or a filename as input and outputs with ansi color\n"
      . " codes added to individual lines of text.\n\n"
      . " use:\n\n"
      . "    \$ ./add_color.pl /text/file/with/custom_tags.txt\n"
      . "    \$ ping localhost | ./add_color.pl\n"
      . "    \$ perl add_color.pl readme.txt\n\n"
      . " params:\n\n"
      . "    -h --help   print this message\n"
      . "    <filename>  file who's contents will be output with color.\n\n"
      . " notes:\n\n"
      . "    usually i use this to highlight certain messages in logs.\n"
      . "    By piping the output of this script into less -r you can get\n"
      . "    a much nicer ui for analyzing logs. only use this if you are\n"
      . "    giving a file name as input\n\n"
      . "    You can configure this script by modifying it manually. The \n"
      . "    \%modifications hash is used to set regular expressions.\n"
      . "    when a match is found any line of input containing the \n"
      . "    match will be wrapped in the appropriate ansi escape code.\n\n";
      
   $cmd = "echo \"$help_msg\" | sed ";

}
else {
   $cmd = 'cat ' . $ARGV[0] . ' | sed ';
}

foreach my $mod (keys %modifications) {
   foreach my $tag (@{$modifications{$mod}}) {
      $cmd .= '-e "s/.*\b' . $tag . '.*/' . $colors{$mod} . '/" ';
   }
}

system($cmd);

