# Aplicação API REST básica

Esta documentação fornece instruções para iniciar o serviços em ambiente local.


## Pré-requisitos:

- docker >= 17.10 (informações para instalação na próxima seção)


## Configuração da máquina local


### Instalando docker no Debian/Ubuntu/Mint:

Versões mais recentes já possuem o pacote docker.io v18.06.

```
sudo apt-get update &&
sudo apt-get -y install docker.io &&
docker version
```

Para outras distros veja [este link](https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce).



## Comandos básicos para localhost

Executar em um terminal no mesmo diretório deste README.


### Para subir serviços

```
docker swarm init
bash build.sh
docker stack deploy -c docker-stack.yml  project
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
bash teste.sh localhost db api proxy
```



### Para parar serviços

```
docker stack rm project 
```

