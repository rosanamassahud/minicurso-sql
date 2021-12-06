#Curso SQL - 2021

use employees;
# renomeando as tabelas do BD employees

alter table departments rename to departamento;
alter table employees rename to funcionario;
alter table salaries rename to salario;
alter table titles rename to cargo;
alter table dept_emp rename to dept_func;
alter table dept_manager rename to dept_gerente;

select * from departamento;

select * from funcionario;

select * from dept_func;

select * from dept_gerente;

select * from cargo;

select * from salario;

#select simples na tabela funcionario, mostrando o nome completo
select concat(f.first_name, ' ', f.last_name) as nome_funcionario, f.gender, f.hire_date, f.birth_date#, timestampdiff(year, f.birth_date, now()) as idade
from funcionario f;

#cálculo da idade do funcionario
select concat(f.first_name, ' ', f.last_name) as nome_funcionario, f.gender, f.hire_date, f.birth_date, timestampdiff(year, f.birth_date, now()) as idade
from funcionario f;

#melhorando a vizualização das datas
select concat(f.first_name, ' ', f.last_name) as nome_funcionario, f.gender, date_format(f.hire_date, '%d/%m/%Y') as data_contratacao, f.birth_date, timestampdiff(year, f.birth_date, now()) as idade
from funcionario f
ORDER BY f.hire_date;
#faça o mesmo para a data de nascimento

#faça o cálculo do tempo de empresa do funcionário

select concat(f.first_name, ' ', f.last_name) as nome_funcionario, f.gender, f.hire_date, f.birth_date, timestampdiff(year, f.birth_date, now()) as idade, c.from_date, c.title
from funcionario f inner join cargo c on f.emp_no = c.emp_no
order by c.emp_no, c.from_date;

