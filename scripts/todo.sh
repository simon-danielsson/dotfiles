#!/usr/bin/env bash
set -euo pipefail

# --- HARD-CODED BLACKLIST (always applied) ---
BASE_BLACKLIST=(
  ".git"
  "node_modules"
  "build"
  "dist"
)

# --- USER-SUPPLIED BLACKLIST (appended) ---
USER_BLACKLIST=( "$@" )

BLACKLIST=( "${BASE_BLACKLIST[@]}" "${USER_BLACKLIST[@]}" )

FIND_ARGS=()
for pattern in "${BLACKLIST[@]}"; do
  FIND_ARGS+=( -not -path "*${pattern}*" )
done

find . -type f "${FIND_ARGS[@]}" -print0 |
while IFS= read -r -d '' file; do
  perl -0777 -e '
    use strict;
    use warnings;

    my $file = shift @ARGV;
    my $home = $ENV{HOME} // "";

    open my $fh, "<:raw", $file or exit 0;
    local $/;
    my $content = <$fh>;
    close $fh;

    exit 0 unless defined $content;
    exit 0 if index($content, "[TODO]") < 0;

    my @paragraphs = split /\n(?:[ \t\r]*\n)+/, $content, -1;

    my $line_no = 1;

    for my $p (@paragraphs) {
      my $first_todo_offset = index($p, "[TODO]");
      my $lines_in_p = () = $p =~ /\n/g;
      my $paragraph_line_count = $lines_in_p + 1;

      if ($first_todo_offset >= 0) {
        my $before = substr($p, 0, $first_todo_offset);
        my $todo_line = $line_no + (() = $before =~ /\n/g);

        my $display_path = $file;
        if ($home ne "" && index($display_path, "$home/") == 0) {
          substr($display_path, 0, length($home)) = "~";
        }

        my $out = $p;
        $out =~ s/\r//g;
        $out =~ s/\n+\z//;
        $out =~ s/"/\\"/g;

        print "$display_path:$todo_line\n";
        print "\"$out\"\n\n";
      }

      $line_no += $paragraph_line_count;

      # Account for the blank-line separator(s) removed by split.
      # We only need an approximate paragraph boundary increment of 1 line
      # for line numbering between paragraphs.
      $line_no += 1;
    }
  ' "$file"
done
