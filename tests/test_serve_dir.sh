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
[ "hello world" = "$(curl http://127.0.0.1:"$port"/foo/bar)" ]
curl http://127.0.0.1:"$port"/baz >&2 | grep -q 404
[ "hellooooo" = "$(curl -X POST -d 'hellooooo' http://127.0.0.1:"$port"/foo/echo)" ]
[ "hellooooo sub" = "$(curl -X POST -d 'hellooooo sub' http://127.0.0.1:"$port"/foo/echo/sub)" ]
curl http://127.0.0.1:"$port"/foo/fail >&2 | grep -q 500
curl http://127.0.0.1:"$port"/../foo >&2 | grep -q 403
kill -9 "$pid"
wait "$pid"
