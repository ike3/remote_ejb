#!/bin/bash

ssh -i ~/.ssh/docker.key ike@docker-server1 "cd /mnt/hgfs/scripts && echo 1 | sudo -S ./build.sh"
