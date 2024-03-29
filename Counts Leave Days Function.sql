ALTER FUNCTION [dbo].[CountsLeaveDays]
(
	@EmployeeId int ,@Year int ,@Month int
)
RETURNS int
AS
BEGIN
declare @StartDate date 
declare @EndDate date 
declare @Count int =0

declare LeavesDay cursor for 
select StartDate , EndDate from Leaves 
where EmployeeID=@EmployeeId and YEAR(StartDate)=@Year and MONTH(StartDate)<@Month
open LeavesDay
fetch next from LeavesDay into @StartDate ,@EndDate
WHILE @@FETCH_STATUS=0
	BEGIN
	WHILE @StartDate<=@EndDate
BEGIN
IF DATENAME(DW,@StartDate) NOT IN ('Friday','Saturday') 
BEGIN
set @Count=@Count +1
set @StartDate=DATEADD(DAY,1,@StartDate)
end
fetch next from LeavesDay into @StartDate ,@EndDate
END
end
    close LeavesDay
	deallocate LeavesDay
	RETURN @Count
	
END