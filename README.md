# Exemplo docker, terraform, ansible na AWS

Exemplo de aplicação API REST com docker, terraform e ansible na AWS. A aplicação **pode ser executada** tanto no ambiente *local* (requer docker instalado localmente) quanto em uma *máquina na AWS* (requer ansible e terraform instalados localmente). Detalhes nas seções a seguir.

***Obs:*** este projeto guarda chaves privadas para SSH na pasta `infra/keys`. Em um ambiente real, é recomendável guardá-las em um *vault*.


## Requisitos de sistema operacional da máquina local

Este projeto requer que esteja-se usando uma das seguintes distribuições Linux:

- Ubuntu 18.04.2 ou superior
- Mint 18.2 ou superior

Para outras distribuições, há links de auxílio nos demais READMEs.


## Clonando

```
# substitua <URL> e <PATH>
git clone <URL> <PATH>
cd <PATH>
```

## Executando localmente

Veja [neste link](app/README.md).


## Executando na AWS

Veja [neste link](infra/README.md).


## Testando (tanto para deploy local quanto na AWS)

Veja [neste link](teste/README.md).

