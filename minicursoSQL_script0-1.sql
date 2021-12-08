use universidade;

alter table professor add column num_avaliacoes int null comment 'Numero de avaliacoes do professor';

select * from avaliacao;

DELIMITER $$
CREATE TRIGGER `universidade`.`tai_avaliacao` 
AFTER INSERT ON `avaliacao` FOR EACH ROW
BEGIN
	update professor set num_avaliacoes = coalesce(num_avaliacoes,0) + 1 
    where idProfessor = new.idProfessor;
END$$
DELIMITER ;

select * from professor;
#testando a trigger
insert into avaliacao (dataHora, idProfessor, nota, comentario)
values (now(), 12345, 5, 'xxx');

select * from professor;
