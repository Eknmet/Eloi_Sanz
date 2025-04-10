select *
From transaction
join company on transaction.company_id = company.id;

select *
from transaction;

select *
from company;

-- Nivell 1
-- Exercici 2
-- Llistat dels països que estan fent compres.


select company.country 
From transaction
join company on transaction.company_id = company.id
group by company.country
order by 1 desc;

-- Des de quants països es realitzen les compres.

-- em retorna la llista de tots els paisos on es fan les compres
-- no el numero total maxim de paisos 

-- Els paisos on es realitzen les compres
select count(distinct company.country) cuentapais
From transaction 
join company on transaction.company_id = company.id;


-- Els paisos que estan per sobre de la mitjana segons la cantitat de venda

select distinct company.country
from transaction
join company on transaction.company_id = company.id
where amount >= (
select avg(amount)
from transaction)
;

-- Identifica la companyia amb la mitjana més gran de vendes.

select company_name, avg(amount) as monto, company_id
from transaction
join company on transaction.company_id = company.id
group by company_id
order by monto desc
limit 1;

-- Exercici 3
--  sense utilitzar JOIN
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.

select * 
from transaction
where company_id in (
select id
from company
where country = 'Germany')
order by 3 desc;

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
select company_name
from company
where id in (
			select distinct company_id
			from transaction
				where amount >=(
								select avg(amount)
								from transaction)
);

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

select *
from company;
-- Agrego una empresa que no tindra cap transaccio per comprobar l'exercici.
insert into company values(
"A_eliminar","jajaHarvard", 123, "jajaharvard@quelistossomos.com","Deaqui_ialla","https://Jajaharvard.com"
);

-- La resposta
select id 
from company
where not exists (
select distinct company_id
from transaction 
where company_id = company.id);

Delete 
from company
where not exists (
select distinct company_id
from transaction 
where company_id = company.id);

-- Nivell 2
-- Ej 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes.
-- Mostra la data de cada transacció juntament amb el total de les vendes.

select distinct company_id 
from transaction;
select date_format(timestamp, '%y-%m-%d') as Fecha,  sum(amount) as total
from transaction
group by Fecha
order by total desc
limit 5;

-- Ej 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
select company.country, avg(amount) promedio
from transaction
join company on transaction.company_id = company.id
group by company.country
order by 2 desc;

-- EJ 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
-- Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
-- Mostra el llistat aplicant JOIN i subconsultes.
select transaction.*, company.country
from company
join transaction on transaction.company_id = company.id
where country in
				(select country
				from company
				where company_name like 'Non Institute');

-- Mostra el llistat aplicant solament subconsultes.
select *
from transaction
where transaction.company_id in (
	select id
	from company
	where country in (
	select country
	from company
	where company_name like 'Non Institute'));

-- Nivell 3
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb 
-- un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates:
-- 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.

select company.company_name, company.phone, company.country, transaction.timestamp, transaction.amount
from transaction
join company on transaction.company_id = company.id
where (amount between 100 and 200) and timestamp like '2021-04-29 %' or timestamp like '2021-07-20 %' or timestamp like '2022-03-13 %';

-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
-- per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses,
-- però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.

select company_id, count(id) ,
case 
	when count(id) > 4 then " Mes de 4 transaccions"
    when count(id) = 4 then " Tenen 4 transacions"
    else "Menys de 4 transaccions"
end as mes_menys_4
from transaction
group by company_id
order by 2 desc;