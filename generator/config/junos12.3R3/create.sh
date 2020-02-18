#!/bin/sh
MIB_URL="http://www.juniper.net/techpubs/software/junos/junos123"
MIB_FILE="juniper-mibs-12.3R12.4.zip"
CWD=$(cd "$(dirname "${0}")"; pwd)
MIBDIR="${CWD}/mibs"

make() {
	mkdir ${MIBDIR}
	echo "Copy from mibs dir."
	cp -v ${CWD}/../../mibs/* ${MIBDIR}/

	echo "Downloading ${MIB_URL}/${MIB_FILE}...."
	wget ${MIB_URL}/${MIB_FILE} -O ${MIBDIR}/mibs.zip
	
	unzip ${MIBDIR}/mibs.zip
	mv StandardMibs JuniperMibs ${MIBDIR}
	cp -v ${MIBDIR}/StandardMibs/mib-* ${MIBDIR}/
	cp -v ${MIBDIR}/JuniperMibs/mib-* ${MIBDIR}/
	
	echo "Generating snmp.yml from generator.yml"
	cp -v ${CWD}/../../Dockerfile .
	docker build -t snmp-generator .  --network=host
	docker run -ti -v "${CWD}:/opt/" snmp-generator generate
	rm -fv Dockerfile
}

del() {
	rm -rfv ${CWD}/mibs/*
	rm -rfv ${CWD}/snmp.yml
	docker rmi --force snmp-generator
}

case "$1" in
	make)
		make
		RETVAL=0
		;;
	del)
		del
		RETVAL=0
		;;
	*)
		echo $"Usage: $prog {build|clean}"
		RETVAL=2
esac

exit $RETVAL
