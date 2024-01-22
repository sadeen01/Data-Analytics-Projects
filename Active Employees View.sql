CREATE VIEW [dbo].[ActiveEmployees] 
AS SELECT * FROM Classifications 
WHERE EndDate IS NULL
GO


