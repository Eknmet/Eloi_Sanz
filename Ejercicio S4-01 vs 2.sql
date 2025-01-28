create schema trans4;
use trans4;

SHOW GLOBAL VARIABLES LIKE 'local_infile'; 
set global local_infile = 1;

 drop table transactions;

create table transactions(
id varchar(255) primary key,
credit_card_id varchar(15), -- constraint FK_credit foreign key (credit_card_id) references credit_cars(id),
company_id varchar(20), -- constraint FK_nom_company foreign key (company_id) references company(id),
timestamp varchar(50),
amount decimal(6,2),
declined tinyint(1),
product_ids varchar(20),
user_id varchar(100), -- constraint FK_user foreign key(user_id) references users(id),
lat varchar(50),
longitude varchar(50)
);

select *
from transactions;

load data local infile "C:/Users/Eloi/Documents/ITAcademy/Especialitzacio Data Analyst/S4-01/transactions.csv"
into table transactions
fields terminated by ";"
enclosed by '"'
ignore 1 rows;

-- drop table company;

create table if not exists company(
id varchar(20) primary key,
company_name varchar(255),
phone varchar(15),
email varchar(100),
country varchar(100),
website varchar(100)
);

select *
from company;

load data local infile "C:/Users/Eloi/Documents/ITAcademy/Especialitzacio Data Analyst/S4-01/companies.csv"
into table company
fields terminated by ","
enclosed by '"'
ignore 1 rows;

-- drop table credit_cards;

create table if not exists credit_cards(
id varchar(15) primary key,
user_id varchar(50),
iban varchar(50),
pan varchar(20),
pin varchar(4),
cvv varchar(3),
track1 varchar(200),
track2 varchar(200),
expiring_data varchar(20)
);

select *
from credit_cards;

load data local infile "C:/Users/Eloi/Documents/ITAcademy/Especialitzacio Data Analyst/S4-01/credit_cards.csv"
into table credit_cars
fields terminated by ","
enclosed by '"'
ignore 1 rows;


-- drop table users;

create table if not exists users(
id varchar(100)primary key,
name varchar(100),
surname varchar(100),
phone varchar(100),
email varchar(100),
birth_date varchar(100),
country varchar(100),
city varchar(100),
postal_code varchar(100),
address varchar(255)
);


select *
from users;

-- delete from users 
-- where name is null;

select *
from users
order by id;

load data local infile "C:/Users/Eloi/Documents/ITAcademy/Especialitzacio Data Analyst/S4-01/users_usa.csv"
into table users
fields terminated by ","
enclosed by '"'
lines terminated by "\r"
ignore 1 rows;

load data local infile "C:/Users/Eloi/Documents/ITAcademy/Especialitzacio Data Analyst/S4-01/users_uk.csv"
into table users
fields terminated by ","
enclosed by '"'
lines terminated by "\r"
ignore 1 rows;

load data local infile "C:/Users/Eloi/Documents/ITAcademy/Especialitzacio Data Analyst/S4-01/users_ca.csv"
into table users
fields terminated by ","
enclosed by '"'
lines terminated by "\r"
ignore 1 rows;


-- Es poden crear les primary key despres de crear la taula, o pots tornar a carregar les dades amb la taula modificada
alter table users 
add primary key (id);

-- hay diferentes modos de ver las relaciones de las tablas i las fk pk que existen

-- show global variables like 'foreign key';

-- set foreign_key_checks=0;
-- set foreign_key_checks=1;


alter table transactions
add constraint FK_users foreign key (user_id) references users(id);

alter table transactions
add constraint FK_companyes foreign key (company_id) references company(id);

alter table transactions
add constraint FK_credit_card foreign key (credit_card_id) references credit_cards(id);
-- show create table transactions;

select *
from transactions;

describe transactions;
describe users;
describe company;
describe credit_cars;

select *
from users;

-- show foreign key from transactions;

-- SHOW GLOBAL VARIABLES LIKE 'local_infile'; 
-- set global local_infile = 0;

-- Nivell 1 Exercici 1

select u.name, u.surname
from users u
where u.id in (
select t.user_id
from transactions t
group by t.user_id
having (count(t.id) > 30));


-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

select avg(amount) , cc.iban, c.company_name
from transactions t
join company c on c.id=t.company_id
join credit_cards cc on t.credit_card_id =cc.id
where c.company_name = "Donec Ltd"
group by cc.iban, c.company_name;


-- Nivell 2
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en
--  si les últimes tres transaccions van ser declinades i genera la següent consulta:

create table if not exists estat_targetes as
select *
from (
select credit_card_id, declined,
row_number() over(partition by credit_card_id, declined
order by timestamp desc) numero
From transactions )t;

select * from estat_targetes;

select numero, count(credit_card_id),
case 
when declined = 1 and numero = 3 then "targeta inactiva"
else "targeta activa"
end as Estat
from estat_targetes
group by numero, declined, estat;

select *
from transactions;

-- es poden generar diferents consultes otilitzan el row number
-- select *,
-- row_number() over (partition by user_id) as cantitat_transaccions
-- from transactions
-- order by user_id;

-- trato de hacer el ejercicio 3 despues de unos dias batallando con el inicio i reaciendolo todo de nuevo unas tantas vezes quiero cerrar esta etapa.


-- Nivell 3
-- volem crear una taula que ens reflecteixi els id de cada transaccio amb els productes comprats
-- aquesta l'otilitzarem per unir la taula de productes amb la de transaccions
-- ja que tindra els id de les dues taules.
-- necesitem separar els productes per comes duna columne


-- intentos diversos del ejercicio, sin exito final.
select *
from transactions;
cross apply string_split(Tags, ',');

select 
-- cast(trim
substring_index(substring_index(product_ids, ",",1),",",-1)) as primera_pos)
from transactions;

create table if not exists pro
select substring_index(product_ids, ",",1) as product
from transactions;
where product is not null
;

select *
from pro
where product is not null;

select 
-- cast(substring(product_ids, 1, locate(',' , product_ids)-1 as unsigned) as valor1
from transactions;