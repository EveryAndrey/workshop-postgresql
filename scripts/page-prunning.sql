drop table page_prunning; 
create table page_prunning (
    id integer,
    name char(2000)
) with (fillfactor = 75);


-- добавляем данные, чтобы достичь fill factor
insert into page_prunning values ('1', 'A');

update page_prunning set name = 'B';
update page_prunning set name = 'C';
update page_prunning set name = 'D';


SELECT * FROM heap_page('page_prunning',0);

-- данные будут удалены после операции update
update page_prunning set name = 'E';
SELECT * FROM heap_page('page_prunning',0);

