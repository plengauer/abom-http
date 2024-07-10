#!/bin/sh -e

port=8080
directory="$(mktemp -d)"
mkdir "$directory/foo"
touch "$directory/foo/bar"
touch "$directory/foo/echo"
echo hello world > "$directory/foo/bar"
echo '#!/bin/sh -e
/bin/echo -e -n "HTTP/1.1 200 OK\r\n\r\n" && cat' > "$directory/foo/echo"
chmod +x "$directory/foo/echo"
echo '#!/bin/sh -e
exit 1' > "$directory/foo/fail"
chmod +x "$directory/foo/fail"

abomhttp "$port" "$directory" &
pid="$!"
sleep 3
[ "hello world" = "$(curl -v http://127.0.0.1:"$port"/foo/bar)" ]
curl -v http://127.0.0.1:"$port"/foo/baz 2>&1 | tee /dev/stderr | grep -q 404
[ "hellooooo" = "$(curl -v -X POST -d 'hellooooo' http://127.0.0.1:"$port"/foo/echo)" ]
[ "hellooooo sub" = "$(curl -v -X POST -d 'hellooooo sub' http://127.0.0.1:"$port"/foo/echo/sub)" ]
printf 'GET /foo/fail HTTP/1.1\r\n\r\n' | netcat -w 3 127.0.0.1 "$port" | tee /dev/stderr | grep -q 500
printf 'GET /../foo HTTP/1.1\r\n\r\n' | netcat -w 3 127.0.0.1 "$port" | tee /dev/stderr | grep -q 403
printf 'GET /foo/test HTTP/1.1\r\n\r\n' | netcat -w 3 127.0.0.1 "$port" | tee /dev/stderr | grep -q 404
printf 'PUT /foo/test HTTP/1.1\r\nContent-Length: 11\r\n\r\nhello world' | netcat -w 3 127.0.0.1 "$port" | tee /dev/stderr | grep -q 200
[ "hello world" = "$(curl -v http://127.0.0.1:"$port"/test)" ]
printf 'DELETE /foo/test HTTP/1.1\r\n\r\n' | netcat -w 3 127.0.0.1 "$port" | tee /dev/stderr | grep -q 200
printf 'GET /foo/test HTTP/1.1\r\n\r\n' | netcat -w 3 127.0.0.1 "$port" | tee /dev/stderr | grep -q 404
kill -9 "$pid"
