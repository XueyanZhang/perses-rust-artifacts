FROM ubuntu:18.04 AS builder

USER root

# Set up the right tags for building
ENV CREDUCE_TAG="c32c5c327758a047ae10e55a2465ba54293dfff9"
ENV RUST_REDUCE_TAG="3c54ffdf4629f6bd3adeef8aabda412acbdc2fd6"
ENV PERSES_TAG="dbae2214e13816df8370448e85185c0645785409"

# Get base packages for development
RUN apt-get update && apt-get install -y curl gnupg
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - 
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get -y install tzdata
RUN apt-get install -y llvm-9-dev build-essential ninja-build clang-9 libclang-9-dev openjdk-11-jdk git libexporter-lite-perl  libgetopt-tabular-perl libclang-9-dev clang-format-9 cmake flex bison bazel  libregexp-common-perl libterm-readkey-perl libfile-which-perl

# Build binary directory
RUN mkdir /src/

# Build CReduce
RUN cd /src && git clone https://github.com/csmith-project/creduce && cd creduce && git checkout $CREDUCE_TAG && LLVM_DIR=/usr/lib/llvm-9 cmake -GNinja -DCMAKE_EXE_LINKER_FLAGS="-Wl,--copy-dt-needed-entries" -DCMAKE_INSTALL_PREFIX=/opt/creduce && ninja install

# Build Rust-Reduce
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN cd src && git clone https://github.com/jethrogb/rust-reduce && cd rust-reduce && git checkout $RUST_REDUCE_TAG && /root/.cargo/bin/rustup run stable cargo build && cp target/debug/rust-reduce /opt

# Build Perses
RUN cd src && git clone https://github.com/chengniansun/perses && cd perses && git checkout $PERSES_TAG && bazel build //src/org/perses:perses_deploy.jar && \
  bazel build //src/org/perses:token_counter_deploy.jar && cp bazel-bin/src/org/perses/*_deploy.jar /opt

FROM ubuntu:18.04

USER root

# Copy opt files
COPY --from=builder /opt /opt

# Install dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get -y install tzdata locales
RUN apt-get install -y libclang-cpp9 libexporter-lite-perl libgetopt-tabular-perl libregexp-common-perl libterm-readkey-perl libfile-which-perl openjdk-11-jre curl bc build-essential vim clang-format asciinema valgrind

# Set up locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

# Add dataset and scripts
COPY dataset /opt/dataset
COPY scripts /opt/scripts

# Make new user, install rustup for it.
RUN useradd -ms /bin/bash perses && usermod -aG sudo perses
COPY reduction-demo /home/perses/reduction-demo
RUN chown perses:perses /home/perses/reduction-demo

USER perses
WORKDIR /home/perses
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/opt/scripts/:/home/perses/.cargo/bin:${PATH}" PREDUCE="/opt/perses_deploy.jar" CREDUCE="/opt/creduce/bin/creduce" RREDUCE="/opt/rust-reduce" COUNT="/opt/token_counter_deploy.jar" LOCALE=
RUN fetch-all
