WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
, cte AS (
	SELECT
		query_plan.query_plan,
		OBJECT_SCHEMA_NAME(ps.object_id) + '.' + OBJECT_NAME(ps.object_id) proc_name
	FROM	sys.dm_exec_procedure_stats ps
		CROSS APPLY sys.dm_exec_query_plan(ps.plan_handle) query_plan
	WHERE OBJECT_NAME(ps.object_id) IS NOT NULL AND query_plan.query_plan IS NOT NULL
),
relop AS (
	SELECT
		c.proc_name,
		x.value('@StatementId', 'INT') StatementId,
		x.value('@StatementCompId', 'INT') StatementCompId,
		x.value('@QueryHash', 'varchar(16)') QueryHash,
		x.value('@QueryPlanHash', 'varchar(16)') QueryPlanHash,
		0 lvl,
		s.value('@NodeId', 'INT') ParentNodeId,
		s.value('@NodeId', 'INT') NodeId,
		s.value('@PhysicalOp', 'nvarchar(256)') PhysicalOp,
		s.value('@LogicalOp', 'nvarchar(256)') LogicalOp,
		s.value('@EstimateIO', 'FLOAT') EstimateIO,
		s.value('@EstimateCPU', 'FLOAT') EstimateCPU,
		s.value('@EstimatedTotalSubtreeCost', 'FLOAT') EstimatedTotalSubtreeCost,
		o.value('@Database', 'NVARCHAR(128)') db,
		o.value('@Schema', 'NVARCHAR(128)') sch,
		o.value('@Table', 'NVARCHAR(128)') tab,
		s.query('child::*/xs:RelOp') xsRelOp
	FROM	cte c
		CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(x)
		OUTER APPLY x.nodes('xs:QueryPlan/xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
	UNION ALL
	SELECT
		r.proc_name,
		r.StatementId,
		r.StatementCompId,
		r.QueryHash,
		r.QueryPlanHash,
		r.lvl + 1 lvl,
		r.NodeId ParentNodeId,
		s.value('@NodeId', 'INT') NodeId,
		s.value('@PhysicalOp', 'nvarchar(256)') PhysicalOp,
		s.value('@LogicalOp', 'nvarchar(256)') LogicalOp,
		s.value('@EstimateIO', 'FLOAT') EstimateIO,
		s.value('@EstimateCPU', 'FLOAT') EstimateCPU,
		s.value('@EstimatedTotalSubtreeCost', 'FLOAT') EstimatedTotalSubtreeCost,
		o.value('@Database', 'NVARCHAR(128)') db,
		o.value('@Schema', 'NVARCHAR(128)') sch,
		o.value('@Table', 'NVARCHAR(128)') tab,
		s.query('child::*/xs:RelOp') xsRelOp
	FROM	relop r
		CROSS APPLY r.xsRelOp.nodes('xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
)
SELECT	DISTINCT
	r.proc_name,
	IIF(CHARINDEX('Seek', r.LogicalOp) > 0 OR CHARINDEX('Scan', r.LogicalOp) > 0, 'Select', r.LogicalOp) LogicalOp,
	r.db,r.sch,r.tab
FROM	relop r
WHERE r.db IS NOT NULL
OPTION(MAXRECURSION 0);
