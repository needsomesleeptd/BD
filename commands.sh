#!/usr/bin/env 
#connect:
psql -h localhost -p 5432 -U andrew --dbname=postgres
#connect to shell:
docker exec -it habr-pg-13.3 bash