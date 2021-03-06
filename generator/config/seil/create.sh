#!/bin/sh
MIB_URL="https://www.seil.jp/files/26667630/50601093/3"
MIB_FILE="IIJ-SEIL-MIB.txt"
CWD=$(cd "$(dirname "${0}")"; pwd)
MIBDIR="${CWD}/mibs"

make() {
	mkdir ${MIBDIR}
	echo "Copy from mibs dir."
	cp -v ${CWD}/../../mibs/* ${MIBDIR}/

	#echo "Copy from local dir."
	#cp -v ${CWD}/local/* ${MIBDIR}/

	echo "Downloading ${MIB_URL}/${MIB_FILE}...."
	wget ${MIB_URL}/${MIB_FILE} -O ${MIBDIR}/IIJ-SEIL-MIB.txt
	#tar zxf ${MIBDIR}/mibs.tgz -C ${MIBDIR}

	#echo "Fixing MIB...."
	#patch ./${vendor}/${model}/${version}/${mibname} < ./patch/${vendor}/${version}/${mibname%.*}.patch
	
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
