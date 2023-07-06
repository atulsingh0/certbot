# certbot

### Generate Certificates for Route53 (AWS DNS)

#### Building the image
```
docker build -t certbot-aws -f dockerfile-certbot-aws .
```

#### Genearing Certs
```
docker run certbot-aws:latest 
```