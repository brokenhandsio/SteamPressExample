#!/bin/bash
docker run --name steampress -e POSTGRES_DB=steampress -e POSTGRES_USER=steampress -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
