#!/bin/bash
readonly BUGGY_RUSTC_VERSION="1.20.0"
readonly CORRECT_RUSTC_VERSION="1.47.0"
readonly CORRECT_RUSTC_VERSION_2="1.47.0"
rustup toolchain install "${BUGGY_RUSTC_VERSION}" --force
rustup toolchain install "${CORRECT_RUSTC_VERSION}" --force
rustup toolchain install "${CORRECT_RUSTC_VERSION_2}" --force
