FROM resin/rpi-raspbian:latest
USER root
RUN apt-get update && \
    apt-get install -y python3 git curl

ENV GO_VERSION=1.6.2 \
    COOKER_USER=cooker \
    COOKER_GROUP=cooker

WORKDIR /tmp/

RUN curl -skSLO https://storage.googleapis.com/golang/go${GO_VERSION}.linux-armv6l.tar.gz

RUN ls -al
RUN tar -xzf go${GO_VERSION}.linux-armv6l.tar.gz && \
    ls -al && \
    rm go${GO_VERSION}.linux-armv6l.tar.gz && \
    mv go* /usr/local/

ENV PATH /usr/local/go/bin:$PATH

RUN groupadd -r ${COOKER_GROUP} && \
    useradd -r -g ${COOKER_GROUP} ${COOKER_USER}
USER cooker

ENV GOPATH $HOME/go_path

RUN echo $GOPATH &&\
    go version

WORKDIR /home/${COOKER_USER}/lib

RUN pwd

RUN git clone https://github.com/Tuckie/max31855.git




