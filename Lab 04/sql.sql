-- 3) Utiliser un Trigger qui permet de mettre à jour l'adresse email d'un membre du personnel de manière automatique à partir de son prénom et de son nom selon le format "prénom.nom@sakilastaff.com".

CREATE
	TRIGGER email_gen
	BEFORE INSERT ON staff
    FOR EACH ROW
    	SET new.email = CONCAT(new.first_name, ".", new.last_name, "@sakilastaff.com");

-- 6) On aimerait envoyer des cartes du Nouvel An à l'adresse postale du personnel. On voudrait déléguer
-- cette tâche à un employé, Franklin, mais pour des questions de protection des données personnelles,
-- on voudrait donner accès à Franklin seulement aux numéros de téléphone des membres du personnel
-- et de leurs adresses postales, mais pas leurs adresses e-mail (ou, d'ailleurs, les mots de passe). Créer
-- une vue sur la table du personnel qui permettra à Franklin de réaliser la tâche demandée.
-- Est-ce que Franklin pourra mettre à jour la base de donnée à travers cette vue?

CREATE VIEW nouvel_an AS
SELECT
	c.first_name,
	c.last_name,
	a.phone,
	a.address,
	a.address2,
	a.district,
	a.postal_code,
	city.city,
	co.country
FROM
	customer c
JOIN address a ON a.address_id = c.address_id
JOIN city ON city.city_id = a.city_id
JOIN country co ON co.country_id = city.country_id

