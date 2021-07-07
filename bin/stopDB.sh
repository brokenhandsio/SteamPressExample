#!/bin/bash
containerID=$(docker ps -q -f "name=steampress")
docker rm -f $containerID