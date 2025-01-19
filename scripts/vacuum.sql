create table vac(
id integer,
s char(100)
) with(autovacuum_enabled = off);


CREATE INDEX vac_s ON vac(s);

insert into vac(id,s) values (1, 'A');
update vac set s = 'B';
update vac set s = 'C';

select * from heap_page('vac', 0);

select * from index_page('vac_s', 1)

vacuum vac;


select * from heap_page('vac', 0);

select * from index_page('vac_s', 1)


-- DATABASE HORIZON CHECK
TRUNCATE vac;
insert into vac(id,s) values (1, 'A');
update vac set s = 'B';

-- open another transaction
BEGIN;
UPDATE positions SET amount = 0;
--

update vac set s = 'C';
vacuum verbose vac;

select * from heap_page('vac', 0);
select * from index_page('vac_s', 1);

--
commit;
--

vacuum verbose vac;

select * from heap_page('vac', 0);
select * from index_page('vac_s', 1);
