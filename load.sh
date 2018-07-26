#!/usr/bin/env bash

echo 'Loading U.S. geometry...'

psql -h osmdb.eqiad.wmnet -U osm gis -c "CREATE OR REPLACE FUNCTION osmcounts_us_geometry() RETURNS geometry(Geometry, 3857) LANGUAGE SQL IMMUTABLE AS \$\$ SELECT ST_Transform(ST_GeomFromEWKT('$(cat data/wkt/US.wkt)'), 3857); \$\$;"

echo 'Loading state geometries...'

shp2pgsql -s 4269:3857 -I data/shp/cb_2013_us_state_500k.shp osmcounts_us_state | psql -h osmdb.eqiad.wmnet -U osm gis

echo 'Loading tables and functions...'

psql -h osmdb.eqiad.wmnet -U osm gis -f pgsql/load.sql

echo 'Loading Economic Census data...'

for csv in $(ls data/ecus2012/*_clean.txt); do
	perl -pi -e 's/\r/\n/g;s/^.+?\tS\n$//g;s/\(\w\)//g' $csv
	cols='geoid, id2, geoname, naicsid, year, estab'
	if [[ $(grep ESTAB_S $csv) ]]; then
		cols="${cols}, estab_s"
	fi
	command="\\copy osmcounts_ecus2012 ($cols) FROM STDIN (FORMAT csv, HEADER, DELIMITER E'\\t')"
	psql -h osmdb.eqiad.wmnet -U osm gis -c "$command" < $csv
done
