#!/bin/bash
USER_ID=${LOCAL_USER_ID:-9001}

adduser -s /bin/bash -u $USER_ID -S -D -h /dehydrated user
chown -R user /dehydrated
export HOME=/dehydrated

exec /usr/local/bin/gosu user dockerize -template config.tmpl:config /bin/bash dehydrated -t dns-01 -k hooks/cloudflare/hook.py $@
