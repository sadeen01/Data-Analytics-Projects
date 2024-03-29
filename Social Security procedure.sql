ALTER PROCEDURE [dbo].[CalculateSocialSecurity]
@EmployeeId int ,@Year int ,@SocialSecurityResult float output
AS
BEGIN
declare @Salary decimal(18,2)=(select Salary from Classifications
where EmployeeID=@EmployeeId and EndDate IS NULL)
declare @SocialSecurityRate float = (select SocialSecurityRate from Rules
where RuleYear=@Year)

set @SocialSecurityResult=(@Salary*@SocialSecurityRate)/100

END