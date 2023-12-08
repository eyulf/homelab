FROM alpine:3.19

RUN apk add busybox=1.35.0-r29 tftp-hpa=5.2-r5

ENTRYPOINT [ "/bin/sh", "-c" ]

CMD [ "busybox syslogd -n -O /dev/stdout & in.tftpd -vvv --foreground --secure /var/lib/tftpboot" ]

#checkov:skip=CKV_DOCKER_2:HealthCheck not required
#checkov:skip=CKV_DOCKER_3:Using root user for now
