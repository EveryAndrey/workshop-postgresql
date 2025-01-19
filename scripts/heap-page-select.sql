SELECT '(0,'||lp||')' AS ctid, 
CASE lp_flags
 WHEN 0 THEN 'unused'
 WHEN 1 THEN 'normal'
 WHEN 2 THEN 'redirect to '||lp_off 
 WHEN 3 THEN 'dead'
END AS state,
t_xmin as xmin,
t_xmax as xmax,
(t_infomask & 256) > 0 AS xmin_committed, 
(t_infomask & 512) > 0 AS xmin_aborted, 
(t_infomask & 1024) > 0 AS xmax_committed, 
(t_infomask & 2048) > 0 AS xmax_aborted
FROM heap_page_items(get_raw_page('positions',0))