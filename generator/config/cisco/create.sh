#!/bin/sh
CWD=$(cd "$(dirname "${0}")"; pwd)
MIBDIR="${CWD}/mibs"

make() {
	mkdir ${MIBDIR}
	echo "Copy from mibs dir."
	cp -v ${CWD}/../../mibs/* ${MIBDIR}/
	cp -v ${CWD}/../../mibs/cisco_v2/* ${MIBDIR}/

	
	echo "Generating snmp.yml from generator.yml"
	cp -v ${CWD}/../../Dockerfile .
	docker build -t snmp-generator .
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
