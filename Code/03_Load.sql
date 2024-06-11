-- Drop tables if they exist (order of dropping respects foreign key dependencies)
DROP TABLE IF EXISTS flight_search;
DROP TABLE IF EXISTS airports;

-- Create airports table
CREATE TABLE airports (
    "Rank" VARCHAR NOT NULL,
    "Airport" VARCHAR(255) NOT NULL,
    "Location" VARCHAR(255) NOT NULL,
    "Country" VARCHAR(255) NOT NULL,
	"A/P Code" VARCHAR(20) NOT NULL,
    "Total Passengers" VARCHAR(20) NOT NULL,
    "IATA" VARCHAR(10) NOT NULL,
    "ICAO Code" VARCHAR(10) NOT NULL,
    PRIMARY KEY ("IATA")
);

-- Change data type of airports table
ALTER TABLE airports
	ALTER COLUMN "Rank" 
	TYPE INTEGER 
	USING REPLACE ("Rank", '.', '')::INTEGER,

	ALTER COLUMN "Total Passengers" 
	TYPE INTEGER 
	USING REPLACE ("Total Passengers", ',', '')::INTEGER;

-- Verify airports table
SELECT * FROM airports;

-- Create flight_search table
CREATE TABLE flight_search (
    _id VARCHAR(255) NOT NULL,
    trip_id INT NOT NULL,
    outbound_date VARCHAR(20) NOT NULL,
    return_date VARCHAR(20) NOT NULL,
    outbound_departure_time VARCHAR(20) NOT NULL,
    outbound_arrival_time VARCHAR(20) NOT NULL,
    outbound_flight_duration VARCHAR(10) NOT NULL,
    outbound_route VARCHAR(10) NOT NULL,
    outbound_airline VARCHAR(30) NOT NULL,
    return_departure_time VARCHAR(20) NOT NULL,
    return_arrival_time VARCHAR(20) NOT NULL,
    return_flight_duration VARCHAR(10) NOT NULL,
    return_route VARCHAR(10) NOT NULL,
    return_airline VARCHAR(30) NOT NULL,
    price VARCHAR(10) NOT NULL,
    tier VARCHAR(30) NOT NULL,
    outbound_airport VARCHAR(10) NOT NULL,
    "IATA" VARCHAR(10) NOT NULL,
    FOREIGN KEY ("IATA") REFERENCES airports("IATA")
);

-- Change data type of flight_search table
ALTER TABLE flight_search
	ALTER COLUMN outbound_date
	TYPE DATE 
	USING outbound_date::DATE,
	
	ALTER COLUMN return_date
	TYPE DATE 
	USING return_date::DATE,

	ALTER COLUMN outbound_departure_time 
	TYPE TIME WITH TIME ZONE 
	USING outbound_departure_time::TIME WITH TIME ZONE,

	ALTER COLUMN outbound_arrival_time 
	TYPE TIME WITH TIME ZONE
	USING outbound_arrival_time::TIME WITH TIME ZONE,
	
	ALTER COLUMN outbound_flight_duration
	TYPE INTERVAL 
	USING outbound_flight_duration::INTERVAL,
	
	ALTER COLUMN return_departure_time 
	TYPE TIME WITH TIME ZONE 
	USING return_departure_time::TIME WITH TIME ZONE,
	
	ALTER COLUMN return_arrival_time 
	TYPE TIME WITH TIME ZONE 
	USING return_arrival_time::TIME WITH TIME ZONE,
	
	ALTER COLUMN return_flight_duration 
	TYPE INTERVAL
	USING return_flight_duration::INTERVAL,
	
	ALTER COLUMN price 
	TYPE MONEY 
	USING REPLACE (price, '$', '')::MONEY;

-- Verify flight_search table
SELECT * FROM flight_search;