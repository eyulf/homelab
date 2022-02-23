#!/bin/bash

SCRIPT_DIR=$(pwd)
ANSIBLE_DIR="ansible"
ANSIBLE_INVENTORY="ansible-inventory -i production"
ANSIBLE_ALL_HOSTS=$(cd ${ANSIBLE_DIR} && ${ANSIBLE_INVENTORY} --graph k8s_all | grep '|' | cut -d '-' -f3-6 | grep -v '@')

cd terraform/infrastructure/kubernetes

for host in ${ANSIBLE_ALL_HOSTS}; do
	echo "Tainting: $host"
	terraform1.1 taint module.$host.libvirt_domain.main
	terraform1.1 taint module.$host.libvirt_volume.main
done

echo "Waiting 30s"
sleep 30

terraform1.1 apply -auto-approve

cd ${SCRIPT_DIR}

echo "Waiting 60s"
sleep 60

for host in ${ANSIBLE_ALL_HOSTS}; do
	echo "Resetting SSH Host Keys: $host"
	ipv4=$(cd ${ANSIBLE_DIR} && ${ANSIBLE_INVENTORY} -y --host ${host} | grep 'ansible_host'| head -n 1 | awk '{print $2}')

	ssh-keygen -R ${ipv4}
	ssh-keyscan -H ${ipv4} >> ~/.ssh/known_hosts
done

cd ansible

ansible-playbook -i production k8s-all.yml
