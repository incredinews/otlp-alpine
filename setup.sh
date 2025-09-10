#!!/bin/bash
MYGRAF=$(echo "$OTLP_GRAF_URL"|cut -d"/" -f3)
echo "$MYGRAF"|grep -q @ && MYGRAF=$(echo "$MYGRAF"|cut -d"@" -f2)

cat /etc/caddyfile |sed 's/GRAFANAHOST/'"$MYGRAF"'/g' > /tmp/caddyfile
export MY_GRAF_URL="http://127.0.0.1:14444/"$(echo "$OTLP_GRAF_URL"|cut -d"/" -f4-)
grep proxy /tmp/caddyfile
grep endoint /etc/otelcol-contrib/config.yaml
caddy run --config /tmp/caddyfile & 

/otelcol-contrib --config /etc/otelcol-contrib/config.yaml