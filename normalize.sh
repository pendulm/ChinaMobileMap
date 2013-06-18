#!/usr/bin/env bash

# normalize file format for processing with awk
# first step: strip windows format newline
# second step: substitute \r with standard newline
# perl -p -e 's/\n//' $1 | tr '\r' '\n' > "${1%%.txt}".strip
# make sure the two following outputs is same
# wc -l ${1%%.txt}.strip
# fgrep '|*|' -c $1
if [[ $1 =~ weblog ]]; then
  perl -p -e 's/\n//' $1 | tr '\r' '\n' | \
  awk 'BEGIN   { FS = "\\|!\\|" };
       NF == 7 { sub(" ", "-", $6);
                 sub("\\|\\*\\|$", "", $7);
                 print $1, $2, $3, $6, $7}' > "${1%%.txt}".strip 
elif [[ $1 =~ roller ]]; then
  perl -p -e 's/\n//' $1 | tr '\r' '\n' | \
  awk 'BEGIN   { FS = "\\|!\\|" };
       NF == 5 { sub(" ", "-", $4); 
                 sub("\\|\\*\\|$", "", $5); 
                 print $1, $2, $4, $5}' > "${1%%.txt}".strip 
fi
