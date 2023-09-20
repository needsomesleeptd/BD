#!/usr/bin/env
cat  ./sql/drop.sql | docker exec -i habr-pg-13.3 psql -U andrew -d postgres