#!/bin/bash
USER_ID=${LOCAL_USER_ID:-9001}

if ! getent passwd $USER_ID; then
    adduser -s /bin/bash -u $USER_ID -S -D -h /dehydrated user
fi
chown -R $USER_ID /dehydrated
export HOME=/dehydrated

exec /usr/local/bin/gosu "$USER_ID" dockerize -template config.tmpl:config /bin/bash dehydrated -t dns-01 -k hooks/cloudflare/hook.py $@
