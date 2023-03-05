INSERT	cached_plans(bucketid, refcounts, usecounts, size_in_bytes, cacheobjtype, objtype, query_plan, objectid, dbid)
SELECT
	cp.bucketid,
	cp.refcounts,
	cp.usecounts,
	cp.size_in_bytes,
	cp.cacheobjtype,
	cp.objtype,
	qp.query_plan,
	qp.objectid,
	qp.dbid
FROM	sys.dm_exec_cached_plans cp
	CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
WHERE qp.query_plan IS NOT NULL;

