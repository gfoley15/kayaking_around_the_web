# Project 2: kayaking_around_the_web
This project scrapes flight data from kayak.com for the 50 busiest airports in the world according to the 2023 Wikipedia source. The code extracts extracts airport codes from the Wikipedia source, which are then used to run a flight search on kayak.com to find the best flights from our home airport in Kansas City - MCI (Kansas City International Airport). Flight data is then transformed using MongoDB and pandas in order to load into a postgreSQL database.

 - The Wikipedia source for the list of busiest airports by passenger traffic in 2023. https://en.wikipedia.org/wiki/List_of_busiest_airports_by_passenger_traffic.
 - Kayak.com for providing flight data.
 - MongoDB and postgreSQL for database storage.

To install the repository, clone (git clone) using SSH to your local computer using GitBash. Once the repository is installed, navigate to the directory in GitBash and launch jupyter notebook.

# Part 1: Extract Data
 - Open 01_Extract.ipynb in Jupyter Notebook.
 - Run the notebook to extract data from Wikipedia's 2023 busiest airport list
 - Continue to run notebook cells to use extracted airport codes in kayak.com flight search. User will be asked to input outbound and return flight dates to be used in the search.
 - A for loop will web scrape the flight search data for all airport routes from MCI an then append to a MongoDB database collection called flight_search.
 - Once the web scraping is complete, the MongoDB collection will be filled with all flight search results and ready for investigation, transformations.

# Part 2: Transform Data
 - With all flight search data in MongoDB, open 02_Transform.ipynb in Jupyter Notebook.
 - Run all cells in the notebook to clean the data from kayak.com. This will split out outbound airport locations to IATA codes for relationship with the airport table in the SQL schema and remove "+1" from time values.
 - Cleaned data will be placed into a DataFrame and then exported to a CSV for SQL database table import.
   
# Part 3: Load Data _[Albert]_
## Overview
This outlines the process and steps involved in the Load phase of the ETL process for Project 2. The Load phase was executed in four main steps: 1) creating an ERD to guide the database schema setup, 2) creating the database schema, 3) loading data using pgAdmin 4, and 4) modifying data types to prepare for future analysis.

## Entity Relationship Diagram (ERD)
The ERD for this project was developed using QuickERD, an intuitive online tool that simplifies the creation of ERDs. QuickERD provided a user-friendly interface to visually construct the database schema and served as a visual guide for the database structure, facilitating an understanding of table relationships and data flow.
![ERD](/ERD.png)

## Database Schema Setup
The database schema was established by creating two primary tables: airports and flight_search. This step was informed by the ERD and focused on setting up a robust structure to handle the relationships and data integrity requirements efficiently. Below are the SQL commands used to set up the tables:

### Dropping Existing Tables
To prevent conflicts with existing data structures, existing tables are dropped if they exist:
```
DROP TABLE IF EXISTS flight_search;
DROP TABLE IF EXISTS airports;
```

### Creating Tables

#### Airports Table
```
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
```

#### Flight_Search Table
```
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
```

## Data Loading
The transformed data from CSV files was loaded into the PostgreSQL database using pgAdmin 4.

### Import Process
1. **Airports Data**: The data for airports was loaded first to respect foreign key dependencies in the flight_search table.
2. **Flight Search Data**: Following the successful import of the airports data, flight search data was then loaded.

### Using pgAdmin 4 to Import CSV Data

Follow these steps to import CSV data into your database using pgAdmin 4:

##### 1. Open pgAdmin and Connect to Your Database
- Start pgAdmin.
- Connect to your database by navigating through the initial login screens.

##### 2. Navigate to the Table
- Locate your table within pgAdmin:
  - Expand the **Servers** node in the browser pane.
  - Navigate to **Your Server** > **Databases** > **Your Database** > **Schemas** > **Public** > **Tables**.
  - Select **Your Table**.

##### 3. Initiate Import/Export Process
- Right-click on the target table.
- Choose **Import/Export** from the context menu to open the import dialog.

##### 4. Configure Import Settings
- In the dialog box that appears:
  - Set the **Direction** to **Import** under the `General` tab.
  - Use the **Folder** icon to browse and select your CSV file.
  - Ensure the **Format** is set to **CSV**.
  - Optionally, set the **Encoding** according to your CSV file's characteristics.
- Under the `Options` tab:
  - Check the **Header** option if your CSV includes column headers.
  - Specify the **Delimiter** used in your CSV file (commonly a comma `,`).
  - Optionally, set the **Quote character** and **Escape character** according to your CSV file's characteristics.

##### 5. Start the Import
- Click the **OK** button to begin importing data into your database.

## Modifying Data Types
After loading the initial data, several columns underwent data type modifications to better suit the analytical needs and ensure data integrity. These alterations set the foundation for more effective and accurate data analysis in subsequent project phases.
```
ALTER TABLE airports
    ALTER COLUMN "Rank" TYPE INTEGER USING REPLACE("Rank", '.', '')::INTEGER,
    ALTER COLUMN "Total Passengers" TYPE INTEGER USING REPLACE("Total Passengers", ',', '')::INTEGER;

ALTER TABLE flight_search
    ALTER COLUMN outbound_date TYPE DATE USING outbound_date::DATE,
    ALTER COLUMN return_date TYPE DATE USING return_date::DATE,
    -- Other ALTER COLUMN statements
```

# Conclusion
In conclusion, the ETL (Extract, Transform, Load) process is a fundamental methodology in data handling, enabling the efficient aggregation, organization, and analysis of vast data sets from various sources. This project demonstrates the capabilities of the ETL process, which encompasses extracting data using methods like HTML parsing, transforming the data to enhance its structure and relevance, and efficiently loading it into a database for robust analysis. By executing these steps, ETL proves instrumental not only in integrating and refining data but also in facilitating comprehensive data management, enabling more informed decision-making and strategic planning in various business contexts.
