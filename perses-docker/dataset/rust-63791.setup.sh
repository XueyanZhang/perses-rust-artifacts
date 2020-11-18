#!/bin/bash
readonly RUSTC_VERSION="1.34.0"
readonly CORRECT_RUSTC_VERSION="1.33.0"
rustup toolchain install "${RUSTC_VERSION}"
rustup toolchain install "${CORRECT_RUSTC_VERSION}"
