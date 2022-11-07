/**
  Collection of SQL queries to run into a Starbust instance.

  Assumptions:
  - Data files (fraud_100_empty_0.parquet and fraud_100_empty_0.parquet) are stored in a S3 bucket called 'fraud_data' and the operator has connectivity to it.
  - You have access to the console to execute the queries either the Web UI or the terminal.
  - The hive metastore operator is running.
 */

-- Create the Schema is it doesn't exist yet in the catalog
CREATE SCHEMA IF NOT EXISTS hive.fraud WITH (location = 's3a://fraud/');

-- Create the table
CREATE TABLE IF NOT EXISTS hive.fraud.fraud_data
(
    timestamp       INTEGER,
    label           VARCHAR,
    user_id         INTEGER,
    amount          DOUBLE,
    merchant_id     INTEGER,
    trans_type      VARCHAR,
    foreign         BOOLEAN,
    interarrival    DOUBLE
) WITH ( external_location = 's3a://fraud/fraud_data', format = 'PARQUET' );

-- Now, verify that the table was successfully created
DESC hive.fraud.fraud_data;
-- Output:
/*
    Column    |  Type   | Extra | Comment
--------------+---------+-------+---------
 timestamp    | integer |       |
 label        | varchar |       |
 user_id      | integer |       |
 amount       | double  |       |
 merchant_id  | integer |       |
 trans_type   | varchar |       |
 foreign      | boolean |       |
 interarrival | double  |       |
(8 rows)
 */

/**
    Assuming there are some corruptions in the data, we can use this to clean it
    and store it back to the S3 bucket, removing the corrupted data.
 */
-- Deactivate statics (more information here -> https://github.com/trinodb/trino/issues/9097)
SET SESSION hive.parquet_ignore_statistics = true;

-- Create the new catalog 'clean_data' with only non-corrupted data.
CREATE TABLE hive.fraud.clean_data WITH (format = 'PARQUET') AS (
    SELECT * FROM hive.fraud.fraud_data
    WHERE amount > 0 AND merchant_id > 0 AND LENGTH(label) > 0
);

-- List all unique values for the column 'label'
SELECT DISTINCT label FROM hive.fraud.clean_data;
-- Output:
/*
   label
------------
 fraud
 legitimate
(2 rows)
 */

-- List all unique value for the column 'trans_type'
SELECT DISTINCT trans_type FROM hive.fraud.clean_data;
-- Output:
/*
   trans_type
--------------
 manual
 online
 chip_and_pin
 swipe
 contactless
(5 rows)
 */

-- List the top 3 most repeated transactions types
SELECT trans_type, COUNT(timestamp) FROM hive.fraud.clean_data
GROUP BY trans_type ORDER BY 2 DESC LIMIT 3;
-- Output:
/*
 SELECT trans_type, COUNT(timestamp) FROM hive.fraud.fraud_data
    -> GROUP BY trans_type ORDER BY 2 DESC LIMIT 3;
  trans_type  | _col1
--------------+-------
 swipe        |    41
 chip_and_pin |    37
 contactless  |    34
(3 rows)
 */

-- List the top 3 most repeated legit transactions
SELECT trans_type, COUNT(timestamp) FROM hive.fraud.clean_data
WHERE label = 'legitimate'
GROUP BY trans_type ORDER BY 2 DESC LIMIT 3;
-- Output:
/*
   trans_type  | _col1
--------------+-------
 chip_and_pin |    21
 swipe        |    20
 manual       |    20
(3 rows)
 */

-- List the top 3 most repeated fraudulent transactions
SELECT trans_type, COUNT(timestamp) FROM hive.fraud.clean_data
WHERE label = 'fraud'
GROUP BY trans_type ORDER BY 2 DESC LIMIT 3;
-- Output:
/*
 trans_type  | _col1
-------------+-------
 swipe       |    21
 contactless |    17
 online      |    17
(3 rows)
 */

-- List how many fraudulent or legit transactions there are by type
SELECT label, trans_type, count(timestamp) FROM hive.fraud.clean_data
GROUP BY label, trans_type
ORDER BY label, trans_type;
-- Output
/*
   label    |  trans_type  | _col2
------------+--------------+-------
 fraud      | chip_and_pin |    16
 fraud      | contactless  |    17
 fraud      | manual       |    12
 fraud      | online       |    17
 fraud      | swipe        |    21
 legitimate | chip_and_pin |    21
 legitimate | contactless  |    17
 legitimate | manual       |    20
 legitimate | online       |    13
 legitimate | swipe        |    20
(10 rows)
*/
