FROM golang:alpine As build
RUN apk add --no-cache git gcc libc-dev net-snmp-dev
RUN go get -v -u github.com/prometheus/snmp_exporter/generator/


FROM alpine:latest

COPY --from=build /go/bin/generator /bin/generator
RUN apk add --no-cache net-snmp

COPY mibs       /mibs
ENV MIBDIRS="/usr/share/snmp/mibs:/mibs"
WORKDIR /opt/
ENTRYPOINT ["/bin/generator"]
CMD ["generate"]
