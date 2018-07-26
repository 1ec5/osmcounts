SET client_encoding = 'UTF8';

SELECT state, naics, sum(count)
FROM (
    SELECT unnest(osmcounts_states_containing(way)) AS state, osmcounts_poi_category(
        amenity,
        building,
        historic,
        landuse,
        leisure,
        man_made,
        office,
        power,
        shop,
        sport,
        tourism,
        tags) AS naics, count(*) AS count
    FROM planet_osm_point
    WHERE ST_Intersects(way, osmcounts_us_geometry()) AND coalesce(amenity, historic, leisure, man_made, office, power, shop, tourism) IS NOT NULL
    GROUP BY naics, state
    UNION ALL
    SELECT unnest(osmcounts_states_containing(way)) AS state, osmcounts_poi_category(
        amenity,
        building,
        historic,
        landuse,
        leisure,
        man_made,
        office,
        power,
        shop,
        sport,
        tourism,
        tags) AS naics, count(*) AS count
    FROM planet_osm_polygon
    WHERE way && osmcounts_us_geometry() AND coalesce(amenity, historic, leisure, man_made, office, power, shop, tourism) IS NOT NULL
    GROUP BY naics, state) counts
WHERE naics IS NOT NULL
GROUP BY naics, state
ORDER BY state ASC, naics ASC;
