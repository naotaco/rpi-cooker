FROM resin/rpi-raspbian:latest
USER root
RUN apt-get update && \
    apt-get install -y python3 git curl ca-certificates unzip

ENV GO_VERSION=1.6.2 \
    COOKER_USER=cooker \
    COOKER_GROUP=cooker

WORKDIR /tmp/

RUN curl -sSLO https://storage.googleapis.com/golang/go${GO_VERSION}.linux-armv6l.tar.gz && \
    tar -xzf go${GO_VERSION}.linux-armv6l.tar.gz && \
    ls -al && \
    rm go${GO_VERSION}.linux-armv6l.tar.gz && \
    mv go* /usr/local/ && \
    groupadd -r ${COOKER_GROUP} && \
    useradd -m -r -g ${COOKER_GROUP} ${COOKER_USER} && \
    chown ${COOKER_GROUP}:${COOKER_USER} /home/${COOKER_USER}

USER cooker

ENV PATH=/usr/local/go/bin:$PATH \
    GOPATH=/home/${COOKER_USER}/go_path

RUN echo $GOPATH &&\
    go version && \
    cd /home/${COOKER_USER} && \
    mkdir lib

WORKDIR /home/${COOKER_USER}/lib

RUN git clone https://github.com/Tuckie/max31855.git && \
    go get github.com/zenazn/goji && \
    go get github.com/flosch/pongo2

RUN go get gopkg.in/redis.v2

ENV MAX31855_PATH /home/${COOKER_USER}/lib/max31855

WORKDIR /home/${COOKER_USER}

RUN ls -al && \
    git clone https://github.com/naotaco/cooker-daemon.git && \
    git clone https://github.com/naotaco/cooker-front.git

USER root

RUN cd cooker-daemon && \
    chmod +x cooker-daemon.py && \
    ./cooker-daemon.py &

RUN cd cooker-front &&\
    go run ./main.go ./redis.go &




