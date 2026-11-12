# check=skip=FromPlatformFlagConstDisallowed
FROM --platform=linux/amd64 ghdl/ghdl:6.0.0-llvm-ubuntu-22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends vim gtkwave && \
    rm -rf /var/lib/apt/lists/*
