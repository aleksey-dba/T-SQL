DECLARE @copy_query_store_plans NVARCHAR(MAX) = N'';
SELECT	@copy_query_store_plans += REPLACE('
INSERT query_store_query_plan (database_id, plan_id, query_plan)
SELECT DB_ID(''@name'') database_id, qsp.plan_id, CONVERT(XML, qsp.query_plan) query_plan
FROM [@name].sys.query_store_plan qsp
WHERE NOT EXISTS (SELECT * FROM	query_store_query_plan WHERE database_id = DB_ID(''@name'') AND plan_id = qsp.plan_id);
', '@name', name)
FROM	sys.databases
WHERE state = 0 AND is_read_only = 0 AND user_access = 0 AND is_query_store_on = 1 AND database_id > 4;
PRINT @copy_query_store_plans;