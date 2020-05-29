FROM quay.io/ukhomeofficedigital/clamav AS clamav
FROM quay.io/ukhomeofficedigital/go-clamav-rest as restserver

FROM alpine:3.11

ENV CLAM_VERSION=0.102.3-r0

RUN apk add --no-cache \
    ca-certificates \
    clamav=$CLAM_VERSION \
    clamav-libunrar=$CLAM_VERSION \
    supervisor


COPY --from=clamav /etc/clamav/ /etc/clamav/
COPY --from=clamav /eicar.com /eicar.com

RUN freshclam

COPY --from=restserver /go-clamav-rest /go-clamav-rest
COPY supervisord.conf /etc/supervisord.conf 

EXPOSE 8080

ENTRYPOINT ["/usr/bin/supervisord"]
