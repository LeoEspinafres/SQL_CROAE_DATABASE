-- Criar db
CREATE DATABASE croae_projeto;

-- ficar a negrito e usar esta 
USE croae_projeto;

-- para nao dar erro caso ja exista
DROP TABLE IF EXISTS doacoes;
DROP TABLE IF EXISTS adocoes;
DROP TABLE IF EXISTS familia_adotantes;
DROP TABLE IF EXISTS ordem_tribunal;
DROP TABLE IF EXISTS ocorrencias_animais;
DROP TABLE IF EXISTS ocorrencias_animal_pessoa;
DROP TABLE IF EXISTS vacinacoes;
DROP TABLE IF EXISTS vacinas;
DROP TABLE IF EXISTS consultas_veterinario;
DROP TABLE IF EXISTS boxes;
DROP TABLE IF EXISTS voluntarios;
DROP TABLE IF EXISTS funcionarios;
DROP TABLE IF EXISTS apadrinhamentos;
DROP TABLE IF EXISTS caes;
DROP TABLE IF EXISTS racas;

/* DISCLAIMER
	Há tabelas e conceitos que ainda estou a tentar entender como introduzir:
		- por exemplo, historico de peso com um trigger update para a tabela caes;
        - o tipo "Blob" para fotos
		- as duas tabelas ocorrências ainda dá para melhorar
        - usar mais vezes text ou varchar(?)
        - colocar NOT NULLS, UNIQUES, AUTO INCREMENTAVEL, default nos emails(?) e ver o que é o check
*/
-- criar as tabelas com chaves primárias e foreign keys 
CREATE TABLE racas (
    raca_id INT,
    raca VARCHAR(45),
    descricao TEXT,
    PRIMARY KEY (raca_id) -- prof ensinou
);

CREATE TABLE caes (
    cao_id INT PRIMARY KEY, -- vitor perguntou assim 
    raca_id INT,
    nome VARCHAR(50),
    data_nascimento DATE,
    porte CHAR,
    data_entrada DATETIME,
    foto BLOB, -- descobrir como usar o BLOB e fazer tabela peso(?)
    FOREIGN KEY (raca_id) REFERENCES racas(raca_id)
);

CREATE TABLE apadrinhamentos (
    apadrinhamento_id INT PRIMARY KEY,
    cao_id INT,
    padrinho_nome VARCHAR(50),
    data_inicio DATETIME,
    data_fim DATETIME,
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id)
);

CREATE TABLE funcionarios (
    funcionario_id INT PRIMARY KEY,
    nome VARCHAR(50),
    ocupacao VARCHAR(45),
    email VARCHAR(50),
    telemovel VARCHAR(13) -- acrescentar mais dados tipo NIF ou CC
);

CREATE TABLE voluntarios (
    voluntario_id INT PRIMARY KEY,
    nome VARCHAR(50),
    data_nascimento DATE,
    email VARCHAR(50),
    telemovel VARCHAR(13),
    disponibilidade ENUM('Sabado: 9h-12h', 'Domingo: 9h-12h', 'Feriado: 9h-12', 'Fim-de-Semana', 'Todos') -- melhorar
);

CREATE TABLE boxes (
    box_id INT, -- posso fazer sem chave primária? ou faço um id so para ter chave primaria? 
    cao_id INT,
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id)
);

CREATE TABLE consultas_veterinario (
    consulta_id INT PRIMARY KEY,
    cao_id INT,
    funcionario_id INT,
    data_consulta DATETIME,
    custo DECIMAL(8,2),
    observacao TEXT,
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(funcionario_id)
);

CREATE TABLE vacinas (
    vacina_id INT PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE vacinacoes (
    vacinacao_id INT PRIMARY KEY,
    cao_id INT,
    funcionario_id INT,
    vacina_id INT,
    data_vacinacao Date, -- mete-se a proxima data? 
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(funcionario_id),
    FOREIGN KEY (vacina_id) REFERENCES vacinas(vacina_id)
);

CREATE TABLE ocorrencias_animal_pessoa ( -- melhorar
    ocorrencia_pessoa_id INT PRIMARY KEY,
    cao_id INT,
    voluntario_id INT,
    data_ocorrencia DATE,
    descricao TEXT,
    seguro_ativado TINYINT(1), -- CHAR OU BOOL ?
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id),
    FOREIGN KEY (voluntario_id) REFERENCES voluntarios(voluntario_id)
);

CREATE TABLE ocorrencias_animais ( -- melhorar
    ocorrencia_id INT PRIMARY KEY,
    cao_id INT,
    cao_id2 INT, -- ver outro id
    data_ocorrencia DATE,
    descricao TEXT,
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id),
    FOREIGN KEY (cao_id2) REFERENCES caes(cao_id)
);

CREATE TABLE ordem_tribunal (
    ordem_id INT PRIMARY KEY,
    cao_id INT,
    observacao TEXT,
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id)
);

CREATE TABLE familia_adotantes ( -- talvez um campo observaçao (?) 
    familia_id INT PRIMARY KEY,
    nome VARCHAR(50),
    email VARCHAR(50),
    telemovel VARCHAR(13)
);

CREATE TABLE adocoes (
    adopcao_id INT PRIMARY KEY,
    cao_id INT,
    familia_id INT,
    data_adocao DATE,
    estado ENUM('Concluída', 'Cancelada', 'A decorrer'),
    FOREIGN KEY (cao_id) REFERENCES caes(cao_id),
    FOREIGN KEY (familia_id) REFERENCES familia_adotantes(familia_id)
);

CREATE TABLE doacoes (
    doacao_id INT PRIMARY KEY,
    nome_doador VARCHAR(50),
    funcionario_id INT,
    data_doacao DATE,
    tipo_doacao ENUM('Monetária', 'Bens ou Comida'),
    valor DECIMAL(6,2),
    descricao TEXT,
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(funcionario_id)
);