WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
, relop AS (
	SELECT
		c.database_id,
		c.plan_id,
		x.value('@StatementId', 'INT') StatementId,
		x.value('@StatementCompId', 'INT') StatementCompId,
		x.value('@QueryHash', 'varchar(16)') QueryHash,
		x.value('@QueryPlanHash', 'varchar(16)') QueryPlanHash,
		0 lvl,
		s.value('@NodeId', 'INT') ParentNodeId,
		s.value('@NodeId', 'INT') NodeId,
		s.value('@PhysicalOp', 'nvarchar(256)') PhysicalOp,
		s.value('@LogicalOp', 'nvarchar(256)') LogicalOp,
		s.value('@EstimateRows', 'FLOAT') EstimateRows,
		s.value('@EstimatedRowsRead', 'FLOAT') EstimatedRowsRead,
		s.value('@EstimateIO', 'FLOAT') EstimateIO,
		s.value('@EstimateCPU', 'FLOAT') EstimateCPU,
		s.value('@AvgRowSize', 'FLOAT') AvgRowSize,
		s.value('@EstimatedTotalSubtreeCost', 'FLOAT') EstimatedTotalSubtreeCost,
		s.value('@TableCardinality', 'FLOAT') TableCardinality,
		s.value('@Parallel', 'INT') Parallel,
		s.value('@EstimateRebinds', 'FLOAT') EstimateRebinds,
		s.value('@EstimateRewinds', 'FLOAT') EstimateRewinds,
		s.value('@EstimatedExecutionMode', 'NVARCHAR(128)') EstimatedExecutionMode,
		o.value('@Database', 'NVARCHAR(128)') db,
		o.value('@Schema', 'NVARCHAR(128)') sch,
		o.value('@Table', 'NVARCHAR(128)') tab,
		o.value('@Index', 'NVARCHAR(128)') idx,
		o.value('@Alias', 'NVARCHAR(128)') alias,
		o.value('@IndexKind', 'NVARCHAR(128)') IndexKind,
		o.value('@Storage', 'NVARCHAR(128)') Storage,
		s.query('child::*/xs:RelOp') xsRelOp
	FROM	query_store_query_plan c
		CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(x)
		OUTER APPLY x.nodes('xs:QueryPlan/xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
	UNION ALL
	SELECT
		r.database_id,
		r.plan_id,
		r.StatementId,
		r.StatementCompId,
		r.QueryHash,
		r.QueryPlanHash,
		r.lvl + 1 lvl,
		r.NodeId,
		s.value('@NodeId', 'INT') NodeId,
		s.value('@PhysicalOp', 'nvarchar(256)') PhysicalOp,
		s.value('@LogicalOp', 'nvarchar(256)') LogicalOp,
		s.value('@EstimateRows', 'FLOAT') EstimateRows,
		s.value('@EstimatedRowsRead', 'FLOAT') EstimatedRowsRead,
		s.value('@EstimateIO', 'FLOAT') EstimateIO,
		s.value('@EstimateCPU', 'FLOAT') EstimateCPU,
		s.value('@AvgRowSize', 'FLOAT') AvgRowSize,
		s.value('@EstimatedTotalSubtreeCost', 'FLOAT') EstimatedTotalSubtreeCost,
		s.value('@TableCardinality', 'FLOAT') TableCardinality,
		s.value('@Parallel', 'INT') Parallel,
		s.value('@EstimateRebinds', 'FLOAT') EstimateRebinds,
		s.value('@EstimateRewinds', 'FLOAT') EstimateRewinds,
		s.value('@EstimatedExecutionMode', 'NVARCHAR(128)') EstimatedExecutionMode,
		o.value('@Database', 'NVARCHAR(128)') db,
		o.value('@Schema', 'NVARCHAR(128)') sch,
		o.value('@Table', 'NVARCHAR(128)') tab,
		o.value('@Index', 'NVARCHAR(128)') idx,
		o.value('@Alias', 'NVARCHAR(128)') alias,
		o.value('@IndexKind', 'NVARCHAR(128)') IndexKind,
		o.value('@Storage', 'NVARCHAR(128)') Storage,
		s.query('child::*/xs:RelOp') xsRelOp
	FROM	relop r
		CROSS APPLY r.xsRelOp.nodes('xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
)
INSERT	query_plan_relop(database_id, plan_id, StatementId, StatementCompId, QueryHash, QueryPlanHash, lvl, ParentNodeId, NodeId, PhysicalOp, LogicalOp, EstimateRows, EstimatedRowsRead, EstimateIO, EstimateCPU, AvgRowSize, EstimatedTotalSubtreeCost, TableCardinality, Parallel, EstimateRebinds, EstimateRewinds, EstimatedExecutionMode, db, sch, tab, idx, alias, IndexKind, Storage)
SELECT DISTINCT
	r.database_id,
	r.plan_id,
	r.StatementId,
	r.StatementCompId,
	r.QueryHash,
	r.QueryPlanHash,
	r.lvl,
	r.ParentNodeId,
	r.NodeId,
	r.PhysicalOp,
	r.LogicalOp,
	r.EstimateRows,
	r.EstimatedRowsRead,
	r.EstimateIO,
	r.EstimateCPU,
	r.AvgRowSize,
	r.EstimatedTotalSubtreeCost,
	r.TableCardinality,
	r.Parallel,
	r.EstimateRebinds,
	r.EstimateRewinds,
	r.EstimatedExecutionMode,
	r.db,
	r.sch,
	r.tab,
	r.idx,
	r.alias,
	r.IndexKind,
	r.Storage
FROM	relop r
OPTION(MAXRECURSION 0);


WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
, relop AS (
	SELECT
		c.dbid database_id,
		NULL plan_id,
		x.value('@StatementId', 'INT') StatementId,
		x.value('@StatementCompId', 'INT') StatementCompId,
		x.value('@QueryHash', 'varchar(16)') QueryHash,
		x.value('@QueryPlanHash', 'varchar(16)') QueryPlanHash,
		0 lvl,
		s.value('@NodeId', 'INT') ParentNodeId,
		s.value('@NodeId', 'INT') NodeId,
		s.value('@PhysicalOp', 'nvarchar(256)') PhysicalOp,
		s.value('@LogicalOp', 'nvarchar(256)') LogicalOp,
		s.value('@EstimateRows', 'FLOAT') EstimateRows,
		s.value('@EstimatedRowsRead', 'FLOAT') EstimatedRowsRead,
		s.value('@EstimateIO', 'FLOAT') EstimateIO,
		s.value('@EstimateCPU', 'FLOAT') EstimateCPU,
		s.value('@AvgRowSize', 'FLOAT') AvgRowSize,
		s.value('@EstimatedTotalSubtreeCost', 'FLOAT') EstimatedTotalSubtreeCost,
		s.value('@TableCardinality', 'FLOAT') TableCardinality,
		s.value('@Parallel', 'INT') Parallel,
		s.value('@EstimateRebinds', 'FLOAT') EstimateRebinds,
		s.value('@EstimateRewinds', 'FLOAT') EstimateRewinds,
		s.value('@EstimatedExecutionMode', 'NVARCHAR(128)') EstimatedExecutionMode,
		o.value('@Database', 'NVARCHAR(128)') db,
		o.value('@Schema', 'NVARCHAR(128)') sch,
		o.value('@Table', 'NVARCHAR(128)') tab,
		o.value('@Index', 'NVARCHAR(128)') idx,
		o.value('@Alias', 'NVARCHAR(128)') alias,
		o.value('@IndexKind', 'NVARCHAR(128)') IndexKind,
		o.value('@Storage', 'NVARCHAR(128)') Storage,
		s.query('child::*/xs:RelOp') xsRelOp
	FROM	cached_plans c
		CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(x)
		OUTER APPLY x.nodes('xs:QueryPlan/xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
	UNION ALL
	SELECT
		r.database_id,
		r.plan_id,
		r.StatementId,
		r.StatementCompId,
		r.QueryHash,
		r.QueryPlanHash,
		r.lvl + 1 lvl,
		r.NodeId,
		s.value('@NodeId', 'INT') NodeId,
		s.value('@PhysicalOp', 'nvarchar(256)') PhysicalOp,
		s.value('@LogicalOp', 'nvarchar(256)') LogicalOp,
		s.value('@EstimateRows', 'FLOAT') EstimateRows,
		s.value('@EstimatedRowsRead', 'FLOAT') EstimatedRowsRead,
		s.value('@EstimateIO', 'FLOAT') EstimateIO,
		s.value('@EstimateCPU', 'FLOAT') EstimateCPU,
		s.value('@AvgRowSize', 'FLOAT') AvgRowSize,
		s.value('@EstimatedTotalSubtreeCost', 'FLOAT') EstimatedTotalSubtreeCost,
		s.value('@TableCardinality', 'FLOAT') TableCardinality,
		s.value('@Parallel', 'INT') Parallel,
		s.value('@EstimateRebinds', 'FLOAT') EstimateRebinds,
		s.value('@EstimateRewinds', 'FLOAT') EstimateRewinds,
		s.value('@EstimatedExecutionMode', 'NVARCHAR(128)') EstimatedExecutionMode,
		o.value('@Database', 'NVARCHAR(128)') db,
		o.value('@Schema', 'NVARCHAR(128)') sch,
		o.value('@Table', 'NVARCHAR(128)') tab,
		o.value('@Index', 'NVARCHAR(128)') idx,
		o.value('@Alias', 'NVARCHAR(128)') alias,
		o.value('@IndexKind', 'NVARCHAR(128)') IndexKind,
		o.value('@Storage', 'NVARCHAR(128)') Storage,
		s.query('child::*/xs:RelOp') xsRelOp
	FROM	relop r
		CROSS APPLY r.xsRelOp.nodes('xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
)
INSERT	query_plan_relop(database_id, plan_id, StatementId, StatementCompId, QueryHash, QueryPlanHash, lvl, ParentNodeId, NodeId, PhysicalOp, LogicalOp, EstimateRows, EstimatedRowsRead, EstimateIO, EstimateCPU, AvgRowSize, EstimatedTotalSubtreeCost, TableCardinality, Parallel, EstimateRebinds, EstimateRewinds, EstimatedExecutionMode, db, sch, tab, idx, alias, IndexKind, Storage)
SELECT DISTINCT
	r.database_id,
	r.plan_id,
	r.StatementId,
	r.StatementCompId,
	r.QueryHash,
	r.QueryPlanHash,
	r.lvl,
	r.ParentNodeId,
	r.NodeId,
	r.PhysicalOp,
	r.LogicalOp,
	r.EstimateRows,
	r.EstimatedRowsRead,
	r.EstimateIO,
	r.EstimateCPU,
	r.AvgRowSize,
	r.EstimatedTotalSubtreeCost,
	r.TableCardinality,
	r.Parallel,
	r.EstimateRebinds,
	r.EstimateRewinds,
	r.EstimatedExecutionMode,
	r.db,
	r.sch,
	r.tab,
	r.idx,
	r.alias,
	r.IndexKind,
	r.Storage
FROM	relop r
OPTION(MAXRECURSION 0);
