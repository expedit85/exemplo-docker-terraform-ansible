# Scripts para teste automatizado da aplicação

Este documento contém instruções de demonstração de testes automatizados. Foi construído um shell script que usa curl para efetuar requisições à API e Apache Benchmark para um pequeno teste de performance. O teste inclui algumas inserções, deleções e listagens.

Nos testes realizados, percebeu-se que 2 (dois) deles falharam ao permitir inserção quando não deveria (`POST /notes`):

- a API permite a inserção de uma anotação vazia ao enviar o valor `=` como corpo da requisição;
- a API permite a inserção de uma anotação que extrapola o limite do tamanho da coluna.


## Pré-requisitos

- curl
- ab (Apache Benchmark)
- jq

### Instalação no Ubuntu/Mint

```
sudo apt-get install curl apache2-utils jq
```



## Teste da aplicação na máquina local

Execute o comando a seguir caso tenha seguido os passos [do README da pasta app/](../app/README.md).

```
bash teste.sh localhost
```



## Teste da aplicação na máquina remota

Execute o comando a seguir caso tenha seguido os passos [do README da pasta infra/](../infra/README.md).


```
bash teste.sh remotehost
```

