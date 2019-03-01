# Aplicação API REST básica

Esta documentação fornece instruções para iniciar o serviços em ambiente local.


## Pré-requisitos:

- docker >= 17.10 (informações para instalação na próxima seção)


## Configuração da máquina local


### Instalando docker no Ubuntu/Mint:

Versões mais recentes do **Mint** ou **Ubuntu** já possuem o pacote docker.io v18.06.

```
sudo apt-get update &&
sudo apt-get -y install docker.io &&
docker version
```

Para outras distros, use o script para instalação em ambientes de teste ou veja [este link](https://docs.docker.com/install/):

```
sudo apt-get install curl &&
curl -fsSL https://get.docker.com | sh
```


## Comandos básicos para localhost

Executar em um terminal no mesmo diretório deste README.


### Para subir serviços

```
sudo docker swarm init --advertise-addr 127.0.0.1
sudo bash build.sh
sudo docker stack deploy -c docker-stack.yml  project
```

### Para listar serviços e containers

```
docker service ls
docker ps
```


### Para ver logs dos serviços

```
docker service logs -f project_db
docker service logs -f project_api
docker service logs -f project_proxy
```


### Testes

```
cd ../teste
sudo apt-get install curl apache2-utils
bash teste.sh localhost
```

Mais detalhes no [README da pasta teste/](../teste/README.md).


### Para parar serviços

```
docker stack rm project 
```

