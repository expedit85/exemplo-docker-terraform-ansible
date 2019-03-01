#!/bin/bash
source http-curl-test-lib.sh


usage()
{
	cat <<-EOF
	Uso:   bash teste.sh localhost
	       bash teste.sh remotehost
	EOF
	exit 1
}


# Teste usando ansible (apenas remoto)
testa-mysql-remoto()
(
	which ansible ansible-playbook > /dev/null || { echo "Ansible não instalado"; exit 1; }
	cd ../infra/ansible
	../../teste/playbooks/test-mysql.yml
)

testa-mysql-local()
{
	if which ansible ansible-playbook > /dev/null;
	then
		ansible-playbook -i 127.0.0.1, -c local ./playbooks/test-mysql.yml
	else
		show-tables()
		{
			docker exec -i $(docker ps --filter name=db -q) \
			  mysql -N -u notes-api -pnotes-api -h localhost notes <<< 'show tables;'
		}

		if [ "$(show-tables)" != 'Note' ]; then
			echo "❌ Conexão com banco de dados falhou"
			return 1
		else
			echo "✔ Conexão com banco de dados funcionou"

		fi
	fi
}


truncate-table-localhost()
{
	if which ansible ansible-playbook > /dev/null; then
		ansible-playbook -i 127.0.0.1, -c local ./playbooks/truncate-mysql.yml
	else
		docker exec -i $(docker ps --filter name=db -q) \
		  mysql -N -u notes-api -pnotes-api -h localhost notes <<< 'truncate table Note;'
	fi
}

truncate-table-remotehost()
(
	which ansible ansible-playbook > /dev/null || { echo "Ansible não instalado"; exit 1; }
	cd ../infra/ansible
	../../teste/playbooks/truncate-mysql.yml
)




# expected env: hostname
# cmdline: testa-api [<arquivo-sumario>]
testa-api()
{
	# Limpa base de dados
	truncate-table-$hostname

	test-request GET  /notes    200 '[]'  "Listagem de anotações vazia"
	test-request POST /notes    200 'Ok'  "Inserção de anotação"   <<< 'foo=bar'
	test-request DEL  /notes/1  200 'Ok'  "Exclusão de anotação"
	test-request DEL  /notes/1  400 '*'   "Exclusão de anotação inexistente"

	local body1='chave com espaços e caracteres especiais=algum valor também com espaços e caracteres especiais'
	local body2="\"\`chave com espaços e caracteres especiais\` = 'algum valor também com espaços e caracteres especiais'\""
	test-request POST /notes    200 'Ok'      "Inserção de anotação com caracteres especiais"            <<< "$body1"
	test-request GET  /notes    200 "$body2"  "Teste da inserção com caracteres especiais" jq .[0].Text

	test-request POST /notes    400 '*'  "Inserção de anotação vazia"  <<< ''
	test-request POST /notes    400 '*'  "Inserção de anotação sem chave: '='"  <<< '='

	test-request POST /notes    200 'Ok'  "Inserção de uma anotação com 3 pares chave/valor"  <<< 'a=b&x=y&chave=valor'

	local body="$(printf 'k%.0s' {1..200})=$(printf 'v%.0s' {1..200})"
	test-request POST /notes    400 'Ok'     "Inserção de anotação que estoura limite de tamanho da coluna"            <<< "$body"

	sleep .5
	test-summary "$1"
}


# expected env: hostname
realiza-testes()
{
	local success_count=0
	local error_count=0

	# Uso: atualiza-counters <result-status>
	#      atualiza-counters <incremento-sucessos> <incremento-falhas>
	atualiza-counters()
	{
		case $# in
			1)
				test $1 = 0 && success_count=$((success_count + 1)) || error_count=$((error_count + 1))
				;;
			2)
				success_count=$((success_count + $1))
				error_count=$((error_count + $2))
				;;
			*)
				echo "atualiza-counters: quantidade de argumentos inválidos" >&2
				;;
		esac
	}

	# Executa testes
	echo
	echo '======================= TESTANDO ACESSO AO BANCO DE DADOS ======================='
	test "$hostname" == remotehost && testa-mysql-remoto || testa-mysql-local
	atualiza-counters $?

	echo
	echo '=========================== TESTANDO SERVIÇOS DA API ============================'
	summary=$(mktemp)
	testa-api $summary
	read succedded failed < $summary && atualiza-counters $succedded $failed

	echo
	echo '============================= TESTANDO PERFORMANCE =============================='
	ab -k -c 5 -n 1000 "$(get-baseurl)/notes"
	atualiza-counters $?

	echo
	echo '==================================== RESUMO ====================================='
	printf "Sucesso:   %2d\nFalhas:    %2d\n"   $success_count  $error_count

	rm $summary
	return $error_count
}


parse-cmdline()
{
	local hostname="$1"
	shift

	case $hostname in
		localhost)
			local host_addr=127.0.0.1
			;;
		remotehost)
			which terraform >/dev/null || { echo "Terraform não instalado"; exit 1; }
			local host_addr=$(cd ../infra/terraform/cluster > /dev/null; terraform output public_ip)
			test -n "$host_addr" || { echo "Endereço IP remoto desconhecido"; exit 1; }
			;;
		*)
			echo "Nome de host inválido:  $hostname"
			usage
			;;
	esac

	set-baseurl "http://${host_addr}"
	realiza-testes
}


parse-cmdline "$@"

