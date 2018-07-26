DROP TABLE IF EXISTS osmcounts_us_state;
DROP TABLE IF EXISTS osmcounts_ecus2012;
DROP FUNCTION IF EXISTS osmcounts_states_containing(geometry(Geometry, 3857));
DROP FUNCTION IF EXISTS osmcounts_poi_category(
	/*amenity*/ text,
	/*building*/ text,
	/*historic*/ text,
	/*landuse*/ text,
	/*leisure*/ text,
	/*man_made*/ text,
	/*office*/ text,
	/*power*/ text,
	/*shop*/ text,
	/*sport*/ text,
	/*tourism*/ text,
	/*tags*/ hstore);
DROP FUNCTION osmcounts_us_geometry();
