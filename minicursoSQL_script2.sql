#seleciona o banco cafe para uso padrão
use cafe;

#descreve a estrutura da tabela funcionario
desc funcionario;

# projeta o id, nome (em letras maiúsculas, salário atual formatado, 
# data de nascimento formatada (dd de mês de yyyy) e data/hora do cadastro formatada dd/mm/yyyy hh:mi:ss
# dos funcionários cujo salário está entre 1000 e 3000 e que nasceram antes do ano 2000
# limit 3 carrega somente os 3 primeiros respeitando a ordenação determinada no order by
select idFuncionario, 
	UPPER(nomeFuncionario) as nome, 
	replace(concat('R$ ', round(salarioAtual, 2)),'.', ',') as salarioAtual, 
    date_format(dataNascimento, '%d de %M de %Y') as dataNascimento, 
    date_format(dataCadastro, '%d/%m/%Y %h:%i:%s') as dataCadastro
from funcionario
where salarioAtual between 1000 and 3000
#salarioAtual >=1000 and salarioAtual <=3000
	and year(dataNascimento) < 2000
    #and lower(nomeFuncionario) like '%a'
order by salarioAtual desc
limit 3;


select idFuncionario, idPropriedade,
	UPPER(nomeFuncionario) as nome, 
	replace(concat('R$ ', round(salarioAtual, 2)),'.', ',') as salarioAtual, 
    date_format(dataNascimento, '%d de %M de %Y') as dataNascimento, 
    date_format(dataCadastro, '%d/%m/%Y %h:%i:%s') as dataCadastro,
    timestampdiff(year, dataNascimento, now()) as idade
from funcionario;


# Projeta a quantidade de funcionários (count) e a média salarial dos funcionários (avg) de cada propriedade (group by)
# daquelas propriedades cuja média salarial é superior a 1000 (having)
select idPropriedade, count(idFuncionario) as 'Quantidade de funcionários', round(avg(salarioAtual),2) as 'Média do salário'
from funcionario
where salarioAtual > 0
group by idPropriedade
having avg(salarioAtual) > 1000
order by avg(salarioAtual);

#Junção interna (INNER JOIN)

# Todo funcionário é de alguma fazenda (propriedade)
# Vamos selecionar todos os funcionários, projetando também o nome da fazenda a qual são registrados

# Select na tabela funcionário

SELECT * 
FROM funcionario;
# Observe que temos a coluna idPropriedade, que é uma cópia da chave primária da tabela propriedade.
# Na tabela funcionário, a coluna idPropriedade funciona, portanto, como chave estrangeira.
# É através da chave estrangeira que iremos JUNTAR as duas informações: a da tabela funcionario com a tabela propriedade

# Todo funcionário é de alguma propriedade. Portanto, TODO funcionário tem a informação de qual propriedade ele pertence.
# Neste caso usaremos uma junção interna, ou INNER JOIN, estabelecendo a condição de igualdade na chev estrangeira 
# para que a tupla retorne

SELECT f.idFuncionario, f.idPropriedade, p.idPropriedade, f.nomeFuncionario, f.salarioAtual, p.nomePropriedade, p.nomeProprietario
FROM funcionario f, propriedade p
WHERE f.idPropriedade = p.idPropriedade;

# Podemos obter o mesmo resultando escrevendo explicitamente o tipo da junção (INNER)

SELECT f.idFuncionario, f.idPropriedade, p.idPropriedade, f.nomeFuncionario, f.salarioAtual, p.nomePropriedade, p.nomeProprietario
FROM funcionario f INNER JOIN propriedade p ON f.idPropriedade = p.idPropriedade;

# Vamos inserir um filtro qualquer...

# SEM explicitar o JOIN
SELECT f.idFuncionario, f.idPropriedade, p.idPropriedade, f.nomeFuncionario, f.salarioAtual, p.nomePropriedade, p.nomeProprietario
FROM funcionario f, propriedade p
WHERE f.idPropriedade = p.idPropriedade
	AND f.salarioAtual > 2000;
    
# COM a escrita INNER JOIN
SELECT f.idFuncionario, f.idPropriedade, p.idPropriedade, f.nomeFuncionario, f.salarioAtual, p.nomePropriedade, p.nomeProprietario
FROM funcionario f INNER JOIN propriedade p ON f.idPropriedade = p.idPropriedade
WHERE f.salarioAtual > 2000;
#OU

SELECT f.idFuncionario, f.idPropriedade, p.idPropriedade, f.nomeFuncionario, f.salarioAtual, p.nomePropriedade, p.nomeProprietario
FROM funcionario f INNER JOIN propriedade p ON f.idPropriedade = p.idPropriedade AND f.salarioAtual > 2000;

# Agora vamos juntar a informação do nome da propriedade àquela consulta anterior com agrupamento...

# Projeta a quantidade de funcionários (count) e a média salarial dos funcionários (avg) de cada propriedade (group by)
# daquelas propriedades cuja média salarial é superior a 1000 (having)
select idPropriedade, count(idFuncionario) as 'Quantidade de funcionários', round(avg(salarioAtual),2) as 'Média do salário'
from funcionario
where salarioAtual > 0
group by idPropriedade
having avg(salarioAtual) > 1000
order by avg(salarioAtual);

#não queremos o id da propriedade, e sim seu nome
select p.nomePropriedade, count(idFuncionario) as 'Quantidade de funcionários', round(avg(salarioAtual),2) as 'Média do salário'
from funcionario f inner join propriedade p ON f.idPropriedade = p.idPropriedade
where salarioAtual > 0
group by p.nomePropriedade
having avg(salarioAtual) > 1000
order by avg(salarioAtual);

#inserindo o nome do proprietário à consulta...
select p.nomePropriedade, p.nomeProprietario, count(idFuncionario) as 'Quantidade de funcionários', round(avg(salarioAtual),2) as 'Média do salário'
from funcionario f inner join propriedade p ON f.idPropriedade = p.idPropriedade
where salarioAtual > 0
group by p.nomePropriedade, p.nomeProprietario
having avg(salarioAtual) > 1000
order by avg(salarioAtual);

# JUNÇÃO EXTERNA

# Planos de safra

SELECT *
FROM safra s
WHERE s.dataInicio >= str_to_date('01/01/2021', '%d/%m/%Y')
	#AND s.dataExclusao IS NULL
ORDER BY s.dataInicio, s.dataFim;

# Áreas produtivas de cada safra

SELECT *
FROM safra_talhao;

# Vamos juntar (JOIN) a aafra_talhao com a talhao (INNER JOIN)
SELECT st.*, t.descTalhao
FROM safra_talhao st 
	INNER JOIN talhao t ON st.idTalhao = t.idTalhao;

# Agora, vamos juntar a safra_talhao com a safra, para trazer as informações da safra
SELECT st.*, t.descTalhao, s.dataInicio, s.dataFim, s.desc_ano_agricola
FROM safra_talhao st 
	INNER JOIN talhao t ON st.idTalhao = t.idTalhao
	INNER JOIN safra s ON (st.idSafra = s.idSafra 
		AND s.dataExclusao IS NULL 
        AND s.dataInicio >= str_to_date('01/01/2021', '%d/%m/%Y'))
ORDER BY st.idSafra, t.descTalhao;

# A tabela safra_venda mostra as vendas que já ocorreram e a respectiva safra (idSafra) do produto vendido
SELECT * FROM safra_venda;

# Então, vamos juntar à consulta anterior as informações das vendas. Mesmo que ainda não ocorreu alguma venda, precisamos
# retornar as informações da safra, talhao, colheita, etc.

SELECT st.*, t.descTalhao, s.dataInicio, s.dataFim, s.desc_ano_agricola
FROM safra_talhao st 
	INNER JOIN talhao t ON st.idTalhao = t.idTalhao
	INNER JOIN safra s ON (st.idSafra = s.idSafra 
		AND s.dataExclusao IS NULL 
        AND s.dataInicio >= str_to_date('01/01/2021', '%d/%m/%Y'))
ORDER BY st.idSafra, t.descTalhao;

# se fizermos o INNER JOIN, vamos perder informações daquelas safras que ainda não houve venda para seu produto...
SELECT st.*, t.descTalhao, s.dataInicio, s.dataFim, s.desc_ano_agricola, sv.valorSaca, sv.numSacas, sv.dataVenda
FROM safra_talhao st 
	INNER JOIN talhao t ON st.idTalhao = t.idTalhao
	INNER JOIN safra s ON (st.idSafra = s.idSafra 
		AND s.dataExclusao IS NULL 
        AND s.dataInicio >= str_to_date('01/01/2021', '%d/%m/%Y')
    )
    INNER JOIN safra_venda sv ON s.idSafra = sv.idSafra
ORDER BY st.idSafra, t.descTalhao;

# Então, para esse caso, precisamos de um outro tipo de junção, 
# que nos permite retornar não somente a interseção entre os conjuntos,
# mas também um dos conjuntos (à esquerda ou à direita) totalmente
# Para isso, temos a junção externa (OUTER JOIN)

SELECT st.*, t.descTalhao, s.dataInicio, s.dataFim, s.desc_ano_agricola, sv.valorSaca, sv.numSacas, sv.dataVenda
FROM safra_talhao st 
	INNER JOIN talhao t ON st.idTalhao = t.idTalhao
	INNER JOIN safra s ON (st.idSafra = s.idSafra 
		AND s.dataExclusao IS NULL 
        AND s.dataInicio >= str_to_date('01/01/2021', '%d/%m/%Y')
    )
    LEFT OUTER JOIN safra_venda sv ON s.idSafra = sv.idSafra
ORDER BY st.idSafra, t.descTalhao;


# Vamos entender melhor os tipos de junção
/*
CREATE TABLE tab_a (
	a int not null primary key,
    b int,
    c int
);

CREATE TABLE tab_x (
	x int not null primary key,
    y int,
    z int,
    a int,
    foreign key (a) references tab_a (a)
);

INSERT INTO tab_a VALUES (1,2,3);
INSERT INTO tab_a VALUES (2,3,1);
INSERT INTO tab_a VALUES (3,5,6);
INSERT INTO tab_a VALUES (4,7,8);
INSERT INTO tab_a VALUES (5,6,7);



INSERT INTO tab_x VALUES (1,2,3,NULL);
INSERT INTO tab_x VALUES (2,5,3,1);
INSERT INTO tab_x VALUES (3,5,6,1);
INSERT INTO tab_x VALUES (4,9,7,2);
INSERT INTO tab_x VALUES (5,10,3,NULL);
INSERT INTO tab_x VALUES (6,9,3,NULL);


*/

select * from tab_a;
SELECT * FROM tab_x;

# tudo que tem em tab_a e tem em tab_x
SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a INNER JOIN tab_x x ON a.a = x.a;
# veja que retornou somente as tuplas que possuem 'a' na tab_x (chave estrangeira) preenchida

# tudo que tem em tab_a, tendo igualdade ou não em tab_x
SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a LEFT OUTER JOIN tab_x x ON a.a = x.a;

# tudo que tem em tab_x, tendo igualdade ou não em tab_a
SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a RIGHT OUTER JOIN tab_x x ON a.a = x.a;

# O MySQL NÃO TEM a opção de FULL OUTER JOIN

SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a LEFT OUTER JOIN tab_x x ON a.a = x.a
UNION # UNION elimina duplicatas exatas
SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a RIGHT OUTER JOIN tab_x x ON a.a = x.a;

SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a LEFT OUTER JOIN tab_x x ON a.a = x.a
UNION ALL # UNION ALL não elimina duplicatas
SELECT a.a, a.b, x.a, x.x, x.y
FROM tab_a a RIGHT OUTER JOIN tab_x x ON a.a = x.a;

# Seleciona todas as receitas (entradas) extras
SELECT 
        r.descricaoReceita AS descricaoReceita,
        r.valor AS valor,
        r.dataVenda AS data,
        r.idPropriedade AS idPropriedade,
        COALESCE(r.idRecursoVendido, 0) AS idRecurso,
        COALESCE(re.descRecurso,
                'recurso não identificado') AS descRecurso,
        COALESCE(re.tpTipoRecurso,
                'venda de safra') AS tipoRecurso,
        COALESCE(r.idSafra, 0) AS idSafra,
        COALESCE(s.desc_ano_agricola,
                'safra não identificada') AS desc_ano_agricola
    FROM
        receita r
        LEFT OUTER JOIN recurso re ON r.idRecursoVendido = re.idRecurso
        LEFT OUTER JOIN safra s ON (r.idSafra = s.idSafra AND s.dataExclusao IS NULL);
        
# Seleciona todas as vendas de safra
SELECT 
        'venda de safra' AS descricaoReceita,
        (sv.valorSaca * sv.numSacas) AS valor,
        sv.dataVenda AS data,
        s.idPropriedade AS idPropriedade,
        s.idCultura AS idRecurso,
        c.descCultura AS descRecurso,
        'venda de safra' AS tipoRecurso,
        sv.idSafra AS idSafra,
        s.desc_ano_agricola AS desc_ano_agricola
    FROM
        safra_venda sv
        JOIN safra s ON sv.idSafra = s.idSafra
        JOIN cultura c ON s.idCultura = c.idCultura;
        
# Vamos unir as duas consultas, obtendo todo tipo de receita




# Agora vamos criar uma view com essa consulta

# Consulte a sua view

