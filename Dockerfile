FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libncurses-dev git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY . /src
WORKDIR /src
RUN make portable

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    libncursesw6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/nv-monitor /usr/local/bin/nv-monitor

EXPOSE 9101

ENTRYPOINT ["/usr/local/bin/nv-monitor"]
CMD ["-n", "-p", "9101"]
