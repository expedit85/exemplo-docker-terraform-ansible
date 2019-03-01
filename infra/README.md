# Provisionamento e configuração de aplicação na AWS

Esta documentação fornece instruções para executar a aplicação com docker em uma instância na AWS. Para isso, usa terraform e ansible localmente.


## Pré-requisitos:

- Conta na AWS com *access key* e *secret key* com permissão "ec2:*"
- Máquina de controle (local):
  - ansible 2.7.8
  - terraform v0.11.11

### Criando e configurando conta na AWS

Efetuar as ações a seguir em um navegador Web:

1. Crie conta na AWS e efetue login
2. Acesse o IAM (Identity and Access Management)
3. Crie uma política (Policy) com o seguinte conteúdo:

    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": "ec2:*",
                "Resource": "*"
            }
        ]
    }
    ```

4. Crie um usuário associado a essa política
5. Baixe o par de chaves de acesso e segurança gerado (*access and secret keys*)


### Configuração da máquina de controle


#### Instalando ansible no Ubuntu/Mint:

```
sudo apt-get update &&
sudo apt-get -y install software-properties-common &&
sudo apt-add-repository -y  ppa:ansible/ansible &&
sudo apt-get -y update &&
sudo apt-get -y install ansible &&
ansible --version
```

Para outras distros veja [este link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-machine).


#### Instalando terraform no Ubuntu/Mint:

Basta efetuar download e descompactar o executável em uma pasta acessível.

```
sudo apt-get -y install wget unzip &&
wget 'https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip' &&
unzip terraform_0.11.11_linux_amd64.zip &&
sudo ln -sf "$(pwd)/terraform" /usr/local/bin/ &&
terraform -v
```

Para outras distros veja [este link](https://learn.hashicorp.com/terraform/getting-started/install).


## Provisionamento e configuração de instâncias EC2 na AWS

Instruções para configurar chaves de segurança, provisionar recursos na AWS e instalar docker e efetuar deploy.

### Chaves de acesso

Tomando por base o diretório deste README, crie o arquivo `terraform/cluster/terraform.auto.tfvars` para armazenar as chaves de acesso ao AWS:

```
aws_access_key = "SUA-CHAVE-DE-ACESSO-AQUI"
aws_secret_key = "SUA-CHAVE-DE-SEGURANCA-AQUI"
```

Obs.: este arquivo é sigiloso e não será versionado.


### Provisionamento, configuração e deploy

Execute os comandos em um terminal no mesmo diretório deste README:

```
# gera chave SSH
ssh-keygen -q -t rsa -C sample-key-pair -N '' -f keys/sample-key-pair

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

Obs: `terraform apply` solicita confirmação via teclado.


## Testando o ambiente

Execute os comandos em um terminal no mesmo diretório deste README:

```
cd ../teste
sudo apt-get install curl apache2-utils jq
bash teste.sh remotehost
```

Mais detalhes no [README da pasta teste/](../teste/README.md).


## Destruindo o ambiente

Execute os comandos em um terminal no mesmo diretório deste README:

```
cd terraform/cluster
terraform destroy
cd -
rm state/*
rm keys/*
```

Obs: `terraform destroy` solicita confirmação via teclado.
