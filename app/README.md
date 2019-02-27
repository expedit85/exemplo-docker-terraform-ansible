# title 1


## Comandos básicos para localhost


### Para subir serviços

```
docker swarm init
bash build.sh
docker stack deploy -c docker-stack.yml  project
```

### Para listar serviços

```
docker service ls
```


### Para ver logs dos serviços

```
docker service logs -f project_db
docker service logs -f project_api
docker service logs -f project_proxy
```


### Para parar serviços

```
docker stack rm project 
```


## Testes

- Mysql:

```
# mostra nome da tabela Note
mysql -u notes-api -pnotes-api -h 127.0.0.1 notes <<< "show tables;"
```

- API em Node.js:

```
curl -v 'http://127.0.0.1:8080/notes'
```



- Proxy Nginx:

```
# falha pois valor da anotação não foi enviado
curl -v -X POST  'http://localhost/notes'

# lista vazia, cria, lista com 1 item
curl -v 'http://localhost/notes'
curl -v -X POST -d 'hello world' 'http://localhost/notes' 
curl -v 'http://localhost/notes'

# remove e lista vazia
curl -v -X DELETE  'http://localhost/notes/1'
curl -v 'http://localhost/notes'

# falha, pois item não existe
curl -v -X DELETE  'http://localhost/notes/1'
```

