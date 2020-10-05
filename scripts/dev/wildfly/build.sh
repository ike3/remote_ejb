#/bin/bash

sudo docker build --tag=remote-ejb-transactions .

cd server
sudo docker build --tag=remote-ejb-transactions-server .
cd -

cd client
sudo docker build --tag=remote-ejb-transactions-client .
cd -

cd db
#sudo docker build --tag=remote-ejb-transactions-db .
cd -
