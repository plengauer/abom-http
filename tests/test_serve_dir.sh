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
curl -v http://127.0.0.1:"$port"/foo/fail 2>&1 | tee /dev/stderr | grep -q 500
curl -v http://127.0.0.1:"$port"/../foo 2>&1 | tee /dev/stderr | grep -q 403
kill -9 "$pid"
wait "$pid"
