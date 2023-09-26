/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Agumon', '2020-02-03', 10.23, true, 0);

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Gabumon', '2018-11-15', 8, true, 2);

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Pikachu', '2021-01-07', 15.04, false, 1);

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Devimon', '2017-05-12', 11, true, 5);

/* Populate with new data */
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Charmander', '2020-02-08', -11, false, 0, NULL);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Plantmon', '2021-11-15', -5.7, true, 2, NULL);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Squirtle', '1993-04-02', -12.13, false, 3, NULL);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Angemon', '2005-06-12', -45, true, 1, NULL);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Boarmon', '2005-06-07', 20.4, true, 7, NULL);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Blossom', '1998-10-13', 17, true, 3, NULL);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species) VALUES ('Ditto', '2022-05-14', 22, true, 4, NULL);

-- Insert data into the "owners" table
INSERT INTO owners (full_name, age)
VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);
	
-- Insert data into the "species" table
INSERT INTO species (name)
VALUES
    ('Pokemon'),
    ('Digimon');

-- Update the "species_id" column in animals based on the names
UPDATE animals
SET species_id = CASE 
WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
ELSE (SELECT id FROM species WHERE name = 'Pokemon')
END;

-- Update the "owner_id" column based on owner information
UPDATE animals
SET owner_id = CASE
WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
END;

/*-------------------Insert vets data--------------*/

-- Insert data for Vet William Tatcher
INSERT INTO vets (name, age, date_of_graduation) VALUES ('William Tatcher', 45, '2000-04-23');

-- Insert data for Vet Maisy Smith
INSERT INTO vets (name, age, date_of_graduation) VALUES ('Maisy Smith', 26, '2019-01-17');

-- Insert data for Vet Stephanie Mendez
INSERT INTO vets (name, age, date_of_graduation) VALUES ('Stephanie Mendez', 64, '1981-05-04');

-- Insert data for Vet Jack Harkness
INSERT INTO vets (name, age, date_of_graduation) VALUES ('Jack Harkness', 38, '2008-06-08');

/*  Insert DATA to relationship tables */

-- Retrieve vet IDs based on vet names
WITH vet_ids AS (
    SELECT
        id AS vet_id,
        name AS vet_name
    FROM
        vets
),

-- Retrieve species IDs based on species names
species_ids AS (
    SELECT
        id AS species_id,
        name AS species_name
    FROM
        species
)

-- Now, insert data into the "specializations" table
INSERT INTO specializations (vet_id, species_id)
SELECT
    v.vet_id,
    s.species_id
FROM
    vet_ids v
JOIN
    species_ids s
ON
    (v.vet_name = 'William Tatcher' AND s.species_name = 'Pokemon') OR
    (v.vet_name = 'Stephanie Mendez' AND s.species_name IN ('Digimon', 'Pokemon')) OR
    (v.vet_name = 'Jack Harkness' AND s.species_name = 'Digimon');

    -- Insert data for visits
INSERT INTO visits (vet_id, animal_id, visit_date)
VALUES
    ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM animals WHERE name = 'Agumon'), '2020-05-24'),
    ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Agumon'), '2020-07-22'),
    ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Gabumon'), '2021-02-02'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Pikachu'), '2020-01-05'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Pikachu'), '2020-03-08'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Pikachu'), '2020-05-14'),
    ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Devimon'), '2021-05-04'),
    ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Charmander'), '2021-02-24'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Plantmon'), '2019-12-21'),
    ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM animals WHERE name = 'Plantmon'), '2020-08-10'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Plantmon'), '2021-04-07'),
    ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Squirtle'), '2019-09-29'),
    ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Angemon'), '2020-10-03'),
    ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM animals WHERE name = 'Angemon'), '2020-11-04'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2019-01-24'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2019-05-15'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2020-02-27'),
    ((SELECT id FROM vets WHERE name = 'Maisy Smith'), (SELECT id FROM animals WHERE name = 'Boarmon'), '2020-08-03'),
    ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM animals WHERE name = 'Blossom'), '2020-05-24'),
    ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM animals WHERE name = 'Blossom'), '2021-01-11');