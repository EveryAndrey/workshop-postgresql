-- очищаем таблицу
TRUNCATE vac;

-- добавляем 500 000 записей
INSERT INTO vac(id,s)
SELECT id, id::text FROM generate_series(1,500000) id;


CREATE EXTENSION pgstattuple;

-- смотрим распределение данных в таблице
select * FROM pgstattuple('vac') 

-- смотрим распределение данных в индексе
SELECT * FROM pgstatindex('vac_s')

-- размеры таблиц
SELECT pg_size_pretty(pg_table_size('vac')) AS table_size, pg_size_pretty(pg_indexes_size('vac')) AS index_size;

-- удаляем 90 процентов записей
DELETE FROM vac WHERE id % 10 != 0;


VACUUM vac;

-- смотрим, что размер таблиц не поменялся
SELECT 
	pg_size_pretty(pg_table_size('vac')) AS table_size, 
	pg_size_pretty(pg_indexes_size('vac')) AS index_size;

-- смотрим, что плотность данных ухудшилась
SELECT vac.tuple_percent, vac_s.avg_leaf_density FROM pgstattuple('vac') vac, pgstatindex('vac_s') vac_s;


-- смотрим название файлов
SELECT pg_relation_filepath('vac') AS vac_filepath, pg_relation_filepath('vac_s') AS vac_s_filepath;


VACUUM FULL vac;


-- файлы заменены новыми
SELECT pg_relation_filepath('vac') AS vac_filepath, pg_relation_filepath('vac_s') AS vac_s_filepath;


-- размер файлов уменьшился
SELECT 
	pg_size_pretty(pg_table_size('vac')) AS table_size, 
	pg_size_pretty(pg_indexes_size('vac')) AS index_size;

-- смотрим плотность данных
SELECT vac.tuple_percent, vac_s.avg_leaf_density FROM pgstattuple('vac') vac, pgstatindex('vac_s') vac_s;

