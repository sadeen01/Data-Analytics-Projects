ALTER procedure [dbo].[CalculateTaxes] 
@EmployeeID int 
,@Year int 
,@TaxesAmount_Result float output
AS
BEGIN
DECLARE 
	@Salary float = (select c.Salary from Classifications c where c.EmployeeID = @EmployeeID and c.EndDate is null) * 12,
    @Housing float = (select c.Housing from Classifications c where c.EmployeeID = @EmployeeID and c.EndDate is null) * 12,
	@Transportation float = (select c.Transportation from Classifications c where c.EmployeeID = @EmployeeID and c.EndDate is null) * 12
DECLARE @TotalSalary float = @Salary + @Housing + @Transportation

IF @TotalSalary <=9000
BEGIN
SELECT 'This Employee does not pay taxes'
RETURN
END
DECLARE @SalaryAmount float = @TotalSalary
DECLARE @TaxesAmount float = 0

IF @SalaryAmount <= 14000
   SET @TaxesAmount = (@SalaryAmount - 9000) * 0.05

ELSE IF @SalaryAmount <= 19000
	SET @TaxesAmount = 250 +(@SalaryAmount - 14000) * 0.1

ELSE IF @SalaryAmount<=24000
   SET @TaxesAmount = 750 + (@SalaryAmount - 19000) * 0.15

ELSE IF @SalaryAmount <= 29000
    SET @TaxesAmount = 1500 + (@SalaryAmount -24000) * 0.20

ELSE IF @SalaryAmount <= 34000
     SET @TaxesAmount = 2500 + (@SalaryAmount - 29000) * 0.25
ELSE 
  SET @TaxesAmount = 2500+ (@SalaryAmount - 29000) * 0.25
END
SET @TaxesAmount_Result = @TaxesAmount
