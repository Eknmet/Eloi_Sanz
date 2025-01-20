-- Nivell 1

CREATE TABLE if not exists credit_card
 (id varchar (20) PRIMARY KEY,
 iban varchar (50) NOT NULL,
pan varchar (50),
pin varchar (4),
cvv INTEGER ,
expiring_date varchar(20)
)
;
-- Estava probant diferents formats de columnes ...
-- drop table credit_card;

select *
from credit_card;

-- Exercici 2 
-- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938.
-- La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

select *
from credit_card
where id like "CcU-2938";

update credit_card
set iban = "R323456312213576817699999"
where id like "CcU-2938";

-- En la taula "transaction" ingressa un nou usuari amb la següent informació:

insert into credit_card values(
"CcU-9999","TR301950312213576817638661",null,null,null,null
);
insert into company values(
"b-9999",null,null,null,null,null);

-- una altre forma dingresar dades
insert into company (id) values ('b-999');

insert into transaction values(
"108B1D1D-5B23-A76C-55EF-C568E49A99DD","CcU-9999","b-9999","9999","829.999","-117.999","2025-01-16 11:58:30","111.11","0");

-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.

select *
from credit_card;

alter table credit_card drop pan;

-- drop colum , ja que podria confondres amb una linea que es digues igual
-- drop row

-- Nivell 2

select *
from transaction
where id like "02C6201E-D90A-1859-B4EE-88D2986D3B02" ;

Delete 
from transaction
where id like "02C6201E-D90A-1859-B4EE-88D2986D3B02" ;

-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia.
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

-- drop view VistaMarketing;
select *
from user;

create view VistaMarketing as
select c.company_name,c.phone,c.country,round(avg(t.amount), 2) media
from company c
join transaction t on c.id = t.company_id
group by c.company_name,c.phone,c.country
order by media desc;

-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

select *
from VistaMarketing
where country = "Germany";

-- nivell 3
-- Elimino la relaccio existen entre les taules
Alter table user
drop foreign key user_ibfk_1;

-- desactivo el set, que desactive les restriccions de foraney key
set foreign_key_checks = 0;

-- creo la relacio entre les taules
alter table transaction
add constraint  fk_user_id foreign key (user_id) references user(id);

-- activo el set, amb les relacions entre taules
set foreign_key_checks = 1;

-- creo relacio entre credit card i transaction

alter table transaction
add constraint  fk_credit_card_id foreign key(credit_card_id) references credit_card (id);

-- eliminem la columna de website de la taula company
alter table company
drop column website;

-- actualizo la columna fecha con valores requeridos
alter table credit_card
drop column fecha;

alter table credit_card
add fecha_actual date;

-- cambiar nombre de columna

alter table user
change email personal_email varchar (150);

rename table user to data_user;


select *
from credit_card;

select *
from data_user;

select *
from transaction;

select *
from credit_card;


create view InformeTecnico as
select t.id transaccio_id,t.amount, u.name, u.surname,u.phone, c.iban iban_tarjeta, y.company_name
from transaction t 
join user u on  t.user_id = u.id
join credit_card c on c.id = t.credit_card_id
join company y on y.id = t.company_id
order by t.id desc;

select *
from informetecnico;

select *
from transaction;
select *
from credit_card;
select *
from company;
