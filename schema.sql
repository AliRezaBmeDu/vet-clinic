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


-- create new table named vets
CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INTEGER,
    date_of_graduation DATE
);

-- many-to-many relationship between vets and species
CREATE TABLE specializations (
    vet_id INTEGER REFERENCES vets(id),
    species_id INTEGER REFERENCES species(id),
    PRIMARY KEY (vet_id, species_id)
);

-- many-to-many relationship between vets and species
CREATE TABLE visits (
    vet_id INTEGER REFERENCES vets(id),
    animal_id INTEGER REFERENCES animals(id),
    visit_date DATE,
    PRIMARY KEY (vet_id, animal_id, visit_date)
);

-- ///////////////////////////// Create new database clinic_vets and connect //////////////////////////
CREATE DATABASE clinic_vets;
\c clinic_vets;

CREATE TABLE owners(
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(20),
  age INT,
  PRIMARY KEY(id)
);

CREATE TABLE species(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(20),
  PRIMARY KEY(id)
);

CREATE TABLE animals(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(20),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  species_id INT REFERENCES species(id),
  owner_id INT REFERENCES owners(id),
  PRIMARY KEY(id)
);

CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(20),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

CREATE TABLE specializations(
  id INT GENERATED ALWAYS AS IDENTITY,
  species_id INT REFERENCES species(id),
  vet_id INT REFERENCES vets(id),
  PRIMARY KEY(id)
);

CREATE TABLE visits(
  id INT GENERATED ALWAYS AS IDENTITY,
  animal_id INT REFERENCES animals(id),
  vet_id INT REFERENCES vets(id),
  date_of_visit DATE,
  PRIMARY KEY(id)
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);