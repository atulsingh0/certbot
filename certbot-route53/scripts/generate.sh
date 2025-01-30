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
if [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo "$DOMAIN certs are not existins hence, Processing ..."
    echo $CERTBOT certonly --dns-route53 --non-interactive --agree-tos \
        -m "$EMAIL" \
        -d "$DOMAIN" "$ANDWILDCARD" -v
    $CERTBOT certonly --dns-route53 --non-interactive --agree-tos \
        -m "$EMAIL" \
        -d "$DOMAIN" "$ANDWILDCARD" -v
    # --pre-hook "/root/certbot-route53/hook-pre.sh" \
    # --renew-hook "/root/certbot-route53/hook-each.sh" \
    # --post-hook "/root/certbot-route53/hook-post.sh" -v
fi
