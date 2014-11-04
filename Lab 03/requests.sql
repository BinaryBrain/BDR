-- 10) Donner le titre des films (titre) et le nombre d'acteurs (nombre_acteurs) des films de musique, en les triant par nombre d'acteur décroissant.

SELECT
	f.title AS titre,
	COUNT(fa.film_id) AS nombre_acteurs
FROM
	film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Music'
GROUP BY f.film_id
ORDER BY nombre_acteurs DESC

-- 11) Même question, mais la requête ne doit retourner que les films qui utilisent plus de 7 acteurs.

SELECT
	f.title AS titre,
	COUNT(fa.film_id) AS nombre_acteurs
FROM
	film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Music'
GROUP BY f.film_id
HAVING nombre_acteurs >= 7
ORDER BY nombre_acteurs DESC

-- 12) Lister les catégories (id, nom, nombre de films associés) de films associées à plus de 60 films, sans utiliser de sous requête. Ordonner les résultats par nom de catégorie.

SELECT
	c.category_id AS id,
	c.name AS nom,
    COUNT(fc.film_id) AS nombre_films
FROM
	category c
JOIN film_category fc ON fc.category_id = c.category_id
GROUP BY c.name
HAVING nombre_films >= 60
ORDER BY c.name

-- 13) Afficher le film (ou les films si plusieurs films ont la même durée minimum) le plus court (id_min, titre_min, duree_min).

SELECT
	f.film_id AS id_min,
	f.title AS titre_min,
	f.length AS duree_min
FROM film f
WHERE f.length = (
	SELECT
		MIN(f.length)
	FROM film f
)

-- 14) Lister les acteurs (actor_id, nombre_films) qui ont joué dans plus de 35 films, sans utiliser de sous-requêtes.

SELECT
	a.actor_id AS actor_id,
	COUNT(fa.film_id) AS nombre_films
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id 
GROUP BY a.actor_id
HAVING nombre_films >= 35

-- 15) Lister les films (id, titre) dont l’identifiant est inférieur à 100, ordonnés par id dans lesquels joue au moins un acteur qui a joué dans plus de 35 films. Utiliser le mot clé IN.

SELECT
	f.film_id AS id,
	f.title AS titre
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE f.film_id <= 100
	AND a.actor_id IN (
		SELECT
			a.actor_id AS actor_id
		FROM actor a
		JOIN film_actor fa ON fa.actor_id = a.actor_id 
		GROUP BY a.actor_id
		HAVING COUNT(fa.film_id) >= 35
	)
ORDER BY f.film_id

-- 16) Même question, mais sans utiliser le mot clé IN. Indication : une sous-requête peut être utilisée comme un table, et donc être jointe.
-- Quelle requête est la plus rapide (celle-ci ou la précédente)? A votre avis, pourquoi?

SELECT
	f.film_id AS id,
	f.title AS titre
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN (
		SELECT
			a.actor_id AS actor_id
		FROM actor a
		JOIN film_actor fa ON fa.actor_id = a.actor_id 
		GROUP BY a.actor_id
		HAVING COUNT(fa.film_id) >= 35
	) a ON a.actor_id = fa.actor_id
WHERE f.film_id <= 100
ORDER BY f.film_id

-- La requête la plus rapide sera celle-ci (la n°16). En effet, le DBMS n'aura pas besoin de charger 2 fois la table `actor` et de chercher si chaque actor est présent dans la table `actor` réduite. Toutes ces comparaisons permettent de gagner du temps.

-- 17) Un fou décide de regarder l'ensemble des films qui sont présents dans la base de données. Etablir une requête qui donne le nombre de jours (jours) qu'il devra y consacrer, s'il dispose de 16h par jour.

SELECT
	SUM(f.length)/60/16 AS jours
FROM film f
