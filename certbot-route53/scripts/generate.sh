#!/bin/sh
if [ -z "$STAGING" ]; then
    CERTBOT="certbot"
else
    echo "Staging Mode: No real certs will be generated."
    CERTBOT="certbot --staging"
fi

if [ -n "$FORCERENEWAL" ]; then
    FORCERENEWAL="--force-renewal"
fi

if [ -n "$WILDCARD" ]; then
    ANDWILDCARD="-d *.${DOMAIN}"
fi

if [ -n "$EXPAND" ]; then
    EXPAND="--expand"
fi

echo "Checking if Cert is already existing for $DOMAIN"
if [ ! -f "/etc/letsencrypt/live/$DOMAIN//fullchain.pem" ]; then
    echo "Processing $DOMAIN..."
    $CERTBOT certonly --dns-route53 --non-interactive --text --agree-tos \
        "$FORCERENEWAL" \
        "$EXPAND" \
        -d "$DOMAIN" \
        "$ANDWILDCARD" \
        --email "$EMAIL" \
        --pre-hook "/root/certbot-route53/hook-pre.sh" \
        --renew-hook "/root/certbot-route53/hook-each.sh" \
        --post-hook "/root/certbot-route53/hook-post.sh" \
        --server "https://acme-v02.api.letsencrypt.org/directory"
fi
