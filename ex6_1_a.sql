SELECT DISTINCT authors.au_fname, authors.au_lname
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titleauthor.title_id = titles.title_id
INNER JOIN (
    SELECT titleauthor.au_id
    FROM titleauthor
    INNER JOIN titles ON titleauthor.title_id = titles.title_id
    GROUP BY titleauthor.au_id
    HAVING COUNT(DISTINCT titles.type) > 1
) AS subquery ON authors.au_id = subquery.au_id
ORDER BY authors.au_lname, authors.au_fname;

