# Base de Données - Labo 3

Simon Baehler et Sacha Bron - 17 novembre 2014

## Exercice 1

Utiliser un Trigger sur la table payment, pour qu'à chaque insertion, le paiement soit majoré de 8% et la date de paiement soit mise à jour à la date courante du serveur.

--CREATE TRIGGER `payment_date` BEFORE INSERT ON `payment`
-- FOR EACH ROW SET NEW.payment_date = NOW()

### Requête

```
CREATE TRIGGER `major` 
	BEFORE INSERT 
		ON `payment` 
	FOR EACH ROW 
	BEGIN
		SET new.amount = (new.amount + new.amount * 0.08), new.last_update = CURRENT_TIMESTAMP 
	END
```

On insert un amount de 10.

```
INSERT INTO `sakila`.`payment` 
	(`payment_id`, `customer_id`, `staff_id`, `rental_id`, `amount`, `payment_date`, `last_update`)
VALUES 
	(NULL, '1', '1', '1', '10', '2014-12-02 00:00:00', CURRENT_TIMESTAMP);
```

### Résultat

payment_id | customer_id | staff_id | rental_id | amount | payment_date | last_update
------|---|----|---|------|---------------------|-------------------------------------
16051 | 1 | 1 | 1 | 10.80 | 2014-12-02 00:00:00 | 2014-12-01 17:23:41

## Exercice 2

Créer une nouvelle table `staff_creation_log` avec les attributs `username` et `when_created`.  
Créer un Trigger pour insérer une nouvelle ligne dans "staff_creation_log", à chaque fois qu'un tuple est inséré dans la table `staff`.

### Requête

```
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
```

### Résultat

Lors de l'insertion d'un nouveau membre du staff nomme Xaaram, nous obtenons:

username | when_created
-------|-----------------
xaaram | 10:10:32


## Exercice 4

Créer une nouvelle table `customer_store_log` avec les attributs `customer_id`, `last_store_id`, `register_date` et `unregister_date` dont le but est d'archiver les anciens magasins fréquentés par un client. Le `register_date` représente la date d'inscription d'un client dans un magasin et le `unregister_date` représente la date de sa désinscription. Créer un Trigger pour enregistrer une nouvelle ligne dans la table `customer_store_log`, à chaque fois qu'un client change de magasin. 

### Requête

```
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
```

### Résultat

Quand nous changeons le store d'un customer nous obtenon, store 1 étant le nouveau store

--|---|---------------------|------------------------
1 | 2 | 2014-11-25 10:01:00 | 2014-12-01 17:31:46
1 | 1 | 2014-12-01 17:31:46 | NULL

## Exercice 5

Créer un événement qui permet de nettoyer une fois par minute (pour pouvoir le tester !) la table `customer_store_log` pour éliminer de cette table les enregistrements des clients qui ont changé au moins deux fois de magasin et dont leur plus récent changement date de plus d'une année. 

### Requête

```
CREATE EVENT `clean_up` 
	ON SCHEDULE EVERY 1 MINUTE 
	DELETE FROM customer_store_log 
		WHERE (unregister_date < CURRENT_TIMESTAMP - INTERVAL 1 MINUTE) 
		AND(unregister_date IS NOT NULL)
```

### Résultat

Apres attente d'une minutre l'ancient enregisterement a été effacé

1 | 1 | 2014-12-01 17:31:46 | NULL

## Exercice 6

On aimerait envoyer des cartes du Nouvel An à l'adresse postale du personnel. On voudrait déléguer cette tâche à un employé, Franklin, mais pour des questions de protection des données personnelles, on voudrait donner accès à Franklin seulement aux numéros de téléphone des membres du personnel et de leurs adresses postales, mais pas leurs adresses e-mail (ou, d'ailleurs, les mots de passe). Créer une vue sur la table du personnel qui permettra à Franklin de réaliser la tâche demandée.

### Requête

```
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
```

### Résultats (total: 183)

first_name | last_name | phone | address | address2 | district | postal_code | city | country
-----|-------|--------------|------------------------|--|-------|-------|-------|------------------
VERA | MCCOY | 886649065861 | 1168 Najafabad Parkway |  | Kabol | 40301 | Kabul | Afghanistan
MARIO | CHEATHAM | 406784385440 | 1924 Shimonoseki Drive |  | Batna | 52625 | Batna | Algeria
JUDY | GRAY | 107137400143 | 1031 Daugavpils Parkway |  | Bchar | 59025 | Bchar | Algeria
JUNE | CARROLL | 506134035434 | 757 Rustenburg Avenue |  | Skikda | 89668 | Skikda | Algeria
ANTHONY | SCHWAB | 478229987054 | 1892 Nabereznyje Telny Lane |  | Tutuila | 28396 | Tafuna | American Samoa
CLAUDE | HERZOG | 105882218332 | 486 Ondo Parkway |  | Benguela | 35202 | Benguela | Angola
MARTIN | BALES | 106439158941 | 368 Hunuco Boulevard |  | Namibe | 17165 | Namibe | Angola
BOBBY | BOUDREAU | 934352415130 | 1368 Maracabo Boulevard |  |  | 32716 | South Hill | Anguilla
WILLIE | MARKHAM | 296394569728 | 1623 Kingstown Drive |  | Buenos Aires | 91299 | Almirante Brown | Argentina
JORDAN | ARCHULETA | 817740355461 | 1229 Varanasi (Benares) Manor |  | Buenos Aires | 40195 | Avellaneda | Argentina
JASON | MORRISSEY | 972574862516 | 1427 A Corua (La Corua) Place |  | Buenos Aires | 85799 | Baha Blanca | Argentina
KIMBERLY | LEE | 934730187245 | 96 Tafuna Way |  | Crdoba | 99865 | Crdoba | Argentina
MICHEAL | FORMAN | 411549550611 | 203 Tambaram Street |  | Buenos Aires | 73942 | Escobar | Argentina
DARRYL | ASHCRAFT | 717566026669 | 166 Jinchang Street |  | Buenos Aires | 86760 | Ezeiza | Argentina
JULIA | FLORES | 846225459260 | 1926 El Alto Avenue |  | Buenos Aires | 75543 | La Plata | Argentina
FLORENCE | WOODS | 330838016880 | 1532 Dzerzinsk Way |  | Buenos Aires | 9599 | Merlo | Argentina
PERRY | SWAFFORD | 914466027044 | 773 Dallas Manor |  | Buenos Aires | 12664 | Quilmes | Argentina
LYDIA | BURKE | 686015532180 | 1483 Pathankot Street |  | Tucumn | 37288 | San Miguel de Tucumn | Argentina
ERIC | ROBERT | 105470691550 | 430 Kumbakonam Drive |  | Santa F | 28814 | Santa F | Argentina
LEONARD | SCHOFIELD | 779461480495 | 88 Nagaon Manor |  | Buenos Aires | 86868 | Tandil | Argentina

### Question

Est-ce que Franklin pourra mettre à jour la base de donnée à travers cette vue? 

### Réponse

Non, car il n'existe pas de relation une-à-une entre la vue et les tables.

## Exercice 7

On aimerait demander à Franklin d'envoyer un rappel par email à tous les clients qui ont du retard. Définir la vue qu'il a besoin pour effectuer cette tache. L'email envoyé à chaque client doit contenir le titre du film qu'ils n'ont pas rendu, ainsi que le nombre de jours de leur retard.

### Requête

```
CREATE VIEW send_mail_late AS
SELECT
	c.email,
	f.title,
	DATEDIFF(CURDATE(), r.rental_date) AS days
FROM
	customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id

WHERE r.return_date IS NULL
```

### Résultats (total: 183)

email | title | days
---------------------------------|------------------|-------
DWAYNE.OLVERA@sakilacustomer.org | ACADEMY DINOSAUR | 3389
BRANDON.HUEY@sakilacustomer.org | ACE GOLDFINGER | 3212
CARMEN.OWENS@sakilacustomer.org | AFFAIR PREJUDICE | 3212
SETH.HANNON@sakilacustomer.org | AFRICAN EGG | 3212
TRACY.COLE@sakilacustomer.org | ALI FOREVER | 3212
MARCIA.DEAN@sakilacustomer.org | ALONE TRIP | 3212
CECIL.VINES@sakilacustomer.org | AMADEUS HOLY | 3212
MARIE.TURNER@sakilacustomer.org | AMERICAN CIRCUS | 3212
JOE.GILLILAND@sakilacustomer.org | AMISTAD MIDSUMMER | 3212
EDWARD.BAUGH@sakilacustomer.org | ARMAGEDDON LOST | 3212
BETH.FRANKLIN@sakilacustomer.org | BAKED CLEOPATRA | 3212
GINA.WILLIAMSON@sakilacustomer.org | BANG KWAI | 3212
MELVIN.ELLINGTON@sakilacustomer.org | BASIC EASY | 3212
SONIA.GREGORY@sakilacustomer.org | BERETS AGENT | 3212
FLORENCE.WOODS@sakilacustomer.org | BLADE POLISH | 3212
TYLER.WREN@sakilacustomer.org | BLANKET BEVERLY | 3212
MILDRED.BAILEY@sakilacustomer.org | BOOGIE AMELIE | 3212
ANNA.HILL@sakilacustomer.org | BOULEVARD MOB | 3212
ROBIN.HAYES@sakilacustomer.org | BOUND CHEAPER | 3212
LOIS.BUTLER@sakilacustomer.org | BUBBLE GROSSE | 3212


## Exercice 8

Utiliser la vue créée au point 7 pour afficher le nombre de clients ayant plus de trois jours de retard.

### Requête

```
SELECT
	COUNT(*) AS clients
FROM send_mail_late s
WHERE s.days > 3
```

### Résultats (total: 599)

183

## Exercice 9

On aimerait demander à Franklin de calculer le nombre de location par client. Définir la vue qu'il a besoin pour effectuer cette tache. Donner la requête pour afficher les 20 premiers clients avec plus de location en utilisant la vue définie.

### Requête

```
CREATE VIEW n_rental_per_customer AS
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	COUNT(r.rental_id) AS rental
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
```

### Résultats (total: 599)

customer_id | first_name | last_name | rental
----|--------|---------|---------
1 | MARY | SMITH | 32
2 | PATRICIA | JOHNSON | 27
3 | LINDA | WILLIAMS | 26
4 | BARBARA | JONES | 22
5 | ELIZABETH | BROWN | 38
6 | JENNIFER | DAVIS | 28
7 | MARIA | MILLER | 33
8 | SUSAN | WILSON | 24
9 | MARGARET | MOORE | 23
10 | DOROTHY | TAYLOR | 25
11 | LISA | ANDERSON | 24
12 | NANCY | THOMAS | 28
13 | KAREN | JACKSON | 27
14 | BETTY | WHITE | 28
15 | HELEN | HARRIS | 32
16 | SANDRA | MARTIN | 28
17 | DONNA | THOMPSON | 21
18 | CAROL | GARCIA | 22
19 | RUTH | MARTINEZ | 24
20 | SHARON | ROBINSON | 30


```
SELECT
	*
FROM n_rental_per_customer
ORDER BY rental DESC
LIMIT 20
```

### Résultats (total: 20)

customer_id | first_name | last_name | rental
----|--------|---------|---------
148 | ELEANOR | HUNT | 46
526 | KARL | SEAL | 45
144 | CLARA | SHAW | 42
236 | MARCIA | DEAN | 42
75 | TAMMY | SANDERS | 41
197 | SUE | PETERS | 40
469 | WESLEY | BULL | 40
178 | MARION | SNYDER | 39
137 | RHONDA | KENNEDY | 39
468 | TIM | CARY | 39
5 | ELIZABETH | BROWN | 38
410 | CURTIS | IRBY | 38
459 | TOMMY | COLLAZO | 38
295 | DAISY | BATES | 38
198 | ELSIE | KELLEY | 37
366 | BRANDON | HUEY | 37
257 | MARSHA | DOUGLAS | 37
176 | JUNE | CARROLL | 37
380 | RUSSELL | BRINSON | 36
354 | JUSTIN | NGO | 36



## Exercice 10

Créer une vue pour calculer le nombre total de location par jour.  
Combien de locations sont effectués en 1er août 2005? Donner la requête SQL.

### Requête

```
CREATE VIEW rental_per_day AS
SELECT
	DATE(r.rental_date) AS date,
	COUNT(*) AS locations
FROM rental r
GROUP BY DATE(r.rental_date)

SELECT
	*
FROM rental_per_day
WHERE date = DATE("2005-08-01")
```

### Résultats (total: 1)

date       | locations
-----------|-----------
2005-08-01 | 671


## Exercice 11

Créer une fonction qui calcule le nombre de films proposés par le magasin. La fonction prend en entrée l'ID de magasin et retourne en sortie le nombre de films proposés par le magasin. Utiliser la fonction pour afficher le nombre de films proposés par magasin 1 et 2. Confirmer la réponse avec une requête SQL.

### Requête

```
CREATE PROCEDURE NBRFILM (IN store_id INT, OUT nbr_Film INT) 
	SELECT 
		COUNT(DISTINCT film_id) INTO nbr_Film
	FROM inventory AS I 
	WHERE I.store_id = store_id

SET @p0='1'; CALL `NBRFILM`(@p0, @p1); SELECT @p1 AS `nbr_Film`;
"nbr_Film" , "759"

SET @p0='2'; CALL `NBRFILM`(@p0, @p1); SELECT @p1 AS `nbr_Film`;
"nbr_Film" , "762"
```

```
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
```

```
CREATE PROCEDURE NBRFILM (IN store_id INT, OUT nbr_Client INT) 
	SELECT 
		COUNT(DISTINCT customer_id) INTO nbr_Client
	FROM customer AS C 
	WHERE C.store_id = store_id
```

## Exercice 12

Créer une fonction qui calcule le nombre de clients par le magasin. La fonction prend en entrée un ID de magasin et retourne en sortie le nombre de clients par le magasin. Utiliser la fonction pour afficher le nombre de clients par magasin 1 et 2. Confirmer la réponse avec une requête SQL.

```
CREATE PROCEDURE `NBRCLIENT`(IN store_id INT, OUT nbr_Client INT)
SELECT 
		COUNT(DISTINCT customer_id) INTO nbr_Client
	FROM customer AS C 
	WHERE C.store_id = store_id

SET @p0='1'; CALL `NBRCLIENT`(@p0, @p1); SELECT @p1 AS `nbr_Client`;
"nbr_C" ,"326"
SET @p0='2'; CALL `NBRCLIENT`(@p0, @p1); SELECT @p1 AS `nbr_Client`;
"nbr_C" ,"274"
```


```
SELECT 
	COUNT(DISTINCT customer_id)
FROM customer AS C 
WHERE C.store_id = 1
"COUNT(DISTINCT customer_id)" ,"326"
```

```
SELECT 
	COUNT(DISTINCT customer_id)
FROM customer AS C 
WHERE C.store_id = 1
"COUNT(DISTINCT customer_id)" ,"274"
```

## Exercice 13

Créer une fonction qui calcule le revenu de chaque magasin. La fonction prend en entrée l'ID de magasin et retourne en sortie le revenu total du magasin. Utiliser la fonction pour afficher le revenu de magasin 1 et 2. Confirmer la réponse avec une requête SQL.

```
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
```

```
SELECT 
	SUM(amount) 
FROM payment AS P
INNER JOIN rental AS R
	ON R.rental_id = P.rental_id
INNER JOIN inventory AS I
	ON I.inventory_id = R.inventory_id 
WHERE I.store_id = 1
"SUM(amount)", "33680.87"
```

```
SELECT
	SUM(amount)
FROM payment AS P
INNER JOIN rental AS R
	ON R.rental_id = P.rental_id
INNER JOIN inventory AS I
	ON I.inventory_id = R.inventory_id 
WHERE I.store_id = 2
"SUM(amount)", "33726.77"
```

## Exercice 14

Créer une procédure pour mettre à jour la date de la mis à jour de tous les films à la date d'exécution de la procédure. Quelle est la date de la mis à jour des films avant et après cette procédure?

```
CREATE PROCEDURE `MAJFILM`()
UPDATE `sakila`.`film` SET `last_update` = NOW()

CALL `MAJFILM`();
```

### Exercice 15

Créer une procédure qui calcule le nombre d'exemplaires physiques des films ainsi que le nombre de locations dans chaque magasin. Utiliser la procédure pour afficher le résultat de magasin 1 et 2.
e magasin. La fonction prend en entrée l'ID de magasin et retourne en sortie le revenu total du magasin. Utiliser la fonction pour afficher le revenu de magasin 1 et 2. Confirmer la réponse avec une requête SQL.

```
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
```

```
SELECT 
	SUM(amount) 
FROM payment AS P
INNER JOIN rental AS R
	ON R.rental_id = P.rental_id
INNER JOIN inventory AS I
	ON I.inventory_id = R.inventory_id 
WHERE I.store_id = 1
"SUM(amount)", "33680.87"
```

```
SELECT 
	SUM(amount) 
FROM payment AS P
INNER JOIN rental AS R
	ON R.rental_id = P.rental_id
INNER JOIN inventory AS I
	ON I.inventory_id = R.inventory_id 
WHERE I.store_id = 2
"SUM(amount)", "33726.77"
```

## Exercice 14

Créer une procédure pour mettre à jour la date de la mis à jour de tous les films à la date d'exécution de la procédure. Quelle est la date de la mis à jour des films avant et après cette procédure?

```
CREATE PROCEDURE `MAJFILM`()
UPDATE `sakila`.`film` SET `last_update` = NOW()
```

```
CALL `MAJFILM`();
```

### Exercice 15

Créer une procédure qui calcule le nombre d'exemplaires physiques des films ainsi que le nombre de locations dans chaque magasin. Utiliser la procédure pour afficher le résultat de magasin 1 et 2.

### Requête

```
CREATE PROCEDURE `STOCK`()
SELECT
	s.store_id,
	COUNT(f.film_id) AS n_film,
	COUNT(r.rental_id) AS n_rental
FROM store s
JOIN inventory i ON i.store_id = s.store_id
JOIN film f ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY s.store_id
```

```
CALL `STOCK`();
```
