# Exemplo docker, terraform, ansible na AWS

Exemplo de aplicação API REST com docker, terraform e ansible na AWS. A aplicação pode ser executada tanto no ambiente local (requer docker instalado) quanto em uma máquina EC2/AWS (requer ansible e terraform). Detalhes na seções a seguir.

***Atenção:*** a pasta `infra/keys` contém chaves privadas apenas para teste. Em um ambiente real, novas chaves devem ser geradas e o repositório deve ser mantido privado ou novas chaves devem ser mantidas em um *vault*.


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

