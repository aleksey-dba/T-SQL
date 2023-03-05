WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
INSERT	query_plan_statement(database_id, plan_id, StatementId, StatementCompId, StatementType, StatementSqlHandle, DatabaseContextSettingsId, ParentObjectId, StatementParameterizationType, RetrievedFromCache, StatementSubTreeCost, StatementEstRows, StatementOptmLevel, QueryHash, QueryPlanHash, CardinalityEstimationModelVersion, StatementText, CachedPlanSize, CompileTime, CompileCPU, CompileMemory, SerialRequiredMemory, SerialDesiredMemory, GrantedMemory, MaxUsedMemory, EstimatedAvailableMemoryGrant, EstimatedPagesCached, EstimatedAvailableDegreeOfParallelism, MaxCompileMemory)
SELECT
	c.database_id,
	c.plan_id,
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
FROM	query_store_query_plan c
	CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(s)
	OUTER APPLY s.nodes('xs:QueryPlan') q(p);


WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
INSERT	query_plan_statement(database_id, plan_id, StatementId, StatementCompId, StatementType, StatementSqlHandle, DatabaseContextSettingsId, ParentObjectId, StatementParameterizationType, RetrievedFromCache, StatementSubTreeCost, StatementEstRows, StatementOptmLevel, QueryHash, QueryPlanHash, CardinalityEstimationModelVersion, StatementText, CachedPlanSize, CompileTime, CompileCPU, CompileMemory, SerialRequiredMemory, SerialDesiredMemory, GrantedMemory, MaxUsedMemory, EstimatedAvailableMemoryGrant, EstimatedPagesCached, EstimatedAvailableDegreeOfParallelism, MaxCompileMemory)
SELECT
	c.dbid,
	NULL,
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
FROM	cached_plans c
	CROSS APPLY c.query_plan.nodes('/xs:ShowPlanXML/xs:BatchSequence/xs:Batch/xs:Statements/*') n(s)
	OUTER APPLY s.nodes('xs:QueryPlan') q(p);
