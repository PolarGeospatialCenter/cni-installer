FROM polargeospatialcenter/pgc-ptp

FROM golang:stretch

WORKDIR /go/src/
RUN git clone https://github.com/PolarGeospatialCenter/plugins && cd plugins && git checkout disable_autoconf
WORKDIR /go/src/plugins
RUN ./build.sh
RUN mkdir /install && cp /go/src/plugins/bin/* /install

FROM quay.io/polargeospatialcenter/multus-cni:k8s-fallback-networks
WORKDIR /install/
RUN cp /usr/src/multus-cni/bin/multus multus-cni

FROM quay.io/polargeospatialcenter/k8s-ipam:2018.09.01.r00

FROM quay.io/polargeospatialcenter/k8s-policy:2018.09.02.r00

FROM alpine

COPY --from=0 /install/ /install/
COPY --from=1 /install/ /install/
COPY --from=2 /install/ /install/
COPY --from=3 /bin/k8s-ipam /install/
COPY --from=4 /bin/k8s-policy /install/

CMD cp -R /install/* /cni/bin/
