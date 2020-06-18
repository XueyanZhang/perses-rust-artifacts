#!/usr/bin/env bash
# This toy demonstration will find the smallest reduction of hello.rs that still
# prints "hello_world" to standard output.
set -o pipefail
set -o nounset
set -o errexit

readonly STDOUT="hello.stdout"
readonly SRC="hello.rs"
readonly EXE="./hello"

# if rustc does not exist, this step will automatically fail
rustup run stable rustc "${SRC}" -o "${EXE}"

rm "${STDOUT}" -vrf || true
"${EXE}" 1>"${STDOUT}"
if [[ "${?}" != 0 ]] ; then
  exit 1
fi

grep "hello_world" "${STDOUT}"
