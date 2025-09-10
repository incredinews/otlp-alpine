FROM otel/opentelemetry-collector-contrib:nightly AS prep

FROM alpine

#ARG USER_UID=10001
#ARG USER_GID=10001
#USER ${USER_UID}:${USER_GID}
RUN apk --update add ca-certificates bash curl 
RUN bash -c 'cd /;test -e /etc/otel||mkdir /etc/otel;ARCH=amd64;uname -m |grep aarch64 && ARCH=arm64 ;curl -kL  https://github.com/whyvl/wireproxy/releases/download/v1.0.9/wireproxy_linux_$ARCH.tar.gz|tar xvz'||true
RUN mv wireproxy connector
COPY --from=prep /otelcontribcol /otelcontribcol
EXPOSE 4317 55680 55679
ENTRYPOINT ["/bin/bash"]
CMD ["/otelcontribcol","--config", "/etc/otel/config.yaml"]
