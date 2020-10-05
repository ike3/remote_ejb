#/bin/bash

#sudo docker container run -p 1521:1521 -d --name=remote-ejb-transactions-db --rm remote-ejb-transactions-db

sudo docker container run -p 8083:8083 -d --name=remote-ejb-transactions-server --rm remote-ejb-transactions-server
sudo docker container run -p 8081:8081 -d --name=remote-ejb-transactions-client --rm remote-ejb-transactions-client
