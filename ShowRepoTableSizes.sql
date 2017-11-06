-- temporary table to hold results of sp_spacedused for a specific table
IF OBJECT_ID('tempdb..#t', 'U') IS NOT NULL
DROP TABLE #t

CREATE TABLE #t ([name] NVARCHAR(128),[rows] CHAR(11),reserved VARCHAR(18),data VARCHAR(18),index_size VARCHAR(18),unused VARCHAR(18)) 

-- get the space used for each table in this database
INSERT #t EXEC sp_msForEachTable 'EXEC sp_spaceused ''?'''

SELECT * FROM (
   SELECT [name] as "Table", 
       CONVERT(int, [rows]) as "Rows",
       CONVERT(int, LEFT([reserved],LEN([reserved])-3)) / 1024 as "Reserved MB",
       CONVERT(int, LEFT([data],LEN([data])-3)) / 1024 as "Data MB",
       CONVERT(int, LEFT([index_size],LEN([index_size])-3)) / 1024 as "Index MB",
       CONVERT(int, LEFT([unused],LEN([unused])-3)) / 1024 as "Unused MB"
FROM #t) t
ORDER BY [Reserved MB] DESC

DROP TABLE #t
