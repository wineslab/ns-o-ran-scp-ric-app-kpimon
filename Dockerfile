FROM nexus3.o-ran-sc.org:10002/o-ran-sc/bldr-ubuntu18-c-go:1.9.0 as kpimonbuild

ENV PATH $PATH:/usr/local/bin
ENV GOPATH /go
ENV GOBIN /go/bin
ENV RMR_SEED_RT /opt/routes.txt

COPY routes.txt /opt/routes.txt

ARG RMRVERSION=4.0.2
ARG RMRLIBURL=https://packagecloud.io/o-ran-sc/release/packages/debian/stretch/rmr_${RMRVERSION}_amd64.deb/download.deb
ARG RMRDEVURL=https://packagecloud.io/o-ran-sc/release/packages/debian/stretch/rmr-dev_${RMRVERSION}_amd64.deb/download.deb
RUN wget --content-disposition ${RMRLIBURL} && dpkg -i rmr_${RMRVERSION}_amd64.deb
RUN wget --content-disposition ${RMRDEVURL} && dpkg -i rmr-dev_${RMRVERSION}_amd64.deb
RUN rm -f rmr_${RMRVERSION}_amd64.deb rmr-dev_${RMRVERSION}_amd64.deb

RUN apt update && apt install ca-certificates libgnutls30 -y

ARG XAPPFRAMEVERSION=v0.4.11
WORKDIR /go/src/gerrit.o-ran-sc.org/r/ric-plt
RUN git clone -b cherry "https://gerrit.o-ran-sc.org/r/ric-plt/sdlgo"
RUN git clone -b ${XAPPFRAMEVERSION} "https://gerrit.o-ran-sc.org/r/ric-plt/xapp-frame"
RUN cd xapp-frame && \
    GO111MODULE=on go mod vendor -v && \
    cp -r vendor/* /go/src/ && \
    rm -rf vendor

WORKDIR /go/src/gerrit.o-ran-sc.org/r/scp/ric-app/kpimon
COPY control/ control/
COPY cmd/ cmd/

# # "COMPILING E2AP Wrapper"
# RUN cd e2ap && \
#     gcc -c -fPIC -Iheaders/ lib/*.c wrapper.c && \
#     gcc *.o -shared -o libe2apwrapper.so && \
#     cp libe2apwrapper.so /usr/local/lib/ && \
#     mkdir /usr/local/include/e2ap && \
#     cp wrapper.h headers/*.h /usr/local/include/e2ap && \
#     ldconfig

# # "COMPILING E2SM Wrapper"
# RUN cd e2sm && \
#     gcc -c -fPIC -Iheaders/ lib/*.c wrapper.c && \
#     gcc *.o -shared -o libe2smwrapper.so && \
#     cp libe2smwrapper.so /usr/local/lib/ && \
#     mkdir /usr/local/include/e2sm && \
#     cp wrapper.h headers/*.h /usr/local/include/e2sm && \
#     ldconfig

RUN git clone -b ns-o-ran https://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@github.com/wineslab/libe2proto

WORKDIR /go/src/gerrit.o-ran-sc.org/r/scp/ric-app/kpimon/libe2proto

RUN cmake .
RUN make
RUN make install 

RUN mkdir /usr/local/include/libe2proto && \ 
    cp src/wrapper/wrapper.h  /usr/local/include/libe2proto && \
    cp src/e2ap/*.h /usr/local/include/libe2proto && \ 
    cp src/e2sm/*.h /usr/local/include/libe2proto && \
    ldconfig

WORKDIR /go/src/gerrit.o-ran-sc.org/r/scp/ric-app/kpimon

RUN mkdir pkg

RUN go build ./cmd/kpimon.go && pwd && ls -lat


FROM ubuntu:18.04

ENV PATH $PATH:/usr/local/bin
ENV GOPATH /go
ENV GOBIN /go/bin
ENV RMR_SEED_RT /opt/routes.txt

COPY routes.txt /opt/routes.txt

COPY --from=kpimonbuild /usr/local/lib /usr/local/lib
COPY --from=kpimonbuild /usr/local/include/libe2proto/*.h /usr/local/include/libe2proto/
RUN ldconfig
WORKDIR /go/src/gerrit.o-ran-sc.org/r/ric-plt/xapp-frame/config/
COPY --from=kpimonbuild /go/src/gerrit.o-ran-sc.org/r/ric-plt/xapp-frame/config/config-file.yaml .
WORKDIR /go/src/gerrit.o-ran-sc.org/r/scp/ric-app/kpimon
COPY --from=kpimonbuild /go/src/gerrit.o-ran-sc.org/r/scp/ric-app/kpimon/kpimon .


CMD sleep infinity