/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name <> 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Transaction-1 */
BEGIN;
UPDATE animals SET species = 'Unspecified';
ROLLBACK;

/* Transaction-2 */
BEGIN;
UPDATE animals SET species = 'Digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'Pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;

/* Transaction-3 */
BEGIN;
-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint
SAVEPOINT weight_update_savepoint;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = -1 * weight_kg;

-- Rollback to the savepoint
ROLLBACK TO weight_update_savepoint;

-- Update animals' weights that are negative back to positive
UPDATE animals SET weight_kg = -1 * weight_kg WHERE weight_kg < 0;

COMMIT;
