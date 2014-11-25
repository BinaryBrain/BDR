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



## Exercice 4
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

## Exercice 5
CREATE EVENT `clean_up` 
	ON SCHEDULE EVERY 1 MINUTE 
	DELETE FROM customer_store_log 
		WHERE (unregister_date < CURRENT_TIMESTAMP - INTERVAL 1 MINUTE) 
		AND(unregister_date IS NOT NULL)

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