WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:SpillOccurred') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.value('@Database','sysname') database_name, w.value('@Schema','sysname') sch_name, w.value('@Table','sysname') Table_name, w.value('@Column','sysname') column_name, ISNULL(w.value('@ComputedColumn','bit'),0) is_computed
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:ColumnsWithNoStatistics/xs:ColumnReference') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:ColumnsWithStaleStatistics') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:SpillToTempDb') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:Wait') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:PlanAffectingConvert') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:SortSpillDetails') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:HashSpillDetails') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:ExchangeSpillDetails') x(w);


WITH
  XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS xs)
SELECT qp.plan_id, w.query('.')
FROM query_plan qp CROSS APPLY qp.query_plan.nodes('//xs:MemoryGrantWarning') x(w);