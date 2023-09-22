#!/usr/bin/env
bd_name="my_bd"
cat  ./sql/drop.sql | docker exec -i $bd_name psql -U andrew -d postgres