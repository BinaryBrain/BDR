# Base de Données - Labo 3

Simon Baehler et Sacha Bron - 17 novembre 2014

## Exercice 1

--Utiliser un Trigger sur la table payment, pour qu'à chaque insertion, le paiement soit majoré de 8%
--et la date de paiement soit mise à jour à la date courante du serveur.

--CREATE TRIGGER `payment_date` BEFORE INSERT ON `payment`
-- FOR EACH ROW SET NEW.payment_date = NOW()

-- Requête

CREATE TRIGGER `major` 
	BEFORE INSERT 
		ON `payment` 
	FOR EACH ROW 
	BEGIN
		SET new.amount = (new.amount + new.amount * 0.08), new.last_update = CURRENT_TIMESTAMP 
	END
	
-- On insert un amount de 10
INSERT INTO `sakila`.`payment` 
	(`payment_id`, `customer_id`, `staff_id`, `rental_id`, `amount`, `payment_date`, `last_update`)
VALUES 
	(NULL, '1', '1', '1', '10', '2014-12-02 00:00:00', CURRENT_TIMESTAMP);

-- Le resultat de notre dernière insertion est 
"16051","1","1","1","10.80","2014-12-02 00:00:00","2014-12-01 17:23:41"


## Exercice 2

--Créer une nouvelle table "staff_creation_log" avec les attributs "username" et "when_created".
--Créer un Trigger pour insérer une nouvelle ligne dans "staff_creation_log", à chaque fois qu'un tuple
-- est inséré dans la table "staff".


CREATE TABLE customer_store_log (
    username varchar(45),
    when_created TIME)
$$
CREATE TRIGGER before_staff_insert
BEFORE INSERT ON staff
FOR EACH ROW
BEGIN
INSERT INTO staff_creation_log (username, when_created) 
	VALUES (NEW.username,NOW());
END
$$


-- lors de l'insertion d'un nouveau membre du staff nomme Xaaram, nous obtenons
"xaaram","10:10:32"

## Exercice 3

-- Utiliser un Trigger qui permet de mettre à jour l'adresse email d'un membre du personnel de manière 
-- automatique à partir de son prénom et de son nom selon le format "prénom.nom@sakilastaff.com".

CREATE
	TRIGGER email_gen
	BEFORE INSERT ON staff
    FOR EACH ROW
    	SET new.email = CONCAT(new.first_name, ".", new.last_name, "@sakilastaff.com");


## Exercice 4
-- Créer une nouvelle table "customer_store_log" avec les attributs "customer_id", "last_store_id",
-- "register_date" et "unregister_date" dont le but est d'archiver les anciens magasins fréquentés par un
-- client. Le "register_date" représente la date d'inscription d'un client dans un magasin et le
-- "unregister_date" représente la date de sa désinscription. Créer un Trigger pour enregistrer une
-- nouvelle ligne dans la table "customer_store_log", à chaque fois qu'un client change de magasin.

CREATE TABLE customer_store_log (
    customer_id smallint(5),
    last_store_id tinyint(3),
    register_date timestamp,
    unregister_date timestamp);

CREATE TRIGGER `register_log` 
	BEFORE 
UPDATE ON 
	`customer`
FOR EACH ROW BEGIN
    INSERT INTO 
    	customer_store_log 
    VALUES 
    	(new.customer_id, new.store_id, 
    	NOW(), 
    	NULL
    	);
    UPDATE customer_store_log 
    SET unregister_date = now() 
   	WHERE customer_id = customer_id 
   		AND last_store_id = old.store_id ;
	END
	
-- Quand nous changeons le store d'un customer nous obtenon, store 1 étant le nouveau store
"1","2","2014-11-25 10:01:00","2014-12-01 17:31:46"
"1","1","2014-12-01 17:31:46",NULL

## Exercice 5
CREATE EVENT `clean_up` 
	ON SCHEDULE EVERY 1 MINUTE 
	DELETE FROM customer_store_log 
		WHERE (unregister_date < CURRENT_TIMESTAMP - INTERVAL 1 MINUTE) 
		AND(unregister_date IS NOT NULL)
		
-- Apres attente d'une minutre l'ancient enregisterement a été effacé
"1","1","2014-12-01 17:31:46",NULL

## Exercice 6
-- On aimerait envoyer des cartes du Nouvel An à l'adresse postale du personnel. On voudrait déléguer
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

## Exercice 11

CREATE PROCEDURE NBRFILM (IN store_id INT, OUT nbr_Film INT) 
	SELECT 
		COUNT(DISTINCT film_id) INTO nbr_Film
	FROM inventory AS I 
	WHERE I.store_id = store_id

SET @p0='1'; CALL `NBRFILM`(@p0, @p1); SELECT @p1 AS `nbr_Film`;
"nbr_Film" , "759"

SET @p0='2'; CALL `NBRFILM`(@p0, @p1); SELECT @p1 AS `nbr_Film`;
"nbr_Film" , "762"

SELECT 
	COUNT(DISTINCT film_id)
FROM inventory AS I 
	WHERE I.store_id = 1
"COUNT(DISTINCT film_id)" , "759"
SELECT 
	COUNT(DISTINCT film_id)
FROM inventory AS I 
	WHERE I.store_id = 2
"COUNT(DISTINCT film_id)" , "762"

CREATE PROCEDURE NBRFILM (IN store_id INT, OUT nbr_Client INT) 
	SELECT 
		COUNT(DISTINCT customer_id) INTO nbr_Client
	FROM customer AS C 
	WHERE C.store_id = store_id

## Exercice 12

CREATE PROCEDURE `NBRCLIENT`(IN store_id INT, OUT nbr_Client INT)
SELECT 
		COUNT(DISTINCT customer_id) INTO nbr_Client
	FROM customer AS C 
	WHERE C.store_id = store_id

SET @p0='1'; CALL `NBRCLIENT`(@p0, @p1); SELECT @p1 AS `nbr_Client`;
"nbr_C" ,"326"
SET @p0='2'; CALL `NBRCLIENT`(@p0, @p1); SELECT @p1 AS `nbr_Client`;
"nbr_C" ,"274"


SELECT 
	COUNT(DISTINCT customer_id)
FROM customer AS C 
WHERE C.store_id = 1
"COUNT(DISTINCT customer_id)" ,"326"

SELECT 
	COUNT(DISTINCT customer_id)
FROM customer AS C 
WHERE C.store_id = 1
"COUNT(DISTINCT customer_id)" ,"274"



## Exercice 13

CREATE PROCEDURE `REVENU`(IN store_id INT, OUT revenu DOUBLE)
SELECT 
		SUM(amount) INTO revenu
	FROM payment AS P
	INNER JOIN rental AS R
		ON R.rental_id = P.rental_id
	INNER JOIN inventory AS I
		ON I.inventory_id = R.inventory_id 
	WHERE I.store_id = store_id

SET @p0='1'; CALL `REVENU`(@p0, @p1); SELECT @p1 AS `revenu`;
"revenu" ,"33680.87"


SET @p0='2'; CALL `REVENU`(@p0, @p1); SELECT @p1 AS `revenu`;
"revenu" ,"33726.77"

SELECT 
	SUM(amount) 
FROM payment AS P
INNER JOIN rental AS R
	ON R.rental_id = P.rental_id
INNER JOIN inventory AS I
	ON I.inventory_id = R.inventory_id 
WHERE I.store_id = 1
"SUM(amount)", "33680.87"

SELECT 
	SUM(amount) 
FROM payment AS P
INNER JOIN rental AS R
	ON R.rental_id = P.rental_id
INNER JOIN inventory AS I
	ON I.inventory_id = R.inventory_id 
WHERE I.store_id = 2
"SUM(amount)", "33726.77"



## Exercice 14
CREATE PROCEDURE `MAJFILM`()
UPDATE `sakila`.`film` SET `last_update` = NOW()

CALL `MAJFILM`();