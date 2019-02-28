[all:vars]
ansible_user = ubuntu
ansible_port = ${ssh_port}
ansible_ssh_private_key_file = ${ssh_private_key_file}

[host]
${sample_host}

[manager]
${manager_hosts}

[primary]
${primary_host}
