-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
SELECT f."title",
	f."rating"
FROM film f
WHERE f."rating" = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.

SELECT 
	CONCAT(a."first_name", ' ', a."last_name") AS "full_name",
	a."actor_id"
FROM actor a
WHERE a.actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.


SELECT f."title",
	f."original_language_id",
	f."language_id"
FROM film f
WHERE f."original_language_id" = f."language_id";

SELECT *
FROM "language" l ;

SELECT DISTINCT f."original_language_id"
FROM film f;
/*
 No he podido encontrar las películas cuyo idioma coincide con el idioma original 
ya que el valor de los idiomas originales de todas las películas es NULL
*/

-- 5. Ordena las películas por duración de forma ascendente.


SELECT f."title",
	f."length"
FROM film f
ORDER BY f."length";


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.


SELECT CONCAT(a."first_name", ' ', a."last_name")
FROM actor a
WHERE a."last_name" ILIKE '%allen%';


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento

SELECT f."rating" AS "clasificación",
COUNT(f."rating") AS "recuento"
FROM film f
GROUP BY f."rating"
ORDER BY COUNT(f."rating");


-- 8. Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.

SELECT *
FROM film f
WHERE f."rating" = 'PG-13' OR f."length" > 180;

/* Asumiendo que el valor de length es en minutos */

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT MIN(f."replacement_cost") AS "mínimo",
	MAX(f."replacement_cost") AS "máximo"
FROM film f;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT 
	MIN(f."length") AS "duración_mínima",
	MAX(f."length") AS "duración_máxima"
FROM film f;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT 
	p."amount",
	p."payment_date"
FROM payment p 
ORDER BY p.payment_date desc
LIMIT 3;


-- 12. Encuentra el título de las películas de la tabla "film" que no sean ni 'NC-17' ni 'G' en cuanto a su clasificación.

SELECT f."title",
	f."rating"
FROM "film" f
WHERE f."rating" <> 'NC-17'
	AND f."rating" <> 'G';

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT 
	f."rating" AS rating,
	ROUND(AVG(f."length"), 2) AS "average_length"
FROM "film" f
GROUP BY f."rating";

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT
	f."title" AS "title",
	f."length" AS "film_length (min)"
FROM film f
WHERE f."length" > 180
ORDER BY f."length";

-- 15. ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(p."amount")
FROM payment p;

-- 16. Muestra los 10 clientes con mayor valor de id.

SELECT 
	CONCAT(c."first_name", ' ', c."last_name") AS "customer_name",
	c."customer_id"
FROM customer c
ORDER BY c."customer_id" DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.

SELECT CONCAT(a."first_name", ' ', a."last_name") AS "full_name",
	f."title"
FROM "actor" a
LEFT JOIN film_actor fa
ON a."actor_id" = fa."actor_id"
LEFT JOIN film f
ON fa."film_id" = f."film_id"
WHERE f."title" = 'EGG IGBY';

-- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT(f."title") AS "unique_titles"
FROM film f;


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.

SELECT f."title",
	c."name" AS "category",
	f."length"
FROM "film" f
LEFT JOIN "film_category" fc
ON f."film_id" = fc."film_id"
LEFT JOIN "category" c
ON fc."category_id" = c."category_id"
WHERE c."name" = 'Comedy'
	AND f."length" > 180;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT
	c."name" AS "category",
	ROUND(AVG(f."length"), 2) AS "avg_length"
FROM "film" f
LEFT JOIN "film_category" fc
ON f."film_id" = fc."film_id"
LEFT JOIN "category" c
ON fc."category_id" = c."category_id"
WHERE f."length" > 110
GROUP BY c."name"
ORDER BY c."name";

-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT ROUND(AVG(EXTRACT (DAY FROM r."return_date" - r."rental_date")),2) AS "average_days"
FROM  "rental" r;

-- 22. Crea una columna con el nombre y apellido de todos los actores y actrices.

SELECT 
	CONCAT(a."first_name", ' ', a."last_name") AS "complete_name"
FROM actor a
ORDER BY CONCAT(a."first_name", ' ', a."last_name");
	
--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT 
	COUNT(r."rental_id") AS "number_rentals",
	EXTRACT(DAY FROM r."rental_date") AS "day",
	EXTRACT(MONTH FROM r."rental_date") AS "month"
FROM rental r
GROUP BY EXTRACT(MONTH FROM r."rental_date"),
	EXTRACT(DAY FROM r."rental_date")
ORDER BY COUNT(r."rental_id") DESC;


-- 24. Encuentra las películas con una duración superior al promedio.

WITH "avg_length" AS (
	SELECT AVG(f."length") AS "average_length"
	FROM "film" f
)
SELECT f."title",
	f."length"
FROM "film" f
CROSS JOIN "avg_length" 
WHERE f."length" > avg_length."average_length";

-- 25. Averigua el número de alquileres registrados por mes.

SELECT
	EXTRACT(YEAR FROM r."rental_date") AS "year",
	EXTRACT(MONTH FROM r."rental_date") AS "month",
	COUNT(r."rental_id") AS "rentals_per_month"
FROM "rental" r
GROUP BY
	EXTRACT(YEAR FROM r."rental_date"),
	EXTRACT(MONTH FROM r."rental_date")
ORDER BY
	EXTRACT(YEAR FROM r."rental_date"),
	EXTRACT(MONTH FROM r."rental_date");

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT
	ROUND(AVG(p."amount"), 2) AS "average",
	ROUND(STDDEV(p."amount"), 2) AS "standard_deviation",
	ROUND(VARIANCE(p."amount"), 2) AS "variance"
FROM "payment" p;

-- 27. ¿Qué películas se alquilan por encima del precio medio?

WITH "average_price" AS (
	SELECT AVG(p."amount") AS "average_price"
	FROM "payment" p
)
SELECT 	f."title",
	p."amount" AS "price"
FROM "film" f
INNER JOIN "inventory" i
ON f."film_id" = i."film_id"
INNER JOIN "rental" r
ON i."inventory_id" = r."inventory_id"
INNER JOIN "payment" p
ON r."rental_id" = p."rental_id"
CROSS JOIN "average_price"
WHERE p."amount" > average_price."average_price";

-- 28.  Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT
	fa."actor_id",
	COUNT(f."title") AS "number_movies"
FROM "film_actor" fa
INNER JOIN "film" f
	ON fa."film_id" = f."film_id"
GROUP BY fa."actor_id"
HAVING COUNT(f."title") > 40
ORDER BY fa."actor_id";

-- 29. Mostrar todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.



-- 30. Obtener los actores y el número de películas en las que ha actuado.

SELECT 
	CONCAT(a."first_name", ' ', a."last_name") AS "full_name",
	COUNT(f."title") AS "number_of_movies"
FROM "actor" a
INNER JOIN "film_actor" fa
ON 
	a."actor_id" = fa."actor_id"
INNER JOIN "film" f
ON 
	fa."film_id" = f."film_id"
GROUP BY 
	a."actor_id"
ORDER BY 
	COUNT(f."title") DESC;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.


SELECT 
	f."title",	
	CONCAT(a."first_name", ' ', a."last_name") AS "full_name"
FROM "film" f
LEFT JOIN "film_actor" fa
ON 
	f."film_id" = fa."film_id"
LEFT JOIN "actor" a
ON 
	fa."actor_id" = a."actor_id"
GROUP BY 
	f."title",
	CONCAT(a."first_name", ' ', a."last_name")
ORDER BY
	f."title";


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.



-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f."title",
	COUNT(r."rental_id") AS "number_of_rentals"
FROM "film" f
LEFT JOIN "inventory" i
ON 
	f."film_id" = i."film_id"
LEFT JOIN "rental" r
ON 
	i."inventory_id" = r."inventory_id"
GROUP BY
	f."title";

SELECT
	f."title",
	r."rental_id",
	r."rental_date",
	r."customer_id",
	r."return_date",
	r."staff_id",
	r."last_update"
FROM "film" f
LEFT JOIN "inventory" i
ON 
	f."film_id" = i."film_id"
LEFT JOIN "rental" r
ON 
	i."inventory_id" = r."inventory_id";
/*
No estoy seguro si lo que se me pide es el número de registros de alquiler de cada película (primera query) o toda la información de alquiler
relacionada con cada película (segunda query) por lo que he incluido las dos.
 */

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT 
	CONCAT(c."first_name" , ' ', c."last_name") AS "customer_name",
	SUM(p."amount") AS "amount_spent"
FROM "customer" c
INNER JOIN "rental" r
ON
	c."customer_id" = r."customer_id"
INNER JOIN "payment" p
ON 
	r."rental_id" = p."rental_id"
GROUP BY
	c."customer_id"
ORDER BY 
	SUM(p."amount") DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT *
FROM "actor" a
WHERE a."first_name" = 'JOHNNY';

-- 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.

SELECT 
	a."first_name" AS "Nombre",
	a."last_name" AS "Apellido"
FROM "actor" a;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT
	MIN(a."actor_id") AS "lowest_id",
	MAX(a."actor_id") AS "highest_id"
FROM "actor" a;

-- 38. Cuenta cuántos actores hay en la tabla “actorˮ.

SELECT
	COUNT(DISTINCT a."actor_id") AS "number_actors"
FROM "actor" a;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT *
FROM "actor" a
ORDER BY
	a."last_name";
	
-- 40.Selecciona las primeras 5 películas de la tabla “filmˮ.

SELECT f."title"
FROM "film" f
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT 
	a."first_name",
	COUNT(a."first_name") AS "times_repeated"
FROM "actor" a
GROUP BY
	a."first_name"
ORDER BY COUNT(a."first_name") DESC;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT 
	CONCAT(c."first_name", ' ', c."last_name") AS "customer",
	f."title"AS "movie",
	r."rental_date",
	r."return_date",
	r."last_update"
FROM "customer" c
LEFT JOIN "rental" r
ON 
	c."customer_id" = r."customer_id"
LEFT JOIN "inventory" i
ON 
	r."inventory_id" = i."inventory_id"
LEFT JOIN "film" f
ON 
	i."film_id" = f."film_id"
ORDER BY 
	r."rental_date";

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT 
	CONCAT(c."first_name", ' ', "last_name") AS "customer",
	c."customer_id",
	f."title",
	r."rental_date",
	r."return_date"
FROM "customer" c
LEFT JOIN "rental" r
ON 
	c."customer_id" = r."customer_id"
LEFT JOIN "inventory" i
ON 
	r."inventory_id" = i."inventory_id"
LEFT JOIN "film" f
ON 
	i."film_id" = f."film_id"
ORDER BY 
	c."customer_id";

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT *
FROM "film" f
CROSS JOIN "category" c;

/* 
 No tiene mucho sentido llevar a cavbo un CROSS JOIN entre estas dos tablas ya que se están relacionando películas con categorías que no se 
corresponden la una con la otra. Por ello el resultado que obtenemos no es real y puede llevar a confusión.
*/

-- 45. Encuentra los actores que han participado en películas de la categoría 'action'.

SELECT DISTINCT
	CONCAT(a."first_name", ' ', a."last_name") AS "actor",
	c."name" AS "category"
FROM "actor" a
INNER JOIN "film_actor" fa
ON 
	a."actor_id" = fa."actor_id"
INNER JOIN "film" f
ON 
	fa."film_id" = f."film_id"
INNER JOIN "film_category" fc
ON 
	f."film_id" = fc."film_id"
INNER JOIN category c
ON 
	fc."category_id" = c."category_id"
WHERE c."name" = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.

SELECT DISTINCT 
	CONCAT(a."first_name", ' ', a."last_name") AS "actor"
FROM actor a 
LEFT JOIN film_actor fa
ON
	a."actor_id" = fa."actor_id"
LEFT JOIN "film" f
ON 
	fa."film_id" = f."film_id"
WHERE f."title" IS NULL;

/* 
Dado los resultados de esta query podemos concluir que todos nuestros actores han participado en al menos una película 
en su carrera profesional
*/

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT  
	CONCAT(a."first_name", ' ', a."last_name") AS "actor",
	count(f."film_id") AS "number_movies"
FROM "actor" a
LEFT JOIN "film_actor" fa
ON
	a."actor_id" = fa."actor_id"
LEFT JOIN "film" f
ON
	fa."film_id" = f."film_id"
GROUP BY
	a."actor_id"
ORDER BY
	a."first_name",
	a."last_name";

--48. Crea una vista llamada "actor_num_películas" que muestre los nombres de los actores y el número de películas en las que han participado

CREATE VIEW "actor_num_películas" AS 
SELECT  
	CONCAT(a."first_name", ' ', a."last_name") AS "actor",
	count(f."film_id") AS "number_movies"
FROM "actor" a
LEFT JOIN "film_actor" fa
ON
	a."actor_id" = fa."actor_id"
LEFT JOIN "film" f
ON
	fa."film_id" = f."film_id"
GROUP BY
	a."actor_id"
ORDER BY
	a."first_name",
	a."last_name";

SELECT *
FROM "actor_num_películas";


-- 49. Calcula el número total de películas alquiladas por cada cliente.

SELECT
	c."customer_id",
	CONCAT(c."first_name", ' ', c."last_name") AS "customer",
	COUNT(r."rental_id") AS "number_of_rentals"
FROM "customer" c
LEFT JOIN "rental" r
ON 
	c."customer_id" = r."customer_id"
GROUP BY
	c."customer_id"
ORDER BY
	c."customer_id";

-- 50. Calcula la duración total de las películas en la categoría 'Action'

SELECT 
	SUM(f."length") AS "total_duration_action"
FROM "film" f
INNER JOIN "film_category" fc
ON
	f."film_id" = fc."film_id"
INNER JOIN "category" c
ON 
	fc."category_id" = c."category_id"
WHERE c."name" = 'Action';

-- 51.Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.

CREATE TEMPORARY TABLE "cliente_rentas_temporal" AS
SELECT
	c."customer_id",
	CONCAT(c."first_name", ' ', c."last_name") AS "customer",
	COUNT(r."rental_id") AS "number_of_rentals"
FROM "customer" c
LEFT JOIN "rental" r
ON 
	c."customer_id" = r."customer_id"
GROUP BY
	c."customer_id";


SELECT *
FROM "cliente_rentas_temporal";

-- 52. Crea una tabla temporal llamada "peliculas_alquiladas que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMPORARY TABLE "peliculas_alquiladas" AS
SELECT
	f."title",
	COUNT(f."film_id") AS "rental_count"
FROM "rental" r
INNER JOIN "inventory" i
ON 
	r."inventory_id" = i."inventory_id"
INNER JOIN "film" f
ON
	i."film_id" = f."film_id"
GROUP BY 
	f."title"
HAVING COUNT(f."film_id") > 10;

SELECT *
FROM "peliculas_alquiladas"
ORDER BY
	peliculas_alquiladas."rental_count";

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre 'Tammy Sanders' y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película

SELECT 
	CONCAT(c."first_name", ' ', c."last_name") AS "customer",
	f."title",
	r."return_date"
FROM "customer" c
INNER JOIN "rental" r
ON 
	c."customer_id" = r."customer_id"
INNER JOIN "inventory" i
ON 
	r."inventory_id" = i."inventory_id"
INNER JOIN "film" f
ON
	i."film_id" = f."film_id"
WHERE c."first_name" = 'TAMMY' AND c."last_name" = 'SANDERS' AND r."return_date" IS NULL
ORDER BY 
	f."title";

-- 54. Encuentra el nombre de los actores que han actuado en al menos una película que pertenece a la categoría 'Sci-Fi'. Ordena los resultados alfabéticamente por apellido.


WITH "actores_sci_fi" AS (
SELECT 
	a."first_name",
	a."last_name"
FROM "actor" a
INNER JOIN "film_actor" fa
ON
	a."actor_id" = fa."actor_id"
INNER JOIN "film"f 
ON
	fa."film_id" = f."film_id"
INNER JOIN "film_category" fc
ON 
	f."film_id" = fc."film_id"
INNER JOIN "category" c
ON
	fc."category_id" = c."category_id"
WHERE c."name" = 'Sci-Fi'
)
SELECT DISTINCT
	"first_name",
	"last_name"
FROM "actores_sci_fi" 
ORDER BY 
	"last_name",
	"first_name";

-- 55.Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película 'Spartacus Cheaper' se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido


WITH "spartacus_date" AS (
SELECT 
	r."rental_date"
FROM "film" f
INNER JOIN
	"inventory" i
ON 
	f."film_id" = i."film_id" 
INNER JOIN 
	"rental" r
ON
	i."inventory_id" = r."inventory_id"
WHERE 
	f."title" = 'SPARTACUS CHEAPER'
ORDER BY
	r."rental_date"
LIMIT 1)

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en nignuna película de la categoría 'Music'.


SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS actor,
	c.name
FROM actor a 
INNER JOIN
	film_actor fa
ON fa.actor_id = a.actor_id
INNER JOIN 
	film f
ON fa.film_id = f.film_id
INNER JOIN 
	film_category fc
ON fc.film_id = f.film_id
INNER JOIN 
	category c 
ON c.category_id = fc.category_id
WHERE c.name <> 'Music'
ORDER BY actor, c.name;

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT f.title,
	EXTRACT(day FROM(r.return_date - r.rental_date)) AS total_days
FROM rental r
INNER JOIN 
	inventory i
ON 
	r.inventory_id = i.inventory_id
INNER JOIN
	film f
ON
	i.film_id = f.film_id
WHERE  EXTRACT(day FROM(r.return_date - r.rental_date)) > 8
ORDER BY f.title;

-- 58. Encuentra el título de todas las películas que son de la mimsa categoría que 'Animation'.


SELECT DISTINCT f.title
FROM film f
INNER JOIN film_category fc
	ON fc.film_id = f.film_id
INNER JOIN category c 
	ON fc.category_id = c.category_id
WHERE
	c.name = 'Animation';
-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título 'Dancing Fever'. Ordena las películas alfabéticamente por título de película.

SELECT f.title,
	f.length
FROM film f
WHERE f.length = (	
	SELECT
		f.length
	FROM film f
	WHERE f.title = 'DANCING FEVER')
ORDER BY f.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.


SELECT DISTINCT concat(c.first_name, ' ', c.last_name) AS customer, 
	COUNT(r.rental_id) AS rentals
FROM customer c 
INNER JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY 
	c.customer_id
ORDER BY rentals;

SELECT concat(c.first_name, ' ', c.last_name) AS customer
FROM customer c
INNER JOIN rental r 
	ON r.customer_id = c.customer_id
INNER JOIN inventory i
	ON i.inventory_id = r.inventory_id
INNER JOIN film f 
	ON f.film_id = i.film_id
WHERE 
GROUP BY concat(c.first_name, ' ', c.last_name)
ORDER BY concat(c.first_name, ' ', c.last_name);

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.


SELECT c.name,
	count(r.rental_id) AS number_rentals
FROM rental r
INNER JOIN inventory i 
	ON i.inventory_id = r.inventory_id
INNER JOIN film f
	ON f.film_id = i.film_id
INNER JOIN film_category fc 
	ON f.film_id = fc.film_id 
INNER JOIN category c 
	ON c.category_id = fc.category_id
GROUP BY c.name;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006


SELECT c.name,
	count(f.film_id)
FROM category c 
INNER JOIN film_category fc
	ON c.category_id = fc.category_id 
INNER JOIN film f
	ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name;

	
-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos


SELECT concat(s.first_name, ' ', s.last_name),
	st.store_id, 
	st.address_id
FROM staff s
CROSS JOIN store st;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id,
	CONCAT(c.first_name , ' ', c.last_name) AS customer_name,
	COUNT(r.rental_id) total_rentals
FROM customer c
INNER JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id;
