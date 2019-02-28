# Provisionamento e configuração de aplicação na AWS

Esta documentação fornece instruções para iniciar o serviços na AWS usando terraform e ansible.


## Pré-requisitos:

- Conta na AWS com "access key" e "secret key"
- Máquina de controle (local):
  - ansible 2.7.8
  - terraform v0.11.11


## Configuração da máquina de controle


### Instalando ansible no Debian/Ubuntu/Mint:

```
sudo apt-get update &&
sudo apt-get -y install software-properties-common &&
sudo apt-add-repository -y  ppa:ansible/ansible &&
sudo apt-get -y update &&
sudo apt-get -y install ansible &&
ansible --version
```

Para outras distros veja [este link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-machine).


### Instalando terraform no Debian/Ubuntu/Mint:

Basta efetuar download e descompactar o executável em uma pasta acessível.

```
wget 'https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip'
unzip terraform_0.11.11_linux_amd64.zip
sudo ln -s "$(pwd)/terraform" /usr/local/bin/
terraform -v
```

Para outras distros veja [este link](https://learn.hashicorp.com/terraform/getting-started/install).

## Provisionamento e configuração na AWS

### Chaves de acesso

Crie o arquivo `terraform/cluster/terraform.auto.tfvars` para armazenar as chaves de acesso ao AWS:

```
aws_access_key = "SUA-CHAVE-DE-ACESSO-AQUI"
aws_secret_key = "SUA-CHAVE-DE-SEGURANCA-AQUI"
```

Obs.: este arquivo é sigiloso e não será versionado.


### Provisionamento, configuração e deploy

Execute os comandos em um terminal no mesmo diretório deste README:

```
chmod 400 keys/sample-key-pair    # define permissões da chave privada

cd terraform/cluster
terraform init
terraform apply                   # cria máquina na AWS

cd ../inventory           # cria inventário de máquinas para o ansible
terraform init
terraform apply
terraform output inventory > ../../state/hosts

cd ../../ansible
ansible all -m ping           # testa conectividade com máquina na AWS
playbooks/docker-init.yml     # inicializa docker na máquina remota
playbooks/deploy.yml          # efetua deploy da aplicação na AWS
```

Obs: `terraform apply` pode solicitar confirmação via teclado.


## Testando o ambiente

Execute os comandos em um terminal no mesmo diretório deste README:

```
cd ../teste
bash teste.sh remotehost db api proxy
```


## Destruindo o ambiente

Execute os comandos em um terminal no mesmo diretório deste README:

```
cd terraform/cluster
terraform destroy
cd -
rm state/*
```
