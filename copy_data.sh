#!/usr/bin/env
cat  ./sql/copy_data.sql | docker exec -i habr-pg-13.3 psql -U andrew -d postgres