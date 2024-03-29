ALTER PROCEDURE [dbo].[CalculateOverTime]
    @EmplyeeId int,
    @Year int,
    @Month int,
    @OverTimeResult float output
AS
BEGIN
    declare @OverTime BIT = (select OverTime from Classifications 
	where EmployeeID = @EmplyeeId AND EndDate IS NULL)
    declare @OverTimeHours int
    declare @OverTimeDate date
    declare @overtimeRate float
    declare @WorkHours int
    set @WorkHours = (select WorkHours from Rules where RuleYear = @Year)
    set @OverTimeResult = 0.0

    declare OverTime CURSOR FOR
    select OverTimeHours, OverTimeDate from OverTimes
    where EmployeeID = @EmplyeeId AND YEAR(OverTimeDate) = @Year
	AND MONTH(OverTimeDate) = @Month

    OPEN OverTime
    FETCH NEXT FROM OverTime INTO @OverTimeHours, @OverTimeDate

    WHILE @@FETCH_STATUS = 0
    BEGIN
        set @overtimeRate = (select case when DATENAME(WEEKDAY, @OverTimeDate) = 'Saturday'
                            then WeekEndOverTimeRate
                            when DATENAME(WEEKDAY, @OverTimeDate) = 'Friday'
                            then WeekEndOverTimeRate
                            else WeekDayOverTimeRate
                            end from Rules where RuleYear = @year)
        set @overtimeRate = @overtimeRate * @OverTimeHours

        set @OverTimeResult = @OverTimeResult + (@overtimeRate * ((select Salary
                        from Classifications where EmployeeID = @EmplyeeId
						AND EndDate IS NULL) / 30) / @WorkHours)

        FETCH NEXT FROM OverTime INTO @OverTimeHours, @OverTimeDate
    END

    close OverTime
    Deallocate OverTime

    select @OverTimeResult AS [Over Time Result]
END
