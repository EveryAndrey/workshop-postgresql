create function heap_page(relname text, 
pageno integer) returns table(ctid tid,
state text,
xmin text,
xmax text) as $$
select
	(pageno,
	lp)::text::tid as ctid,
case lp_flags 
	when 0 then 'unused'
	when 1 then 'normal'
	when 2 then 'redirect to ' || lp_off 
	when 3 then 'dead'
	end as state,
t_xmin || case
	
when (t_infomask & 256) > 0 then ' c'
		when (t_infomask & 512) > 0 then ' a'
		else ''
	end as xmin,
	t_xmax || case
		when (t_infomask & 1024) > 0 then ' c'
		when (t_infomask & 2048) > 0 then ' a'
		else ''
	end as xmax
from
	heap_page_items(get_raw_page(relname,
	pageno))
order by
	lp;
$$ LANGUAGE sql;

