# Modelo físico para o projeto Universidade

#Criar o banco (schema)

#CREATE SCHEMA universidade;
#crie um schema com o seu nome...

#Definir o schema universidade como padrão para uso

#USE universidade;
# ESCREVA: USE <nome_do_banco>;

#Criação das tabelas, de acordo com o projeto lógico (mapeamento)

#Tabela 'estudante'

CREATE TABLE estudante(
	matricula INT NOT NULL PRIMARY KEY,
    nomeEstudante VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    logradouro VARCHAR(150),
    numero VARCHAR(6),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    sexo ENUM('M','F')
);

#Tabela 'departamento'

CREATE TABLE departamento(
	codigoDept INT NOT NULL auto_increment PRIMARY KEY,
    nomeDept VARCHAR(50) NOT NULL,
    localizacao VARCHAR(100),
    idProfessorChefe INT
);

#Tabela 'disciplina'

CREATE TABLE disciplina (
	codigoDisc INT not null auto_increment PRIMARY KEY,
    nomeDisc VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    codigoDept INT NOT NULL,
    FOREIGN KEY (codigoDept) REFERENCES departamento (codigoDept)
);

#Tabela 'professor'

CREATE TABLE professor(
	idProfessor INT NOT NULL PRIMARY KEY,
    nomeProfessor VARCHAR(150),
    codigoDept INT NOT NULL,
    FOREIGN KEY (codigoDept) REFERENCES departamento (codigoDept)
);


ALTER TABLE departamento ADD CONSTRAINT `fk_departamento_idProfessorChefe` 
	FOREIGN KEY (idProfessorChefe) 
		REFERENCES professor (idProfessor);

#Tabela 'livro_texto'

CREATE TABLE livro_texto (
	isbn VARCHAR(20) NOT NULL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    editora VARCHAR(150)
);

#Tabela 'avaliacao'

CREATE TABLE avaliacao (
	dataHora DATETIME NOT NULL,
    idProfessor INT NOT NULL,
    nota double(3,1) NOT NULL,
    comentario TEXT,
    PRIMARY KEY (dataHora, idProfessor),
    FOREIGN KEY (idProfessor) REFERENCES professor (idProfessor)
);


#Tabela 'pre_requisito_disciplina'

CREATE TABLE pre_requisito_disciplina (
	codigoDisc INT NOT NULL,
    codigoDiscPreRequisito INT NOT NULL,
    PRIMARY KEY (codigoDisc, codigoDiscPreRequisito),
    FOREIGN KEY (codigoDisc) REFERENCES disciplina (codigoDisc),
    FOREIGN KEY (codigoDiscPreRequisito) REFERENCES disciplina (codigoDisc)
);

#Tabela 'turma'

CREATE TABLE turma (
	codigoTurma INT NOT NULL auto_increment primary KEY,
    idProfessor INT NOT NULL,
    codigoDisc INT NOT NULL,
    semestre tinyint NOT NULL,
    ano smallint NOT NULL
);

#Tabela estudante_turma

CREATE TABLE estudante_turma (
	matricula INT NOT NULL,
    codigoTurma INT NOT NULL,
    nota DOUBLE(5,2),
    PRIMARY KEY (matricula, codigoTurma),
    FOREIGN KEY (matricula) REFERENCES estudante (matricula),
    FOREIGN KEY (codigoTurma) REFERENCES turma (codigoTurma)
);

#Tabela 'turma_livro_texto'

CREATE TABLE turma_livro_texto (
	codigoTurma INT NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    primary key (codigoTurma, isbn),
    foreign key (codigoTurma) references turma (codigoTurma),
    foreign key (isbn) references livro_texto (isbn)
);


#Inserindo e editando dados no banco...

INSERT INTO departamento (nomeDept) VALUES ('Elétrica');
INSERT INTO departamento (nomeDept) VALUES ('Mecânica e Computação');
INSERT INTO departamento (nomeDept) VALUES ('Formação Geral');

INSERT INTO professor (idProfessor, nomeProfessor, codigoDept)
VALUES (12345, 'Rosana', 1);

INSERT INTO professor (idProfessor, nomeProfessor, codigoDept)
VALUES (87654, 'Ítalo', 1);

UPDATE departamento SET idProfessorChefe = 87654 WHERE codigoDept = 1;
