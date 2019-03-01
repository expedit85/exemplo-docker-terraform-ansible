# Scripts para teste automatizado da aplicação

Este documento contém instruções de demonstração de testes automatizados. Foi construído um shell script que usa curl para requisições específicas e Apache Benchmark para um pequeno teste de performance.

O teste inclui algumas inserções, deleções e listagens. Inserções com valor vazio e maior que o tamanho limite do campo da tabela no banco de dados.

Em uma das inserções de teste, notou-se que a API permite a inserção de uma anotação vazia ao enviar o valor `=` para `POST /notes`.

Em outra inserção, notou-se que a API permite a inserção de uma anotação que extrapola o limite do tamanho da coluna.


## Pré-requisitos

- curl
- ab (Apache Benchmark)

### Instalação no Ubuntu/Mint

```
sudo apt-get install curl apache2-utils
```



## Teste da aplicação na máquina local

Execute o comando a seguir caso tenha seguido os passos [do README da pasta app/](../app/README.md).

```
bash teste.sh localhost
```



## Teste da aplicação na máquina remote

Execute o comando a seguir caso tenha seguido os passos [do README da pasta infra/](../infra/README.md).


```
bash teste.sh remotehost
```

