ALTER procedure [dbo].[CalculateTotalLeaves]
@EmployeeId int ,@Year int ,@Month int ,@LeavesResult decimal(18,2) output
AS
BEGIN
declare @StartDate date 
declare @EndDate date
declare @SalaryPerDay Decimal(18,2) =0.0
declare @Count int = 0
set @Count = (select dbo.CountsLeaveDays (@EmployeeId,@Year,@Month))
declare @AnnualLeaveDays int =(select AnnualLeaveDays from Classifications
where EmployeeID=@EmployeeId and EndDate IS NULL)
set @LeavesResult = 0.0
declare @SubAmount int = 0


DECLARE Leaves CURSOR FOR 
select StartDate,EndDate from Leaves WHERE EmployeeID=@EmployeeId
and YEAR(StartDate)=@Year and MONTH(StartDate)=@Month

open Leaves
FETCH NEXT FROM Leaves INTO @StartDate,@EndDate
WHILE @@FETCH_STATUS=0
	BEGIN
	WHILE @StartDate<=@EndDate
BEGIN
IF DATENAME(DW,@StartDate) NOT IN ('Friday','Saturday')
BEGIN
set @Count=@Count+1 --15
IF @count>@AnnualLeaveDays
BEGIN
--set @StartDate=DATEADD(DAY,1,@StartDate)
IF DATENAME(DW,@StartDate) NOT IN ('Friday','Saturday')
BEGIN
set @SubAmount=@SubAmount+1
set @StartDate=DATEADD(DAY,1,@StartDate)
END--DATENAMESUBAMOUNT
END--COUNT>ANNUALLEAVEDAY
END--DATENAMECOUNT
set @StartDate=DATEADD(DAY,1,@StartDate)
END--START
FETCH NEXT FROM Leaves INTO @StartDate,@EndDate
END--FETCH
    close Leaves
	deallocate Leaves
	set @SalaryPerDay=(select (Salary/30) from Classifications
	    where EmployeeID=@EmployeeId and EndDate IS NULL )
set @LeavesResult=@SalaryPerDay*@SubAmount
END --PROC