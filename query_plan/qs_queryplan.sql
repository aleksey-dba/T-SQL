WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
, cte AS (SELECT plan_id, CONVERT(XML, query_plan) query_plan FROM sys.query_store_plan)
SELECT
	c.plan_id,
	c.query_plan,
	s.value('@StatementId', 'INT') StatementId,
	s.value('@StatementCompId', 'INT') StatementCompId,
	s.value('@StatementType', 'nvarchar(128)') StatementType,
	s.value('@StatementSqlHandle', 'varchar(128)') StatementSqlHandle,
	s.value('@DatabaseContextSettingsId', 'INT') DatabaseContextSettingsId,
	s.value('@ParentObjectId', 'INT') ParentObjectId,
	s.value('@StatementParameterizationType', 'INT') StatementParameterizationType,
	s.value('@RetrievedFromCache', 'BIT') RetrievedFromCache,
	s.value('@StatementSubTreeCost', 'float') StatementSubTreeCost,
	s.value('@StatementEstRows', 'float') StatementEstRows,
	s.value('@StatementOptmLevel', 'varchar(16)') StatementOptmLevel,
	s.value('@QueryHash', 'varchar(16)') QueryHash,
	s.value('@QueryPlanHash', 'varchar(16)') QueryPlanHash,
	s.value('@CardinalityEstimationModelVersion', 'INT') CardinalityEstimationModelVersion,
	s.value('@StatementText', 'nvarchar(max)') StatementText,
	p.value('@CachedPlanSize', 'BIGINT') CachedPlanSize,
	p.value('@CompileTime', 'BIGINT') CompileTime,
	p.value('@CompileCPU', 'BIGINT') CompileCPU,
	p.value('@CompileMemory', 'BIGINT') CompileMemory,
	p.value('xs:MemoryGrantInfo[1]/@SerialRequiredMemory', 'BIGINT') SerialRequiredMemory,
	p.value('xs:MemoryGrantInfo[1]/@SerialDesiredMemory', 'BIGINT') SerialDesiredMemory,
	p.value('xs:MemoryGrantInfo[1]/@GrantedMemory', 'BIGINT') GrantedMemory,
	p.value('xs:MemoryGrantInfo[1]/@MaxUsedMemory', 'BIGINT') MaxUsedMemory,
	p.value('xs:OptimizerHardwareDependentProperties[1]/@EstimatedAvailableMemoryGrant', 'BIGINT') EstimatedAvailableMemoryGrant,
	p.value('xs:OptimizerHardwareDependentProperties[1]/@EstimatedPagesCached', 'BIGINT') EstimatedPagesCached,
	p.value('xs:OptimizerHardwareDependentProperties[1]/@EstimatedAvailableDegreeOfParallelism', 'BIGINT') EstimatedAvailableDegreeOfParallelism,
	p.value('xs:OptimizerHardwareDependentProperties[1]/@MaxCompileMemory', 'BIGINT') MaxCompileMemory
FROM	cte c
	CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(s)
	OUTER APPLY s.nodes('xs:QueryPlan') q(p);



WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
, cte AS (SELECT TOP 300 plan_id, CONVERT(XML, query_plan) query_plan FROM sys.query_store_plan),
relop AS (
	SELECT
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
	FROM	cte c
		CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(x)
		OUTER APPLY x.nodes('xs:QueryPlan/xs:RelOp') q(s)
		OUTER APPLY s.nodes('child::*/xs:Object') s(o)
	UNION ALL
	SELECT
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
	--WHERE r.lvl > 0
)
SELECT * FROM		relop r
OPTION(MAXRECURSION 0);



CREATE DATABASE SQLMonk_QueryStore
USE SQLMonk_QueryStore
CREATE TABLE query_plan (plan_id BIGINT NOT NULL PRIMARY KEY, query_plan XML) WITH (DATA_COMPRESSION=PAGE);
CREATE PRIMARY XML INDEX pxi ON query_plan(query_plan);

GO

ALTER PROCEDURE import_new_query_plan AS
INSERT query_plan(plan_id, query_plan)
SELECT plan_id, CONVERT(XML, query_plan) query_plan FROM SQLMonk.sys.query_store_plan
WHERE plan_id > (SELECT ISNULL(MAX(plan_id),0) FROM query_plan)