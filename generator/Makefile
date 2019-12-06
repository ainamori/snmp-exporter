all: build install

build:
	echo "Building snmp-generator docker image"
	docker build -t snmp-generator .
	docker run -ti -v "${PWD}:/opt/" snmp-generator generate

del:
	docker rmi --force snmp-generator
	cd "$(PWD)/config/seil" && ./create.sh del
	cd "$(PWD)/config/junos12.3R3" && ./create.sh del
	cd "$(PWD)/config/hpe3par" && ./create.sh del

yml:
	echo "Geneating SEIL entry"
	cd "$(PWD)/config/seil" && ./create.sh make
	cat $(PWD)/config/seil/snmp.yml >> ${PWD}/snmp.yml

	echo "Geneating junos OS 12.3R3 entry"
	cd "$(PWD)/config/junos12.3R3" && ./create.sh make
	cat $(PWD)/config/junos12.3R3/snmp.yml >> ${PWD}/snmp.yml

	echo "Geneating HPE3par entry"
	cd "$(PWD)/config/hpe3par" && ./create.sh make
	cat $(PWD)/config/hpe3par/snmp.yml >> ${PWD}/snmp.yml
