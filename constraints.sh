#!/usr/bin/env
bd_name="my_bd"
cat  ./sql/constraints.sql | docker exec -i $bd_name psql -U andrew -d postgres