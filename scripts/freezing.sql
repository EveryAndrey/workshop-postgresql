CREATE OR REPLACE FUNCTION public.heap_page_freez(relname text, pageno_from integer, pageno_to integer)
 RETURNS TABLE(ctid tid, state text, xmin text, xmin_age integer, xmax text)
 LANGUAGE sql
AS $function$
SELECT
(pageno,lp)::text::tid AS ctid, CASE lp_flags
WHEN 0 THEN 'unused' WHEN 1 THEN 'normal' WHEN 2 THEN 'redirect to '||lp_off WHEN 3 THEN 'dead'
END AS state, 
t_xmin || CASE
WHEN (t_infomask & 256+512) = 256+512 THEN ' f'
WHEN (t_infomask & 256) > 0THEN ' c' 
WHEN (t_infomask & 512) > 0 THEN ' a' 
ELSE ''
END AS xmin, 
age(t_xmin) AS xmin_age, 
t_xmax || CASE
WHEN (t_infomask & 1024) > 0 THEN ' c' WHEN (t_infomask & 2048) > 0 THEN ' a' ELSE ''
END AS xmax
FROM generate_series(pageno_from, pageno_to) p(pageno),
heap_page_items(get_raw_page(relname, pageno)) ORDER BY pageno, lp;
$function$
;

drop table tfreeze;


CREATE TABLE tfreeze( 
    id integer,
    s char(300))
WITH (fillfactor = 10, autovacuum_enabled = off);

CREATE EXTENSION IF NOT EXISTS pg_visibility;



