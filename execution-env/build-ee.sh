#!/bin/bash

set -eu

#VARS
EE_IMAGE_NAME="ee-ocp-vmware:latest"
TEST_PLAYBOOK="./test-playbook.yaml"

if ! command -v ansible-builder > /dev/null ; then
  echo "Ansible builder does not exist"
  exit -1
fi

ANSIBLE_BUILDER_VERSION=$(ansible-builder --version)
[[ "$ANSIBLE_BUILDER_VERSION" == 3* ]] && echo "Ansible builder version 3.X installed" || echo "Ansible builder 3.X is required, but version $ANSIBLE_BUILDER_VERSION is installed"

#Build it
ansible-builder build -v 3 -f ./v3/execution-environment.yaml --tag "$EE_IMAGE_NAME"

#Test it
ansible-navigator run -m stdout  --pp missing --pae false --lf /tmp/out.log --eei "$EE_IMAGE_NAME" "$TEST_PLAYBOOK"
