#!/bin/sh -e

port=8080
directory="$(mktemp -d)"
mkdir "$directory/foo"
touch "$directory/foo/bar"
mkdir "$directory/foo/baz"
echo hello world > "$directory/foo/bar"

abomhttp "$port" "$directory" &
pid="$!"
[ "hello world" "$(curl http://127.0.0.1:"$port"/foo/bar)" ]
curl http://127.0.0.1:"$port"/bar >&2 | grep -q 404
kill -9 "$pid"
wait "$pid"
