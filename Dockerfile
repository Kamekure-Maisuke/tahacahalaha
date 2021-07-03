FROM alpine:latest

ENV APP_HOME /usr/local/app/tahacahalaha

RUN apk update --no-cache && \
    apk add --no-cache curl tcl tcl-tls && \
    rm -rf /var/cache/apk* && \
    curl -sSL https://github.com/tcltk/tcllib/archive/refs/tags/tcllib-1-20.tar.gz | tar -xz -C /tmp && \
    tclsh /tmp/tcllib-tcllib-1-20/installer.tcl -no-html -no-nroff -no-examples -no-gui -no-apps -no-wait -pkg-path /usr/lib/tcllib && \
    rm -rf /tmp/tclib*

WORKDIR ${APP_HOME}
COPY . ${APP_HOME}

RUN echo '完了'