FROM prom/snmp-exporter:latest

LABEL name="snmp-exporter"
LABEL version="0.1"
LABEL architecture="x86_64"
LABEL vendor="IIJ"
LABEL release="NHN"

COPY snmp.yml       /etc/snmp_exporter/snmp.yml
