#!/usr/bin/env
bd_name="my_bd"
docker cp ./data $bd_name:/
cat  ./sql/copy_data.sql | docker exec -i $bd_name psql -U andrew -d postgres