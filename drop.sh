#!/usr/bin/env bash

psql -h osmdb.eqiad.wmnet -U osm gis -f pgsql/drop.sql
