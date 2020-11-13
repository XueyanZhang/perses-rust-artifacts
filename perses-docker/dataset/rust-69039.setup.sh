#!/bin/bash
readonly BUGGY_RUSTC_VERSION="nightly-2020-02-10"
readonly CORRECT_RUSTC_VERSION="nightly-2020-11-05"
rustup toolchain install "${BUGGY_RUSTC_VERSION}" --force
rustup toolchain install "${CORRECT_RUSTC_VERSION}" --force
