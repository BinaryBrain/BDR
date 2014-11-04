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