#!!/bin/bash
MYGRAF=$(echo "$OTLP_GRAF_URL"|cut -d"/" -f3)
echo "$MYGRAF"|grep -q @ && MYGRAF=$(echo "$MYGRAF"|cut -d"@" -f2)

cat /etc/caddyfile |sed 's/GRAFANAHOST/'"$MYGRAF"'/g' > /tmp/caddyfile
export MY_GRAF_URL="http://127.0.0.1:14444/"$(echo "$OTLP_GRAF_URL"|cut -d"/" -f4-)
[[ "$DEBUG" == "true" ]] && sed 's/INFO/DEBUG/g'  -i /tmp//caddyfile  #;caddy reload --config /tmp/caddyfile 
grep proxy /tmp/caddyfile
grep endoint /etc/otelcol-contrib/config.yaml
test -e /etc/connector.conf &&  ( /connector --config /etc/connector.conf  2>&1 |grep -v -e decryption -e key -e keepalive -e ndshake ) &
caddy run --config /tmp/caddyfile & 

/otelcol-contrib --config /etc/otelcol-contrib/config.yaml