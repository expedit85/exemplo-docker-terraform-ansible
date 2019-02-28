#!/bin/bash

BASEDIR=$(dirname "$0")

fail()
{
    test -n "$2" && echo "$2" >&2
    exit $1
}

test -n "${SSH_HOST}" || fail 1 "SSH_HOST environment variable is required"
test -n "${SSH_PRIVATE_KEY}" || fail 1 "SSH_PRIVATE_KEY environment variable is required"
test -n "${REMOTE_HOST_STATE_FILE}" || fail 1 "REMOTE_HOST_STATE_FILE environment variable is required"


ssh_cmd=(
   ssh
    -p ${SSH_PORT:-22}
    -o StrictHostKeyChecking=no
    -o UserKnownHostsFile=/dev/null
    -o ServerAliveInterval=20
    -o ServerAliveCountMax=500
    -i "${SSH_PRIVATE_KEY}"
    "ubuntu@${SSH_HOST}"
)


wait-server-ready()
{
    while ! ${ssh_cmd[@]} <<< "until grep ready ${REMOTE_HOST_STATE_FILE}; do sleep 1; done;"
    do
        sleep 5
    done
}


exec-default-playbook()
{
    ANSIBLE_HOST_KEY_CHECKING=False \
    ansible-playbook -u ubuntu \
                    --private-key "${SSH_PRIVATE_KEY}" \
                    -i "${SSH_HOST}," \
                    -e ansible_ssh_port=${SSH_PORT:-22} \
                    "${BASEDIR}/default-playbook.yml"
}


wait-server-ready && exec-default-playbook

