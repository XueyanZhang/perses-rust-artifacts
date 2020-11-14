#!/usr/bin/env bash
set -o nounset
set -o pipefail

readonly OUTPUT="temp_compilation_output.tmp.txt"

if timeout -s 9 30 rustup run nightly-2020-10-09 rustc --crate-type=staticlib -C debuginfo=2 -C opt-level=1 -C target-cpu=skylake ${INPUT} &> "${OUTPUT}" ; then 
  exit 1
fi

if ! grep --quiet --fixed-strings "thread 'rustc' panicked at 'cannot use the \`#[rustc_if_this_changed]\` or \`#[rustc_then_this_would_need]\` annotations without supplying \`-Z query-dep-graph\`'" "${OUTPUT}" ; then
  exit 1
fi

if ! grep --quiet --fixed-strings "error: internal compiler error: unexpected panic" "${OUTPUT}" ; then
  exit 1
fi

if ! grep --quiet --fixed-strings "note: the compiler unexpectedly panicked. this is a bug." "${OUTPUT}" ; then
  exit 1
fi

if ! grep --quiet --fixed-strings "thread '<unnamed>' panicked at 'assertion failed: \`(left == right)\`" "${OUTPUT}" ; then
  exit 1
fi
exit 0
