--1. Liste des potions : Numéro, libellé, formule et constituant principal. (5 lignes)
SELECT *
FROM potion;

--2. Liste des noms des catégories rapportant 3 points. (2 lignes)
SELECT nom_categ
FROM categorie
WHERE nb_points = 3;

--3. Liste des villages (noms) contenant plus de 35 huttes. (4 lignes)
SELECT nom_village
FROM village 
WHERE nb_huttes > 35;

--4. Liste des trophées (numéros) pris en mai / juin 52. (4 lignes)
SELECT num_trophee
FROM trophee
WHERE date_prise BETWEEN '2052-05-01' AND '2052-06-30';

--5. Noms des habitants commençant par 'a' et contenant la lettre 'r'. (3 lignes)
SELECT nom
FROM habitant
WHERE nom LIKE 'A%r%';

--6. Numéros des habitants ayant bu les potions numéros 1, 3 ou 4. (8 lignes)
SELECT DISTINCT num_hab
FROM absorber
-- WHERE num_potion =  1 OR num_potion = 3  OR num_potion = 4
WHERE num_potion IN (1, 3, 4);

--7. Liste des trophées : numéro, date de prise, nom de la catégorie et nom du preneur. (10lignes)
SELECT t.num_trophee, t.date_prise, c.nom_categ, h.nom
FROM trophee t 
JOIN categorie c ON t.code_cat = c.code_cat
JOIN habitant h ON t.num_preneur = h.num_hab;

--8. Nom des habitants qui habitent à Aquilona. (7 lignes)
SELECT DISTINCT nom
FROM habitant h
JOIN  village v ON h.num_village = v.num_village
WHERE v.nom_village ='Aquilona';

--9. Nom des habitants ayant pris des trophées de catégorie Bouclier de Légat. (2 lignes)
SELECT DISTINCT nom
FROM habitant h
JOIN trophee t ON h.num_hab = t.num_preneur
JOIN categorie c ON t.code_cat = c.code_cat
WHERE c.nom_categ = 'Bouclier de Légat';

--10. Liste des potions (libellés) fabriquées par Panoramix : libellé, formule et constituantprincipal. (3 lignes)
SELECT DISTINCT lib_potion, formule, constituant_principal
FROM potion p
JOIN fabriquer f ON p.num_potion = f.num_potion
JOIN habitant h ON  f.num_hab = h.num_hab
WHERE h.nom = 'Panoramix';

--11. Liste des potions (libellés) absorbées par Homéopatix. (2 lignes)
SELECT DISTINCT lib_potion
FROM potion p
JOIN absorber a ON p.num_potion = a.num_potion
JOIN habitant h ON a.num_hab = h.num_hab
WHERE h.nom = 'Homéopatix';

--12. Liste des habitants (noms) ayant absorbé une potion fabriquée par l'habitant numéro 3. (4 lignes)
SELECT DISTINCT nom
FROM habitant h
JOIN absorber a ON h.num_hab = a.num_hab
JOIN potion p ON a.num_potion = p.num_potion 
JOIN fabriquer f ON p.num_potion = f.num_potion 
WHERE f.num_hab = 3;

--13. Liste des habitants (noms) ayant absorbé une potion fabriquée par Amnésix. (7 lignes)
SELECT DISTINCT hab.nom
FROM habitant hab
JOIN absorber a ON hab.num_hab = a.num_hab
JOIN fabriquer f ON a.num_potion = f.num_potion
WHERE f.num_hab = (
	SELECT num_hab 	
	FROM habitant 
	WHERE nom = 'Amnésix'
);


--14. Nom des habitants dont la qualité n'est pas renseignée. (2 lignes)
SELECT nom
FROM habitant h
WHERE num_qualite IS NULL;

--15. Nom des habitants ayant consommé la Potion magique n°1 (c'est le libellé de lapotion) en février 52. (3 lignes)
SELECT nom
FROM habitant h
JOIN absorber a ON h.num_hab =  a.num_hab
JOIN potion p ON  a.num_potion = p.num_potion
WHERE p.lib_potion = 'Potion magique n°1'
and extract (month from a.date_a) = 02
and extract (year from a.date_a) = 2052;


--16. Nom et âge des habitants par ordre alphabétique. (22 lignes)
SELECT nom, age
FROM habitant h
ORDER BY nom;

--17. Liste des resserres classées de la plus grande à la plus petite : nom de resserre et nom du village. (3 lignes)
SELECT nom_resserre, nom_village
FROM resserre r
JOIN village v ON r.num_village = v.num_village
ORDER by r.superficie desc;
--***

--18. Nombre d'habitants du village numéro 5. (4)
SELECT COUNT(*) AS nb_hab
FROM habitant h
WHERE num_village = 5;

--19. Nombre de points gagnés par Goudurix. (5)
SELECT SUM(nb_points) AS points_gagnes
FROM categorie c
JOIN trophee t ON c.code_cat = t.code_cat
JOIN habitant h ON h.num_hab = t.num_preneur
WHERE h.nom = 'Goudurix';

--20. Date de première prise de trophée. (03/04/52)
SELECT MIN(date_prise)
FROM trophee t;

--21. Nombre de louches de Potion magique n°2 (c'est le libellé de la potion) absorbées. (19)
SELECT SUM(quantite)
FROM absorber a
JOIN potion p ON a.num_potion = p.num_potion
WHERE p.lib_potion = 'Potion magique n°2';

--22. Superficie la plus grande. (895)
SELECT MAX(superficie)
FROM resserre r; 
--***

--23. Nombre d'habitants par village (nom du village, nombre). (7 lignes)
SELECT v.nom_village, COUNT(h.num_hab) AS nb_habitants
FROM village v 
JOIN habitant h ON v.num_village = h.num_hab
GROUP BY v.nom_village; 

--24. Nombre de trophées par habitant (6 lignes)
SELECT h.nom, COUNT(t.num_trophee) AS nb_trophee
FROM habitant h
JOIN trophee t ON h.num_hab = t.num_preneur
GROUP BY h.nom; 

--25. Moyenne d'âge des habitants par province (nom de province, calcul). (3 lignes)
SELECT p.nom_province, AVG(h.age) AS moyenne_age
FROM province p 
JOIN village v ON p.num_province = v.num_province 
JOIN habitant h ON v.num_village = h.num_village 
GROUP BY p.nom_province;

--26. Nombre de potions différentes absorbées par chaque habitant (nom et nombre). (9lignes)
SELECT h.nom, COUNT(DISTINCT a.num_potion) AS nb_potions_absorbees
FROM habitant h 
JOIN absorber a ON h.num_hab = a.num_hab 
JOIN potion p ON a.num_potion = p.num_potion 
GROUP BY h.nom;

--27. Nom des habitants ayant bu plus de 2 louches de potion zen. (1 ligne)
SELECT h.nom
FROM habitant h
JOIN absorber a ON h.num_hab = a.num_hab
JOIN potion p ON a.num_potion = p.num_potion
WHERE p.lib_potion = 'Potion Zen' AND a.quantite > 2
GROUP BY h.nom;
--***

--28. Noms des villages dans lesquels on trouve une resserre (3 lignes)
SELECT DISTINCT v.nom_village
FROM village v 
JOIN resserre r ON v.num_village = r.num_village; 

--29. Nom du village contenant le plus grand nombre de huttes. (Gergovie)
SELECT v.nom_village
FROM village v 
ORDER BY nb_huttes DESC
LIMIT 1;

--30. Noms des habitants ayant pris plus de trophées qu'Obélix (3 lignes).
SELECT h.nom, COUNT(t.num_trophee) AS nb_trophees
FROM habitant h
JOIN trophee t ON h.num_hab = t.num_preneur 
GROUP BY h.nom 
HAVING COUNT(t.num_trophee) > (
  SELECT COUNT(t.num_trophee)
  FROM trophee t
  JOIN habitant h ON t.num_preneur = h.num_hab
  WHERE h.nom = 'Obélix'
);
