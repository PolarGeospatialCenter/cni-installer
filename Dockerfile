FROM polargeospatialcenter/pgc-ptp

FROM golang:stretch

WORKDIR /go/src/
RUN git clone https://github.com/PolarGeospatialCenter/plugins && cd plugins && git checkout disable_autoconf
WORKDIR /go/src/plugins
RUN ./build.sh
RUN mkdir /install && cp /go/src/plugins/bin/* /install

FROM alpine

ENV MULTUS_VERSION v3.1

ADD https://github.com/intel/multus-cni/releases/download/${MULTUS_VERSION}/multus-cni_${MULTUS_VERSION}_linux_amd64.tar.gz .
RUN mkdir /install && tar -zxf multus-cni_${MULTUS_VERSION}_linux_amd64.tar.gz  && mv multus-cni_${MULTUS_VERSION}_linux_amd64/multus-cni /install/

FROM alpine

COPY --from=0 /install/ /install/
COPY --from=1 /install/ /install/
COPY --from=2 /install/ /install/

CMD cp -R /install/* /cni/bin/
