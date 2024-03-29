ALTER PROCEDURE [dbo].[CalculatePayroll]
	@Year int ,
	@Month int 
AS
BEGIN
declare @EmployeeId int 
declare @Salary decimal(18,2)
declare @Housing decimal(18,2)
declare @Transportation decimal(18,2)

DECLARE CheckEmp CURSOR FOR 
select EmployeeID,Salary,Housing,Transportation
from ActiveEmployees
WHERE YEAR(StartDate)=@Year and MONTH(StartDate)=@Month
AND Housing IS NOT NULL AND Transportation IS NOT NULL

open CheckEmp
FETCH NEXT FROM CheckEmp INTO
@EmployeeId,@Salary,@Housing,@Transportation
WHILE @@FETCH_STATUS=0
	BEGIN
	IF EXISTS (select * from Payroll where EmployeeId=@EmployeeId 
	and Year=@Year and Month=@Month)
	BEGIN
	select ' VALUES ARE ALREADY EXIST !!'
	END
	ELSE
	BEGIN
	Insert Into Payroll Values (@EmployeeId,@Year,@Month)
	declare @EmployeePayrollId int =(select PayrollId from Payroll
     where EmployeeId=@EmployeeId and Year=@Year and Month=@Month)

	Insert Into PayrollDetails Values (@EmployeePayrollId,1,1,@Salary)
	Insert Into PayrollDetails Values (@EmployeePayrollId,1,2,@Housing)
	Insert Into PayrollDetails Values (@EmployeePayrollId,1,3,@Transportation)

	declare @LeavesResult float = 0
	Exec CalculateTotalLeaves @EmployeeId , @Year , @Month , @LeavesResult OUTPUT
	IF @LeavesResult > 0
	BEGIN
	Insert Into PayrollDetails Values (@EmployeePayrollId,2,5,@LeavesResult)
	END

	declare @OverTimeResult float = 0
	Exec CalculateOverTime @EmployeeId , @Year , @Month ,@OverTimeResult output
	IF @OverTimeResult > 0
	BEGIN
	Insert Into PayrollDetails Values (@EmployeePayrollId,1,4,@OverTimeResult)
	END

	declare @TaxResult float = 0 
	Exec CalculateTaxes @EmployeeId , @Year ,@TaxResult OUTPUT
	IF @TaxResult > 0
	BEGIN
	Insert Into PayrollDetails Values (@EmployeePayrollId,2,6,@TaxResult)
	END

	declare @SocialSecurityResult float = 0
	Exec CalculateSocialSecurity @EmployeeId , @Year ,@SocialSecurityResult OUTPUT
	IF @SocialSecurityResult > 0
	BEGIN
	Insert Into PayrollDetails Values (@EmployeePayrollId,2,7,@SocialSecurityResult)
	END
	END
	FETCH NEXT FROM CheckEmp INTO
     @EmployeeId,@Salary,@Housing,@Transportation
	 
	END -- FETCH
		close CheckEmp
	   deallocate CheckEmp
END --PROC