FROM polargeospatialcenter/cni-ipvlan-vpc-k8s

FROM alpine

ADD https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz .
RUN mkdir /install && \
    tar -zxf cni-plugins-amd64-v0.7.1.tgz -C /install

COPY --from=0 /go/src/github.com/lyft/cni-ipvlan-vpc-k8s/cni-ipvlan-vpc-k8s-unnumbered-ptp /install/

ADD https://github.com/intel/multus-cni/releases/download/v2.0/multus-cni_v2.0_linux_amd64.tar.gz .
RUN tar -zxf multus-cni_v2.0_linux_amd64.tar.gz  && mv multus-cni_v2.0_linux_amd64/multus-cni /install/

FROM alpine
COPY --from=1 /install/ /install/
