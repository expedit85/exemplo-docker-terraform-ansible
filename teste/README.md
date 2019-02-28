# TODO

TODO

## TODO

### Mysql:

```
# mostra nome da tabela Note
mysql -u notes-api -pnotes-api -h 127.0.0.1 notes <<< "show tables;"
```

### API em Node.js:

```
curl -v 'http://127.0.0.1:8080/notes'
```



### Proxy Nginx:

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



```
IP=$(cd ../infra/terraform/cluster > /dev/null; terraform output public_ip)
curl -v 'http://${IP}/notes'
curl -v -X POST 'http://${IP}/notes'

curl -v 'http://${IP}/notes'|jq .
curl -v -X POST -d'foo=meu texto' 'http://${IP}/notes'
curl -v 'http://${IP}/notes'|jq .

curl -v -X POST -d'nome da chave=meu texto' 'http://${IP}/notes'
curl -v 'http://${IP}/notes'|jq .
```
