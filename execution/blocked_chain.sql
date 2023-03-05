
WITH 
req AS (SELECT
	r.session_id,
	r.request_id,
	r.start_time,
	r.status,
	r.command,
	r.sql_handle,
	r.statement_start_offset,
	r.statement_end_offset,
	r.database_id,
	r.blocking_session_id,
	r.wait_type,
	r.wait_time,
	r.last_wait_type,
	r.wait_resource,
	r.open_transaction_count,
	r.open_resultset_count,
	r.transaction_id,
	r.percent_complete,
	r.estimated_completion_time,
	r.cpu_time,
	r.total_elapsed_time,
	r.scheduler_id,
	r.task_address,
	r.reads,
	r.writes,
	r.logical_reads,
	r.transaction_isolation_level,
	r.row_count,
	r.granted_query_memory,
	r.query_hash,
	r.query_plan_hash,
	r.statement_sql_handle
FROM	sys.dm_exec_requests r),
chain AS (
	SELECT
		session_id,
		blocking_session_id,
		blocking_session_id chain_blocking_session_id,
		FORMAT(blocking_session_id, '0') + ' > ' + FORMAT(session_id, '0') chain
	FROM	req
	WHERE blocking_session_id <> 0
	UNION ALL
	SELECT
		b.session_id,
		r.blocking_session_id,
		r.blocking_session_id ,
		FORMAT(r.blocking_session_id, '0') + ' > ' + b.chain
	FROM	req r
		JOIN chain b ON b.blocking_session_id = r.session_id
	WHERE r.blocking_session_id <> 0 AND b.session_id <> r.session_id
),
blocked AS (SELECT chain.session_id, chain.chain blocked_chain,  chain.chain_blocking_session_id, ROW_NUMBER() OVER (PARTITION BY chain.session_id ORDER BY LEN(chain.chain) DESC) r FROM		chain)
SELECT blocked.session_id, blocked.blocked_chain, chain_blocking_session_id FROM		blocked WHERE blocked.r = 1
OPTION(MAXRECURSION 0);





WITH 
req AS (SELECT
	r.session_id,
	r.request_id,
	r.start_time,
	r.status,
	r.command,
	r.sql_handle,
	r.statement_start_offset,
	r.statement_end_offset,
	r.database_id,
	r.blocking_session_id,
	r.wait_type,
	r.wait_time,
	r.last_wait_type,
	r.wait_resource,
	r.open_transaction_count,
	r.open_resultset_count,
	r.transaction_id,
	r.percent_complete,
	r.estimated_completion_time,
	r.cpu_time,
	r.total_elapsed_time,
	r.scheduler_id,
	r.task_address,
	r.reads,
	r.writes,
	r.logical_reads,
	r.transaction_isolation_level,
	r.row_count,
	r.granted_query_memory,
	r.query_hash,
	r.query_plan_hash,
	r.statement_sql_handle
FROM	sys.dm_exec_requests r), chain AS (
	SELECT
		session_id,
		blocking_session_id,
		FORMAT(session_id, '0')  + ' < ' + FORMAT(blocking_session_id, '0') chain
	FROM	req
	WHERE blocking_session_id <> 0
	UNION ALL
	SELECT
		b.session_id,
		r.blocking_session_id,
		b.chain + ' < ' + FORMAT(r.blocking_session_id, '0') 
	FROM	req r
		JOIN chain b ON b.blocking_session_id = r.session_id
	WHERE r.blocking_session_id <> 0 AND b.session_id <> r.session_id
),
blocked AS (SELECT chain.session_id, chain.chain blocked_chain, ROW_NUMBER() OVER (PARTITION BY chain.session_id ORDER BY LEN(chain.chain) DESC) r FROM		chain)
SELECT blocked.session_id, blocked.blocked_chain FROM		blocked WHERE blocked.r = 1
OPTION(MAXRECURSION 0);