all: build

build:
	echo "Building snmp-exporter docker image"
	docker-compose build

install: 
	echo "Starting snmp-exporter"
	docker-compose up -d

config:
	echo "Make snmp.yml by all sub directory"
	cd "$(PWD)/generator" && make yml
	mv "$(PWD)/generator/snmp.yml" .

clean:
	rm -f snmp.yml
	docker rmi --force snmp-exporter
	cd "$(PWD)/generator" && make del
	cd "$(PWD)"
