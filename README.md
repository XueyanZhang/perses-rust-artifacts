# FSE2020-artifacts
This repository contains the build instructions and data for our FSE 2020 
tool paper submission, "Perses for Rust: A Demonstration".

# Build Instructions
Run `./build.sh` from the repository.  This should create a Docker image tagged with the
name `fse-2020-perses-artifacts` after the script completes.

# Running Perses/C-Reduce/Rust-Reduce
The binaries for Perses, C-Reduce, Rust-Reduce are installed into `/opt` inside the container.
Perses is located at `/opt/perses_deploy.jar`, Rust-Reduce is located at `/opt/rust-reduce`,
and C-Reduce is located at `/opt/creduce/bin/creduce`.

The environment variables `PREDUCE`, `RREDUCE`, and `CREDUCE` also refer to these paths.

When reducing a program, you will need a reduction script that will serve as the oracle for the
reducers.  This oracle usually invokes the compiler and tests if the input passes or fails
the oracle test (usually whether or not the compiler crashed).

An example oracle might look like this (for testing if a given file causes
a internal compiler error in `rustc`):

```
#!/bin/bash

# Rust-Reduce expects the input file as argument 1 from the command line.
INPUT=${1:<input-file.rs>}

# If it doesn't parse, it doesn't pass the property test.
if ! ( rustup run stable rustfmt --emit stdout \${INPUT} > /dev/null ); then
  exit 1
fi

# Test the compiler; if it passes, we didn't pass the property test.
RESULT=`rustup run stable rustc ${INPUT} 2>&1`
if [ "$?" -eq 0 ]; then
  exit 1
fi

# If we see the string "internal compiler error", we pass the property test
if (echo $RESULT | grep "internal compiler error"); then
  exit 0
fi

# Otherwise, we fail the test.
exit 1
```

As a demonstration, we have placed in `/home/perses/reduction-demo/` a program to be reduced and an example
oracle for it.  The oracle in question checks to see if the program exits correctly and prints `hello_world` to standard output.

To run this demonstration, from `/home/perses/reduction-demo`, run `java -jar /opt/perses_deploy.jar --input-file hello.rs --test-script reduce.sh`
to reduce `hello.rs`.  The reduced file will be placed in the same folder.

![Reduction Demo Screencast](demos/reduction-demo.svg)

(if this animation is too small, click [here](https://raw.githubusercontent.com/e45lee/FSE2020-artifacts/master/demos/reduction-demo.svg).)

# Reproducing the experiments.
We have shipped a script, `/opt/scripts/reduce-file` for reproducing the experiments we presented
in our paper.  Given a Rust source file in `/opt/dataset/<issue>.rs`, you can run `reduce-file` against
the files in `/opt/dataset` to reproduce the numbers for that issue number that we presented in our paper.
`reduce-file` also accepts an optional second argument which is passed along as extra arguments to Perses;
e.g `reduce-file /opt/dataset/63154.rs "--enable-token-slicer true"` will run the reduction experiment with
`--enable-token-slicer true` passed along to the Perses invocation.

The last three lines that this script produces on standard output correspond to the time taken that
each reducer used to generate the final reduced file, the number of oracle invocations used
to generate the final reduced file, and the final size of the reduced file for each reducer.

We have also shipped a script, `/opt/scripts/reduce-all`, for running the reduction experiments on all files
in the dataset.  This script places a trace of the output of running the reducers in `/output`; we recommend
that you bind-mount `/output` to a directory outside of Docker.  The script `./launch.sh <directory>`
will do this for you. 

To run more experiments, you can re-use the machinery in `reduce-file` with your own Rust source files.
You only need to add the following header to the top of your source file:
```
// build: <rust version number; e.g nightly, 1.42.0, ...>
// error: <error to grep for; e.g internal compiler error>
// extra: <optional, extra flags to pass to the compiler>
// target: <optional, target to build for>
```

See the dataset files in `/opt/dataset` for examples.
