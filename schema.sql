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

-- Create table "owners"

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INTEGER
);

/* Create table species */

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- check if the animals have column id as autoincremented primary key
/d animals

-- Drop species
ALTER TABLE animals DROP COLUMN species;

-- Add the "species_id" column as a foreign key referencing the "species" table:
ALTER TABLE animals ADD COLUMN species_id INTEGER,
ADD CONSTRAINT fk_species_id FOREIGN KEY (species_id) REFERENCES species(id);

-- Add the "owner_id" column as a foreign key referencing the "owners" table:
ALTER TABLE animals ADD COLUMN owner_id INTEGER,
ADD CONSTRAINT fk_owner_id FOREIGN KEY (owner_id) REFERENCES owners(id);