
CREATE FUNCTION index_page(relname text, pageno integer) RETURNS TABLE(itemoffset smallint, htid tid, dead boolean) AS $$
SELECT itemoffset,
htid,
dead 
FROM bt_page_items(relname,pageno); $$ LANGUAGE sql;