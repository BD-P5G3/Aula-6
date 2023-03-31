# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
SELECT * FROM pubs.dbo.authors
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
SELECT au_fname, au_lname, phone FROM pubs.dbo.authors
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
SELECT au_fname, au_lname, phone FROM authors ORDER BY au_fname, au_lname ASC
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
SELECT au_fname AS first_name, au_lname AS last_name, phone AS telephone  FROM authors ORDER BY au_fname, au_lname ASC
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
SELECT au_fname AS first_name, au_lname AS last_name, phone AS telephone
FROM authors
WHERE au_lname!='Ringer' AND state='CA'
ORDER BY au_fname, au_lname
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
SELECT * FROM publishers WHERE pub_name LIKE '%Bo%'
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
SELECT *
FROM publishers JOIN titles
ON (publishers.pub_id=titles.pub_id AND type='business')
```

### *h)* Número total de vendas de cada editora; 

```
SELECT pub_name, SUM(ytd_sales)
FROM publishers JOIN titles
ON (publishers.pub_id=titles.pub_id)
GROUP BY pub_name
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
SELECT pub_name, title, SUM(ytd_sales)
FROM publishers JOIN titles
ON (publishers.pub_id=titles.pub_id)
GROUP BY pub_name, title
ORDER BY pub_name
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
SELECT title
FROM titles
INNER JOIN sales ON titles.title_id = sales.title_id
INNER JOIN stores ON sales.stor_id = stores.stor_id
WHERE stores.stor_name = 'Bookbeat'
ORDER BY titles.title
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
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
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT type AS book_type, pub_name AS publisher, AVG(titles.price) AS price_avg, SUM(ytd_sales) AS total_sales
FROM titles JOIN publishers ON titles.pub_id = publishers.pub_id
GROUP BY type, pub_name
HAVING AVG(titles.price) IS NOT NULL;
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
SELECT title, advance, average
FROM titles JOIN (
                 SELECT titles.type, AVG(advance) AS average
		         FROM titles
			     WHERE advance IS NOT NULL
			     GROUP BY titles.type
			) AS grp
ON titles.type = grp.type AND advance > 1.5*average;
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT title, au_fname AS first_name, au_lname AS last_name, sum(ytd_sales) AS money_made
FROM authors JOIN titleauthor ON authors.au_id = titleauthor.au_id
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN sales ON titles.title_id = sales.title_id
GROUP BY title, au_fname, au_lname
ORDER BY title, au_fname, au_lname
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
SELECT DISTINCT titles.title, ytd_sales,
       ytd_sales * price AS facturacao,
       ytd_sales * royalty * price / 100 AS auths_revenue,
       ytd_sales * price * (100 - royalty) / 100 AS pub_revenue
FROM titles
INNER JOIN sales ON titles.title_id = sales.title_id;
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
SELECT DISTINCT titles.title, au_fname + ' ' + au_lname AS name, ytd_sales,
				ytd_sales * price AS faturacao,
				ytd_sales * royalty * price/100 AS authors_revenue,
				ytd_sales * price * (100-royalty)/100 AS publisher_revenue
FROM titles
INNER JOIN sales ON titles.title_id = sales.title_id
INNER JOIN titleauthor ON titles.title_id = titleauthor.title_id
INNER JOIN authors a on titleauthor.au_id = a.au_id
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
SELECT stores.stor_name, COUNT(DISTINCT titles.title) AS different
FROM stores
INNER JOIN sales ON stores.stor_id = sales.stor_id
INNER JOIN titles ON sales.title_id = titles.title_id
GROUP BY stores.stor_name
HAVING COUNT(DISTINCT titles.title) = (SELECT COUNT(titles.title) FROM titles);
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT stor_name, sum(qty) AS sum_qty
FROM sales JOIN stores
ON sales.stor_id=stores.stor_id
GROUP BY stor_name
HAVING sum(qty) > (	SELECT avg(sum_qty)
						FROM (	SELECT sum(qty) AS sum_qty, stor_id AS stid
								FROM sales
								GROUP BY stor_id) as T
					);
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
SELECT titles.title
FROM titles
LEFT JOIN (
    SELECT sales.title_id
    FROM sales
    INNER JOIN stores ON sales.stor_id = stores.stor_id
    WHERE stores.stor_name = 'Bookbeat'
) AS bookbeat_sales ON titles.title_id = bookbeat_sales.title_id
WHERE bookbeat_sales.title_id IS NULL;
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
... Write here your answer ...
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
... Write here your answer ...
```

##### *b)* 

```
... Write here your answer ...
```

##### *c)* 

```
... Write here your answer ...
```

##### *d)* 

```
... Write here your answer ...
```

##### *e)* 

```
... Write here your answer ...
```

##### *f)* 

```
... Write here your answer ...
```

##### *g)* 

```
... Write here your answer ...
```

##### *h)* 

```
... Write here your answer ...
```

##### *i)* 

```
... Write here your answer ...
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
... Write here your answer ...
```

##### *b)* 

```
... Write here your answer ...
```


##### *c)* 

```
... Write here your answer ...
```


##### *d)* 

```
... Write here your answer ...
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
... Write here your answer ...
```

##### *b)* 

```
... Write here your answer ...
```


##### *c)* 

```
... Write here your answer ...
```


##### *d)* 

```
... Write here your answer ...
```

##### *e)* 

```
... Write here your answer ...
```

##### *f)* 

```
... Write here your answer ...
```
