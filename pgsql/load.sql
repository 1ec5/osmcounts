SET client_encoding = 'UTF8';

CREATE TABLE osmcounts_ecus2012 (id serial, geoid varchar(11), id2 varchar(2), geoname varchar, naicsid varchar, naicslabel varchar, year integer, estab integer, estab_s real);

CREATE OR REPLACE FUNCTION osmcounts_states_containing(way geometry(Geometry, 3857))
	RETURNS varchar(2)[]
	LANGUAGE SQL
	STABLE
	AS $$
	
	SELECT array_agg(stusps)
	FROM osmcounts_us_state
	WHERE ST_Intersects(way, geom);
$$;

CREATE OR REPLACE FUNCTION osmcounts_poi_category(
	amenity text,
	building text,
	historic text,
	landuse text,
	leisure text,
	man_made text,
	office text,
	power text,
	shop text,
	sport text,
	tourism text,
	tags hstore)
	RETURNS varchar
	LANGUAGE SQL
	STABLE
	AS $$
	
	SELECT CASE
	-- Pet Care (except Veterinary) Services 
	WHEN amenity = 'animal_boarding' THEN '81291'
	-- Depository Credit Intermediation 
	WHEN amenity = 'bank' THEN '5221'
	-- Drinking Places (Alcoholic Beverages)
	WHEN amenity IN ('bar', 'pub', 'biergarten') THEN '7224'
	-- Recreational Goods Rental 
	WHEN amenity IN ('boat_rental', 'bicycle_rental') THEN '532292'
	-- Snack and Nonalcoholic Beverage Bars 
	WHEN amenity IN ('cafe', 'ice_cream') THEN '722515'
	-- Passenger Car Rental 
	WHEN amenity = 'car_rental' THEN '532111'
	-- Car Washes 
	WHEN amenity = 'car_wash' THEN '811192'
	-- Casinos (except Casino Hotels)
	WHEN amenity = 'casino' OR leisure = 'adult_gaming_centre' THEN '71321'
	-- Child Day Care Services
	WHEN amenity = 'childcare' THEN '6244'
	-- Motion Picture and Video Exhibition
	WHEN amenity = 'cinema' THEN '51213'
	-- Drive-In Motion Picture Theaters 
	WHEN (amenity = 'cinema' AND tags->'drive_in' = 'yes') THEN '512132'
	-- Junior Colleges
	WHEN amenity = 'college' THEN '6112'
	-- Courts 
	WHEN amenity = 'courthouse' THEN '92211'
	-- Offices of Dentists
	WHEN amenity = 'dentist' OR tags->'healthcare' = 'dentist' THEN '6212'
	-- Offices of Physicians
	WHEN amenity = 'doctors' OR tags->'healthcare' = 'doctor' THEN '6211'
	-- Automobile Driving Schools 
	WHEN amenity = 'driving_school' THEN '611692'
	-- Limited-Service Restaurants 
	WHEN amenity IN ('fast_food', 'food_court') THEN '722513'
	-- Fire Protection 
	WHEN amenity = 'fire_station' THEN '92216'
	-- Gasoline Stations 
	WHEN amenity = 'fuel' THEN '447'
	-- Hospitals
	WHEN amenity = 'hospital' OR tags->'healthcare' = 'hospital' THEN '622'
	-- Language Schools
	WHEN amenity = 'language_school' THEN '61163'
	-- Libraries and Archives
	WHEN amenity IN ('library', 'archive') THEN '51912'
	-- Fine Arts Schools
	WHEN amenity IN ('music_school', 'dancing_school') THEN '61161'
	-- Parking Lots and Garages 
	WHEN amenity = 'parking' THEN '81293'
	-- Police Protection 
	WHEN amenity = 'police' THEN '92212'
	-- Postal Service
	WHEN amenity = 'post_office' THEN '491'
	-- Correctional Institutions 
	WHEN amenity = 'prison' THEN '92214'
	-- Scientific Research and Development Services; Marketing Research and Public Opinion Polling; Space Research and Technology
	WHEN amenity = 'research_institute' OR office = 'research' THEN '5417,54191,927'
	-- Full-Service Restaurants 
	WHEN amenity = 'restaurant' THEN '722511'
	-- Elementary and Secondary Schools
	WHEN amenity IN ('school', 'kindergarten', 'preschool') THEN '6111'
	-- Colleges, Universities, and Professional Schools
	WHEN amenity = 'university' THEN '6113'
	-- Veterinary Services
	WHEN amenity = 'veterinary' THEN '54194'
	-- Historical Sites
	WHEN historic IN ('archaeological_site', 'battlefield', 'castle', 'farm', 'fort', 'memorial', 'monument', 'ruins', 'ship') THEN '71212'
	-- Apiculture
	WHEN landuse = 'apiary' OR tags->'craft' = 'beekeeper' THEN '11291'
	-- Aquaculture
	WHEN landuse = 'aquaculture' THEN '1125'
	-- Crop Production; Animal Production and Aquaculture
	WHEN landuse = 'farm' OR landuse = 'farmland' THEN '111,112'
	-- Forestry and Logging
	WHEN landuse = 'forest' OR office = 'forestry' OR tags->'produce' = 'timber' THEN '113'
	-- Greenhouse, Nursery, and Floriculture Production
	WHEN landuse IN ('greenhouse_horticulture', 'plant_nursery') THEN '1114'
	-- Solid Waste Landfill 
	WHEN landuse = 'landfill' THEN '562212'
	-- Logging
	WHEN landuse = 'logging' THEN '1133'
	-- Fruit and Tree Nut Farming
	WHEN landuse = 'orchard' THEN '1113'
	-- Mining (except Oil and Gas)
	WHEN landuse = 'quarry' OR tags->'industrial' = 'mine' THEN '212'
	-- Grape Vineyards 
	WHEN landuse = 'vineyard' THEN '111332'
	-- Skiing Facilities
	WHEN landuse IN ('winter_sports', 'ski_school', 'ski_playground') THEN '71392'
	-- Amusement Arcades
	WHEN leisure = 'amusement_arcade' THEN '71312'
	-- Bowling Centers
	WHEN leisure = 'bowling_alley' OR sport IN ('10pin', '9pin') THEN '71395'
	-- Fishing
	WHEN leisure = 'fishing' THEN '1141'
	-- Fitness and Recreational Sports Centers
	WHEN leisure = 'fitness_centre' THEN '71394'
	-- Golf Courses and Country Clubs
	WHEN leisure IN ('golf_course', 'disc_golf_course', 'miniature_golf') THEN '71391'
	-- Marinas
	WHEN leisure = 'marina' THEN '71393'
	-- Recreational and Vacation Camps (except Campgrounds) 
	WHEN leisure = 'summer_camp' THEN '721214'
	-- Sewage Treatment Facilities 
	WHEN man_made = 'wastewater_plant' THEN '22132'
	-- Manufacturing
	WHEN man_made = 'works' OR tags->'industrial' = 'factory' THEN '31-33'
	-- Offices of Certified Public Accountants 
	WHEN office = 'accountant' THEN '541211'
	-- Advertising Agencies
	WHEN office = 'advertising_agency' THEN '54181'
	-- Architectural Services
	WHEN office = 'architect' THEN '54131'
	-- Social Advocacy Organizations; Civic and Social Organizations; Professional Organizations
	WHEN office = 'association' OR office = 'foundation' THEN '8133,8134,81392'
	-- Grantmaking and Giving Services 
	WHEN office = 'charity' THEN '8132'
	-- Employment Services
	WHEN office = 'employment_agency' THEN '5613'
	-- Engineering Services
	WHEN office = 'engineer' THEN '54133'
	-- Offices of Real Estate Agents and Brokers
	WHEN office = 'estate_agent' THEN '5312'
	-- Public Administration
	WHEN office = 'government' OR amenity = 'townhall' THEN '92'
	-- Tour Operators
	WHEN office = 'guide' THEN '56152'
	-- Insurance Agencies and Brokerages 
	WHEN office = 'insurance' THEN '52421'
	-- Computer Systems Design Services 
	WHEN office = 'it' THEN '541512'
	-- Offices of Lawyers
	WHEN office = 'lawyer' THEN '54111'
	-- General Freight Trucking
	WHEN office = 'logistics' THEN '4841'
	-- Used Household and Office Goods Moving
	WHEN office = 'moving_company' THEN '48421'
	-- Newspaper Publishers
	WHEN office = 'newspaper' THEN '51111'
	-- Offices of Notaries
	WHEN office = 'notary' THEN '54112'
	-- Political Organizations 
	WHEN office = 'political_party' THEN '81394'
	-- Investigation Services 
	WHEN office = 'private_investigator' THEN '561611'
	-- Real Estate Property Managers 
	WHEN office = 'property_management' THEN '53131'
	-- Religious Organizations 
	WHEN office IN ('religion', 'parish') OR amenity = 'place_of_worship' THEN '8131'
	-- Geophysical Surveying and Mapping Services; Surveying and Mapping (except Geophysical) Services
	WHEN office = 'surveyor' THEN '54136,54137'
	-- Public Finance Activities 
	WHEN office = 'tax' OR tags->'government' = 'tax' THEN '92113'
	-- Tax Preparation Services 
	WHEN office = 'tax_advisor' THEN '541213'
	-- Telecommunications
	WHEN office = 'telecommunication' THEN '517'
	-- Offices of Physical, Occupational and Speech Therapists, and Audiologists
	WHEN office = 'therapist' OR tags->'healthcare' IN ('occupational_therapist', 'physiotherapist', 'speech_therapist', 'audiologist') THEN '62134'
	-- Water, Sewage and Other Systems 
	WHEN office = 'water_utility' THEN '2213'
	-- Electric Power Generation, Transmission and Distribution
	WHEN power = 'generator' THEN '2211'
	-- Beer, Wine, and Liquor Stores 
	WHEN shop IN ('alcohol', 'wine') THEN '4453'
	-- Household Appliance Stores 
	WHEN shop = 'appliance' THEN '443141'
	-- Art Dealers 
	WHEN shop = 'art' THEN '45392'
	-- Baked Goods Stores 
	WHEN shop IN ('bakery', 'pastry') THEN '445291'
	-- Beauty Salons 
	WHEN shop = 'beauty' OR leisure = 'tanning_salon' THEN '812112'
	-- Boat Dealers 
	WHEN shop = 'boat' THEN '441222'
	-- Book Stores 
	WHEN shop = 'books' THEN '451211'
	-- Meat Markets 
	WHEN shop = 'butcher' THEN '44521'
	-- Automobile Dealers; Passenger Car Leasing 
	WHEN shop = 'car' THEN '4411,532112'
	-- Automotive Parts and Accessories Stores 
	WHEN shop = 'car_parts' THEN '44131'
	-- Automotive Repair and Maintenance
	WHEN shop IN ('car_repair', 'motorcycle_repair') OR amenity = 'car_wash' THEN '8111'
	-- Floor Covering Stores 
	WHEN shop IN ('carpet', 'flooring', 'tiles') THEN '44221'
	-- Pharmacies and Drug Stores 
	WHEN shop = 'chemist' OR amenity = 'pharmacy' THEN '44611'
	-- Confectionery and Nut Stores 
	WHEN shop IN ('chocolate', 'confectionery') THEN '445292'
	-- Clothing Stores 
	WHEN shop = 'clothes' THEN '4481'
	-- Convenience Stores 
	WHEN shop = 'convenience' THEN '44512'
	-- Gasoline Stations with Convenience Stores 
	WHEN shop = 'convenience' THEN '44711'
	-- Other Business Service Centers (including Copy Shops) 
	WHEN shop = 'copyshop' THEN '561439'
	-- Cosmetics, Beauty Supplies, and Perfume Stores 
	WHEN shop IN ('cosmetics', 'hairdresser_supply', 'perfumery') THEN '44612'
	-- Hobby, Toy, and Game Stores 
	WHEN shop IN ('craft', 'frame', 'games', 'model', 'photo', 'camera', 'video_games', 'toys') THEN '45112'
	-- Window Treatment Stores 
	WHEN shop IN ('curtain', 'window_blind') THEN '442291'
	-- Department Stores (except Discount Department Stores) 
	WHEN shop = 'department_store' THEN '452111'
	-- Home Centers 
	WHEN shop = 'doityourself' THEN '44411'
	-- All Other Home Furnishings Stores 
	WHEN shop IN ('doors', 'bed', 'candles', 'interior_decoration', 'kitchen', 'lamps', 'lighting', 'bathroom_furnishing', 'fireplace') THEN '442299'
	-- Electronics Stores 
	WHEN shop IN ('electronics', 'computer', 'hifi', 'vaccum_cleaner', 'robot', 'music') THEN '443142'
	-- Florists 
	WHEN shop = 'florist' THEN '4531'
	-- Fuel Dealers 
	WHEN shop = 'fuel' THEN '45431'
	-- Funeral Homes and Funeral Services 
	WHEN shop = 'funeral_directors' THEN '81221'
	-- Furniture Stores 
	WHEN shop IN ('furniture', 'antiques') THEN '4421'
	-- Nursery, Garden Center, and Farm Supply Stores 
	WHEN shop IN ('garden_centre', 'agrarian', 'garden_furniture') THEN '44422'
	-- All Other General Merchandise Stores 
	WHEN shop IN ('general', 'country_store') THEN '45299'
	-- Fruit and Vegetable Markets 
	WHEN shop IN ('greengrocer', 'farm') THEN '44523'
	-- Sewing, Needlework, and Piece Goods Stores 
	WHEN shop IN ('haberdashery', 'sewing') THEN '45113'
	-- Barber Shops 
	WHEN shop = 'hairdresser' THEN '812111'
	-- Hardware Stores 
	WHEN shop = 'hardware' THEN '44413'
	-- Food (Health) Supplement Stores 
	WHEN shop IN ('health_food', 'nutrition_supplements') THEN '446191'
	-- Jewelry Stores 
	WHEN shop = 'jewelry' OR tags->'craft' = 'watchmaker' THEN '44831'
	-- Drycleaning and Laundry Services 
	WHEN shop IN ('laundry', 'dry_cleaning') THEN '8123'
	-- Luggage and Leather Goods Stores 
	WHEN shop IN ('leather', 'bag') OR tags->'clothes' = 'leather' THEN '44832'
	-- Consumer Lending 
	WHEN shop = 'money_lender' THEN '522291'
	-- Motorcycle, ATV, and All Other Motor Vehicle Dealers 
	WHEN shop IN ('motorcycle', 'atv', 'jetski', 'snowmobile', 'vehicle') THEN '441228'
	-- Musical Instrument and Supplies Stores 
	WHEN shop = 'musical_instrument' THEN '45114'
	-- News Dealers and Newsstands 
	WHEN shop = 'newsagent' THEN '451212'
	-- Paint and Wallpaper Stores 
	WHEN shop = 'paint' THEN '44412'
	-- Pet and Pet Supplies Stores 
	WHEN shop = 'pet' THEN '45391'
	-- General Rental Centers
	WHEN shop = 'rental' THEN '5323'
	-- Fish and Seafood Markets 
	WHEN shop = 'seafood' THEN '44522'
	-- Used Merchandise Stores 
	WHEN shop = 'second_hand' OR tags ? 'second_hand' THEN '4533'
	-- Security Systems Services (except Locksmiths) 
	WHEN shop = 'security' THEN '561621'
	-- Shoe Stores 
	WHEN shop = 'shoes' THEN '4482'
	-- Sporting Goods Stores 
	WHEN shop IN ('sports', 'bicycle', 'fishing', 'free_flying', 'hunting', 'outdoor', 'scuba_diving', 'ski', 'swimming_pool', 'weapons', 'golf', 'fishing') OR tags->'clothes' = 'sports' THEN '45111'
	-- Office Supplies and Stationery Stores 
	WHEN shop = 'stationery' THEN '45321'
	-- Lessors of Miniwarehouses and Self-Storage Units 
	WHEN shop = 'storage_rental' THEN '53113'
	-- Supermarkets and Other Grocery (except Convenience) Stores 
	WHEN shop IN ('supermarket', 'grocery') THEN '44511'
	-- Tobacco Stores 
	WHEN shop IN ('tobacco', 'e-cigarette') THEN '453991'
	-- Other Building Material Dealers 
	WHEN shop = 'trade' THEN '44419'
	-- Travel Agencies
	WHEN shop = 'travel_agency' OR office = 'travel_agent' THEN '56151'
	-- Gift, Novelty, and Souvenir Stores 
	WHEN shop IN ('trophy', 'anime', 'gift') THEN '45322'
	-- Tire Dealers 
	WHEN shop = 'tyres' THEN '44132'
	-- Discount Department Stores 
	WHEN shop = 'variety_store' THEN '452112'
	-- Video Tape and Disc Rental
	WHEN shop = 'video' THEN '53223'
	-- Wholesale Trade
	WHEN shop = 'wholesale' OR tags ? 'wholesale' THEN '42'
	-- All Other Traveler Accommodation 
	WHEN tourism IN ('alpine_hut', 'apartment', 'chalet', 'wilderness_hut', 'hostel') THEN '721199'
	-- RV (Recreational Vehicle) Parks and Campgrounds 
	WHEN tourism IN ('caravan_site', 'camp_site') THEN '721211'
	-- Bed-and-Breakfast Inns 
	WHEN tourism = 'guest_house' THEN '721191'
	-- Hotels (except Casino Hotels) and Motels; Casino Hotels
	WHEN tourism IN ('hotel', 'motel') THEN '72111,72112'
	-- Convention and Visitors Bureaus 
	WHEN tourism = 'information' AND tags->'information' = 'office' THEN '561591'
	-- Museums
	WHEN tourism = 'museum' THEN '71211'
	-- Amusement and Theme Parks
	WHEN tourism = 'theme_park' OR leisure = 'water_park' THEN '71311'
	-- Zoos and Botanical Gardens
	WHEN tourism IN ('zoo', 'aquarium') THEN '71213'
	ELSE NULL END;
$$;
