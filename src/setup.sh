#!!/bin/bash
MYGRAF=$(echo "$OTLP_GRAF_URL"|cut -d"/" -f3)
echo "$MYGRAF"|grep -q @ && MYGRAF=$(echo "$MYGRAF"|cut -d"@" -f2)

cat /etc/caddyfile |sed 's/GRAFANAHOST/'"$MYGRAF"'/g' > /tmp/caddyfile

export  MY_GRAF_URL="http://127.0.0.1:14444/"$(echo "$OTLP_GRAF_URL"|cut -d"/" -f4-)
[[ "$NOCADDY" == "true" ]] && export MY_GRAF_URL="$OTLP_GRAF_URL"
[[ "$NOCADDY" == "true" ]]  || (
  [[ "$DEBUG" == "true" ]] && ( sed 's/INFO/DEBUG/g'  -i /tmp//caddyfile ;[[ "$DEBUG" == "true" ]] && grep proxy /tmp/caddyfile;caddy run --config /tmp/caddyfile  ) &  #;caddy reload --config /tmp/caddyfile 
  [[ "$DEBUG" == "true" ]] || (                                           [[ "$DEBUG" == "true" ]] && grep proxy /tmp/caddyfile;caddy run --config /tmp/caddyfile  ) &  #;caddy reload --config /tmp/caddyfile 
)


test -e /etc/connector.conf &&  ( /connector --config /etc/connector.conf  2>&1 |grep -v -e decryption -e key -e keepalive -e ndshake -e TUN -e Interface -e encryption ) &

[[ "$NOCADDY" == "true" ]] && (
        sed 's/14318/4318/g' -i /etc/otelcol-contrib/config.yaml
)
[[ "$DEBUG" == "true" ]] && grep endoint /etc/otelcol-contrib/config.yaml;

/otelcol-contrib --config /etc/otelcol-contrib/config.yaml