--- check schema
SELECT
    schema_name
FROM
    information_schema.schemata
WHERE
    schema_name = 'projekt';

--- drop schema
DROP SCHEMA "projekt" CASCADE;

--- select schema
SET
    search_path TO projekt;
