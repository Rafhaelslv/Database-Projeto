+USE master
DROP DATABASE PROJETO
CREATE DATABASE PROJETO
USE PROJETO
GO
CREATE TABLE PROJECTS (
id_projects				INT				NOT NULL IDENTITY (10001, 1),
nome					VARCHAR(45)		NOT NULL,
descricao				VARCHAR(45)		NULL,
datinha					DATE			NOT NULL CHECK(datinha > '01/09/2014'),
PRIMARY KEY (id_projects)
)
GO
CREATE TABLE USERS (
id_users				INT				NOT NULL IDENTITY (1, 1),
nome					VARCHAR(45)		NOT NULL,
usuario					VARCHAR(45)		NOT NULL UNIQUE,
senha					VARCHAR(45)		NOT NULL DEFAULT ('123mudar'),
email					VARCHAR(45)		NOT NULL,
PRIMARY KEY (id_users)
)
GO
CREATE TABLE PROJECTS_USERS (
users_id				INT				NOT NULL,
projects_id				INT				NOT NULL,
FOREIGN KEY (users_id) REFERENCES USERS (id_users),
FOREIGN KEY (projects_id) REFERENCES PROJECTS (id_projects),
PRIMARY KEY (users_id, projects_id)
)
GO

ALTER TABLE USERS
DROP CONSTRAINT UQ__USERS__9AFF8FC60ECE65BB;

ALTER TABLE USERS
ALTER COLUMN usuario VARCHAR(10) NOT NULL;

ALTER TABLE USERS
ALTER COLUMN senha VARCHAR(8) NOT NULL;

INSERT INTO USERS(nome,usuario, email)
VALUES('Maria' , 'Rh_maria' , 'maria@empresa.com')
GO
INSERT INTO USERS(nome,usuario, senha, email)
VALUES('Paulo' , 'Ti_paulo' , '123@456' , 'paulo@empresa.com')
GO
INSERT INTO USERS(nome,usuario, email)
VALUES('Ana' , 'Rh_ana' , 'ana@empresa.com')
GO
INSERT INTO USERS(nome, usuario, email)
VALUES('Clara' , 'Ti_clara' , 'clara@empresa.com')
GO
INSERT INTO USERS(nome,usuario, senha, email)
VALUES('Aparecido' , 'Rh_apareci' , '55@!cido' , 'aparecido@empresa.com')

INSERT INTO PROJECTS(nome, descricao, datinha)
VALUES ('Re-folha' , 'Refatoração das Folhas' , '05/09/2014')
GO
INSERT INTO PROJECTS(nome, descricao, datinha)
VALUES ('Manutenção PC' , 'Manutenção PC' , '06/09/2014')
GO
INSERT INTO PROJECTS(nome, descricao ,datinha)
VALUES('Auditoria' , NULL , '07/09/2014')
GO

INSERT INTO PROJECTS_USERS(users_id, projects_id)
VALUES('1' , '10001')
GO
INSERT INTO PROJECTS_USERS(users_id, projects_id)
VALUES('5' , '10001')
GO
INSERT INTO PROJECTS_USERS(users_id, projects_id)
VALUES('3' , '10003')
GO
INSERT INTO PROJECTS_USERS(users_id, projects_id)
VALUES('4' , '10002')
GO
INSERT INTO PROJECTS_USERS(users_id, projects_id)
VALUES('2' , '10002')
GO

Update PROJECTS
set datinha='12-09-2014'
where nome LIKE 'Manutençao%'

UPDATE USERS
set usuario= 'RH_cido'
where nome like 'Aparecido'

Update USERS
set SENHA= '888@*'
where nome like 'Maria' and usuario='Rh_maria' and senha='123mudar'

DELETE PROJECTS_USERS WHERE users_id = 2 AND projects_id = 10002

SELECT id_users,
	   nome,
       email,
       usuario,
CASE
       WHEN senha = '123mudar' THEN senha
       ELSE REPLICATE('*', 8) + SUBSTRING(senha, 9, LEN(senha))
        END AS senha FROM USERS;


SELECT 
	p.nome,
	p.descricao, 
	CONVERT(VARCHAR, p.datinha, 103), 
	CONVERT(VARCHAR, (DATEADD(DAY, 15, p.datinha)), 103) AS final_date,
		u.email
	FROM projects AS p
	INNER JOIN PROJECTS_USERS AS pu ON p.id_projects = pu.projects_id
	INNER JOIN USERS AS u ON pu.users_id = u.id_users 
	WHERE p.id_projects = 10001 AND u.email  = 'aparecido@empresa.com';


SELECT u.nome, u.email
FROM USERS AS u
INNER JOIN PROJECTS_USERS AS pu ON u.id_users = pu.users_id 
INNER JOIN projects AS p ON pu.projects_id = p.id_projects 
WHERE p.nome = 'Auditoria'


SELECT p.nome, p.descricao, 
CONVERT(VARCHAR, p.datinha, 103), 
'16/09/2014' AS final_date,
DATEDIFF(DAY, p.datinha, '2014-09-16') * 79.85 AS total_cost
FROM PROJECTS AS p 
WHERE p.nome LIKE 'Manutenção%'