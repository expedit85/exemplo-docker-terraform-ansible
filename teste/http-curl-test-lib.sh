#!/bin/bash
# ###############################################
# Author:  Cristiano Expedito <expedit@gmail.com>
# Date:    2019-01-15
# Update:  2019-01-23 Add counters
# License: MIT
# ###############################################

# Global vars
http_test_tempdir=$(mktemp -d)


# Initialize counter files
cd "$http_test_tempdir"
rm -f .success_count
rm -f .error_count
touch .success_count
touch .error_count
cd - >/dev/null


set-baseurl()
{
	base_url="$1"
}

get-baseurl()
{
	echo $base_url
}


# Test with curl and shell script
expects()
{
	local msg="$1"
	local expected="$2"
	local result=
	read result

	if [ "$expected" = '*' ]; then
		printf "   - %s: ignored\n" "$msg"
	elif [ "$expected" == "$result" ]; then
		printf "   ✔ %s: '%s'\n" "$msg" "$expected"
		echo >> .success_count
	else
		printf "   ❌ %s: expected '%s', got '%s'\n" "$msg" "$expected" "$result"
		echo >> .error_count
	fi
}


test-summary()
{
	local outfile="$(readlink -f "${1:-/dev/null}")"

	cd "$http_test_tempdir"

	local succedded=$(wc -c .success_count | cut -d ' ' -f 1)
	local failed=$(wc -c .error_count   | cut -d ' ' -f 1)

	echo
	echo "HTTP Failed tests:      $(printf "%2d" $failed)"
	echo "HTTP Succedded testes:  $(printf "%2d" $succedded)"

	echo $succedded $failed > "${outfile}"
	cd - >/dev/null
}


# Makes a request and sends status code to stdout and response body to stderr
make-request()
{
	local fmt="%{http_code}\n%{time_total}\n"
	url="$2"
	case "$1" in
		post|POST)
			curl -s -X POST -d "@-" -w "$fmt" -o /dev/stderr "$url"
			;;
		get|GET)
			curl -s -X GET          -w "$fmt" -o /dev/stderr "$url"
			;;
		del|delete|DEL|DELETE)
			curl -s -X DELETE       -w "$fmt" -o /dev/stderr "$url"
			;;
		*)
			echo >> .error_count
			return 1
	esac
}


test-dtime-code()
{
	expected_code=$1
	read code
	read dtime
	printf "   - time: %s ms\n" $dtime
	expects "status" $expected_code <<< $code
}


# Usage: <http-method> <path> <expected-status> <expected-response-body> <label> [<transformation>...]
test-request()
{
	test $# -ge 5 || return 1

	local method="$1"
	shift

	local url="${base_url}$1"
	local code=$2
	local body="$3"
	local label="$4"
	shift 4

	local transformation=cat
	test $# -gt 0 && transformation="$@"
	test -z "$transformation" && transformation=cat

	case "$method" in
		post|POST)
			method=POST
			;;
		get|GET)
			method=GET
			;;
		del|delete|DEL|DELETE)
			method=DELETE
			;;
		*)
			echo >> .error_count
			return 1
	esac

	cd "$http_test_tempdir"

	echo "* $label"
	echo "   - $method $url"
	make-request $method "$url"  \
	  1> >(test-dtime-code "$code" > .code-temp && touch .code-temp-done) \
	  2> >($transformation | expects "body" "$body" > .body-temp && touch .body-temp-done)
	until [ -f .code-temp-done  -a  -f .body-temp-done ]; do sleep 0.010; done # wait
	cat .code-temp .body-temp
	rm  .code-temp* .body-temp*
	sync
	echo

	cd - >/dev/null
}
