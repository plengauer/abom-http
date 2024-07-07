#!/bin/sh
set -e
echo "deb [arch=all] http://3.73.14.87:8000/ stable main" | sudo tee /etc/apt/sources.list.d/abom-http.list
sudo apt-get update --allow-insecure-repositories
sudo apt-get install -y --allow-unauthenticated abom-http
