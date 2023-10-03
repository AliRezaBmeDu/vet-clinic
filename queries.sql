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
SELECT species from animals; 
ROLLBACK;
SELECT species from animals;

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

/* quries */
/* How many animals are there? */
SELECT COUNT(*) AS total_animals FROM animals;

/* How many animals have never tried to escape? */
SELECT COUNT(*) AS never_tried_to_escape FROM animals WHERE escape_attempts = 0;

/* What is the average weight of animals? */
SELECT AVG(weight_kg) AS average_weight FROM animals;

/* Who escapes the most, neutered or not neutered animals? */
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts FROM animals GROUP BY neutered;

/* What is the minimum and maximum weight of each type of animal? */
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT species, AVG(escape_attempts) AS avg_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/* QUERIES  */
-- What animals belong to Melody Pond?
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT s.name AS species_name, COUNT(a.id) AS animal_count
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

/*------------------------------------Queries for relationship table------------------------------------*/

-- Who was the last animal seen by William Tatcher?
SELECT a.name AS last_animal_seen
FROM visits v
JOIN animals a ON v.animal_id = a.id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS num_different_animals_seen
FROM visits v
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, COALESCE(s.name, 'No Specialty') AS specialty
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name
FROM visits v
JOIN animals a ON v.animal_id = a.id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?	
SELECT a.name AS most_visited_animal
FROM (
    SELECT animal_id, COUNT(*) AS visit_count
    FROM visits
    GROUP BY animal_id
    ORDER BY visit_count DESC
    LIMIT 1
) AS most_visited
JOIN animals a ON most_visited.animal_id = a.id;



-- Who was Maisy Smith's first visit?
SELECT a.name AS first_visited_animal
FROM visits AS v
JOIN animals AS a ON v.animal_id = a.id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
ORDER BY v.visit_date
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
a.name AS animal_name,
v.name AS vet_name,
vs.visit_date AS date_of_visit
FROM visits AS vs
JOIN animals AS a ON vs.animal_id = a.id
JOIN vets AS v ON vs.vet_id = v.id
WHERE vs.visit_date = (SELECT MAX(visit_date) FROM visits);



-- How many visits were with a vet that did not specialize in that animal's species?
/*SELECT COUNT(*) AS num_visits_without_specialty
FROM visits v
LEFT JOIN specializations sp ON v.vet_id = sp.vet_id AND v.animal_id = sp.species_id
WHERE sp.species_id IS NULL;*/

SELECT COUNT(*) AS num_visits_without_specialty
FROM visits v
WHERE v.vet_id NOT IN (
SELECT DISTINCT vet_id
FROM specializations
WHERE species_id = v.animal_id
);



-- What specialty should Maisy Smith consider getting? Look for the species she visits the most.
SELECT s.name AS potential_specialty FROM (
SELECT a.species_id, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
GROUP BY a.species_id
ORDER BY visit_count DESC
LIMIT 1
) AS most_visited_species
JOIN species s ON most_visited_species.species_id = s.id;

/* Queries for performance audit */
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

/* Improve the performance and Explain analyze */
CREATE INDEX visits_animal_indx ON visits(animal_id);
CREATE INDEX visits_vet_indx ON visits(vet_id);
CREATE INDEX email_indx ON owners(email);