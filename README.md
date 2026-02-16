# abom-http
This is an abomination of an http server. Do not use it! It should not exist! It is written in shell script for no good reason at all and is a major vulnerability waiting to happen!

If you still wanna use it, keep reading and learn how.

This server is designed to host a directory of files with minimal dependencies and overhead.

## Serving a static directory (primary)
Given a directory to serve, it will resolve to `GET` requests by serving the respective file. `PUT` requests will create new files, `DELETE` will delete them assuming the directory is writable. If the directory should not be modifable, start the server under a user that cannot write the directory and it will respond accordingly to the client.

## Serving dynamic responses (secondary)
Assuming a file to be served is executable, it will not be served as is. Rather it will run the executable with the method and path as arguments and pipe stdout back to the client. Therefore, every such executable is expected to write a valid HTTP response to stdout. The exit code of the executable should be zero assuming it wrote a valid HTTP response, even if its not of the 2xx family. The content of the HTTP request, if any, will be piped to stdin of the executable. Executables will also be used if they are at any parent location of the HTTP request path.

## Serving global dynamic responses (tertiary)
In case the path in question does not exist, neither as an executable nor as a regular file, a global executable can be specified to generate dynamic responses instead of responding with errors

## Install
Install either via
```
wget -O - https://raw.githubusercontent.com/plengauer/abom-http/main/INSTALL.sh | sh
```
or via
```
echo "deb [arch=all] https://3.73.14.87:8000/ stable main" | sudo tee /etc/apt/sources.list.d/abomhttp.list
sudo apt-get update
sudo apt-get install abom-http
```

## Configure & start
Start with `abomhttp 8080 /path/to/my/directory` to serve the given directory at port 8080.
