FROM ubuntu:20.04

RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get install -y iputils-ping
RUN apt-get install -y telnet

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get install -y ethereum

ENTRYPOINT ["tail", "-f", "/dev/null"]
