#Curso SQL - 2021

use employees;
# renomeando as tabelas do BD employees
/*
alter table departments rename to departamento;
alter table employees rename to funcionario;
alter table salaries rename to salario;
alter table titles rename to cargo;
alter table dept_emp rename to dept_func;
alter table dept_manager rename to dept_gerente;
*/

# * seleciona 'todasa as colunas' da origem indicada no FROM
select * from departamento;

select * from funcionario;

select * from dept_func;

select * from dept_gerente;

select * from cargo;

select * from salario;

#Indicando quais colunas queremos projetar na seleção

SELECT emp_no, first_name, gender
FROM funcionario;

#aplicação de algumas funções uteis para melhorar a visualização

#select simples na tabela funcionario, mostrando o nome completo
SELECT CONCAT(f.first_name, ' ', f.last_name) AS nome_funcionario, f.gender, f.hire_date, f.birth_date
FROM funcionario f;

#cálculo da idade do funcionario. Uso do CASE
SELECT CONCAT(f.first_name, ' ', f.last_name) AS nome_funcionario, 
	f.gender, 
    #CASE f.gender WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Feminino' ELSE '-' END AS gender, 
    f.hire_date, f.birth_date, 
    TIMESTAMPDIFF(YEAR, f.birth_date, NOW()) AS idade
FROM funcionario f;

#melhorando a vizualização das datas
select concat(f.first_name, ' ', f.last_name) as nome_funcionario, 
	f.gender, 
    date_format(f.hire_date, '%d/%m/%Y') as data_contratacao, 
    f.birth_date, 
    timestampdiff(year, f.birth_date, now()) as idade
from funcionario f
ORDER BY f.hire_date;
#faça o mesmo para a data de nascimento. Ordene pela data de nascimento e pela data de contratação

#faça o cálculo do tempo de empresa do funcionário, baseado na data atual
select concat(f.first_name, ' ', f.last_name) as nome_funcionario, 
	f.gender, 
    date_format(f.hire_date, '%d/%m/%Y') as data_contratacao, 
    f.birth_date, 
    timestampdiff(year, f.birth_date, now()) as idade,
    timestampdiff(year, f.hire_date, now()) as tempo_empresa
from funcionario f;
#ORDER BY tempo_empresa DESC, IDADE;
#limit 10;

#FILTROS da origem. Cláusula WHERE

#todos os funcionarios do sexo masculino
SELECT *#count(emp_no) as quantidade
FROM funcionario f
WHERE gender = 'M';

#todos os funcionarios do sexo masculino e que foram contratados no ano de 86
SELECT * #count(emp_no) as quantidade
FROM funcionario f
WHERE gender = 'M' 
	#AND f.hire_date >= str_to_date('1986-01-01','%Y-%m-%d') AND f.hire_date <= str_to_date('1986-12-31','%Y-%m-%d')
    #AND f.hire_date >= str_to_date('01/01/1986','%d/%m/%Y') AND f.hire_date <= str_to_date('31/12/1986','%d/%m/%Y')
    #AND f.hire_date between str_to_date('01/01/1986','%d/%m/%Y') AND str_to_date('31/12/1986','%d/%m/%Y')
    AND YEAR(f.hire_date) = 1986
ORDER BY f.hire_date;

SELECT COUNT(emp_no)
FROM funcionario f
WHERE gender = 'F';

select 21716 + 120051;

#todos os funcionarios do sexo masculino e que foram contratados depois em 86 OU sexo feminino contratadas em qualquer data
SELECT * #count(emp_no) as quantidade
FROM funcionario f
WHERE (gender = 'M' AND f.hire_date between str_to_date('01/01/1986','%d/%m/%Y') AND str_to_date('31/12/1986','%d/%m/%Y'))
	OR gender = 'F';

#todos os funcionarios do sexo masculino e que foram contratados em 86 OU sexo feminino contratadas em 87
SELECT * #count(emp_no) as quantidade
FROM funcionario f
WHERE (f.gender = 'M' AND YEAR(f.hire_date) = 1986) 
	OR
	(f.gender = 'F' AND YEAR(f.hire_date) = 1987) 
ORDER BY f.gender;

SELECT 13426 + 21716;

#AGRUPAMENTOS E FUNÇÕES DE AGREGAÇÃO
Select f.gender, count(emp_no) as quantidade
from funcionario f
group by f.gender;

select *
from salario;

select *
from salario
where emp_no = 10001 order by from_date, to_date;


select emp_no, max(salary) as maior_salario
from salario
where to_date = str_to_date('9999-01-01', '%Y-%m-%d')
group by emp_no;


select *
from dept_func;

#analyze table dept_func;
#optimize table dept_func;

select dept_no, count(emp_no)
from dept_func
where to_date = str_to_date('9999-01-01', '%Y-%m-%d')
group by dept_no
having count(emp_no) > 20000;


#JOINs

#Junção interna
SELECT * # 300024
from funcionario f;


SELECT *
FROM dept_func 
limit 5;


select emp_no, max(to_date) as to_date
from dept_func
group by emp_no
order by to_date;

SELECT f.emp_no, concat(f.first_name, ' ', f.last_name) as nome, date_format(f.hire_date, '%d/%m/%Y') as data_contratacao
FROM funcionario f;

SELECT f.emp_no, concat(f.first_name, ' ', f.last_name) as nome, date_format(f.hire_date, '%d/%m/%Y') as data_contratacao,
	d.dept_name as departamento, df.from_date as inicio_departamento
FROM funcionario f, 
     (select emp_no, max(to_date) as to_date
	  from dept_func
	  group by emp_no) u,
     dept_func df,
     departamento d
WHERE f.emp_no = u.emp_no
	and u.emp_no = df.emp_no and u.to_date = df.to_date
    and df.dept_no = d.dept_no and df.emp_no = f.emp_no;
	
select count(emp_no)#, count(dept_no)
from dept_func df
group by emp_no
having count(dept_no) > 1; 
   
select concat(f.first_name, ' ', f.last_name) as nome_funcionario, 
	f.gender, 
    f.hire_date, 
    f.birth_date, 
    timestampdiff(year, f.birth_date, now()) as idade, 
    c.from_date, 
    c.title
from funcionario f inner join cargo c on f.emp_no = c.emp_no
order by c.emp_no, c.from_date;


#salario do funcionário, deprtamento...
select emp_no, max(salary) as salary
from salario
group by emp_no;

SELECT f.emp_no, concat(f.first_name, ' ', f.last_name) as nome, date_format(f.hire_date, '%d/%m/%Y') as data_contratacao,
	d.dept_name as departamento, df.from_date as inicio_departamento, s.salary as salario_atual
FROM funcionario f, 
     (select emp_no, max(to_date) as to_date
	  from dept_func
	  group by emp_no) u,
     dept_func df,
     departamento d,
     (select emp_no, max(salary) as salary
      from salario
	  group by emp_no) as s
WHERE f.emp_no = u.emp_no
	and u.emp_no = df.emp_no and u.to_date = df.to_date
    and df.dept_no = d.dept_no and df.emp_no = f.emp_no
    and f.emp_no = s.emp_no;


#media salarial por departamento
select d.dept_no, d.dept_name, round(avg(s.salary),2) as media_salario
from departamento d
	inner join dept_func df on d.dept_no = df.dept_no
    inner join (select emp_no, max(to_date) as to_date from dept_func group by emp_no) u on (df.emp_no = u.emp_no and df.to_date = u.to_date)
    inner join (select emp_no, max(salary) as salary from salario group by emp_no) s on df.emp_no = s.emp_no
group by df.dept_no
order by d.dept_name;