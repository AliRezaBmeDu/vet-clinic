/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id serial PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(8, 2)
);


/* Add new column */
ALTER TABLE animals ADD COLUMN species VARCHAR(255);

-- Create table "owners"
CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INTEGER
);

-- Create table species
CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);