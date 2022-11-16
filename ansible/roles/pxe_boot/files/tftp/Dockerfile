FROM alpine:3.17

RUN apk add busybox tftp-hpa

ENTRYPOINT [ "/bin/sh", "-c" ]

CMD [ "busybox syslogd -n -O /dev/stdout & in.tftpd -vvv --foreground --secure /var/lib/tftpboot" ]

#checkov:skip=CKV_DOCKER_2:HealthCheck not required
#checkov:skip=CKV_DOCKER_3:Using root user for now
