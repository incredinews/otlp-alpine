#FROM otel/opentelemetry-collector-contrib:nightly AS prep
FROM alpine as prep
RUN apk add bash curl  && bash -c 'uname -m;cd /;test -e /etc/otelcol-contrib||mkdir /etc/otelcol-contrib;ARCH=amd64;uname -m |grep -e armv7 && ARCH=armv7;uname -m |grep -e arm64 -e aarch64 && ARCH=arm64 ; echo load $ARCH; ( curl -kL  https://github.com/whyvl/wireproxy/releases/download/v1.0.9/wireproxy_linux_$ARCH.tar.gz|tar xvz  && mv wireproxy connector )& curl -kL https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.135.0/otelcol-contrib_0.135.0_linux_$ARCH.tar.gz|tar xvz & wait;rm README.md'||true
RUN ls /otelcol-contrib /connector

FROM alpine
RUN apk --update add ca-certificates bash curl file vnstat caddy  
#ARG USER_UID=10001
#ARG USER_GID=10001
#USER ${USER_UID}:${USER_GID}
COPY src/setup.sh src/caddyfile /etc
COPY src/otlp-grafana.yaml /etc/otelcol-contrib/config.yaml
#COPY --from=prep /otelcol-contrib /otelcol-contrib
COPY --from=prep /otelcol-contrib /connector /
EXPOSE 4317 4318 55680 55679
#CMD ["-c","uname -m ; file /otelcol-contrib --config /etc/otel/config.yaml"]
ENTRYPOINT ["/bin/bash","-c","uname -m ; bash /etc/setup.sh"]
CMD ["/bin/bash"]