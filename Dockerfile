# FROM --platform=amd64 ubuntu:18.04
FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build
COPY build-openssl.sh build-openssl.sh

# Build openssl with trace
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
  && apt-get update \
  && apt-get -y install dpkg-dev devscripts

RUN ./build-openssl.sh
  
FROM ubuntu:20.04
COPY --from=builder /usr/src/*.deb /tmp

RUN apt-get install /tmp/*.deb && rm /tmp/*.deb

# Install dependencies 
RUN apt-get update \
  && apt-get install -y python3-pip libgmp3-dev libmpc-dev \
  && pip3 install gmpy2
  
WORKDIR /app
COPY primecheck knownprimes.ini ./

ENTRYPOINT ["/app/primecheck"]