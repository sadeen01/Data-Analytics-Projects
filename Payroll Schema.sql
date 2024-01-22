CREATE TABLE Classifications(
	 [ClassificationID] [INT] IDENTITY(1,1) NOT NULL
	,[EmployeeID] [INT] NULL
	,[Title] [VARCHAR](50) NULL
	,[Salary] [DECIMAL](18, 2) NULL
	,[Housing] [DECIMAL](18, 2) NULL
	,[Transportation] [DECIMAL](18, 2) NULL
	,[OverTime] [BIT] NULL
	,[StartDate] [DATE] NULL
	,[EndDate] [DATE] NULL
	,[AnnualLeaveDays] [INT] NULL
	,PRIMARY KEY ([ClassificationID])
	,FOREIGN KEY ([EmployeeID]) REFERENCES Employees([EmployeeID])
)

CREATE TABLE Employees(
	 [EmployeeID] [INT] IDENTITY(1,1) NOT NULL
	,[FirstName] [VARCHAR](50) NULL
	,[SecondName] [VARCHAR](50) NULL
	,[LastName] [VARCHAR](50) NULL
	,[FamilyName] [VARCHAR](50) NULL
	,[SSN] [VARCHAR](50) NULL
	,[Email] [VARCHAR](50) NULL
	,[Phone] [VARCHAR](50) NULL
	,[EmployeeAddress] [VARCHAR](100) NULL
	,PRIMARY KEY ([EmployeeID])
)

CREATE TABLE Leaves(
	 [LeavesID] [INT] IDENTITY(1,1) NOT NULL
	,[LeaveType] [INT] NULL
	,[EmployeeID] [INT] NULL
	,[StartDate] [DATE] NULL
	,[EndDate] [DATE] NULL
	,PRIMARY KEY ([LeavesID])
	,FOREIGN KEY ([EmployeeID]) REFERENCES Employees([EmployeeID])
)

CREATE TABLE LeaveTypes(
	 [LeaveTypesID] [INT] IDENTITY(1,1) NOT NULL
	,[LeaveType] [VARCHAR](50) NULL
	,PRIMARY KEY ([LeaveTypesID])
)

CREATE TABLE OverTimes(
	 [OverTimeID] [INT] IDENTITY(1,1) NOT NULL
	,[EmployeeID] [INT] NULL
	,[OverTimeHours] [INT] NULL
	,[OverTimeDate] [DATE] NULL
	,PRIMARY KEY ([OverTimeID])
	,FOREIGN KEY ([EmployeeID]) REFERENCES Employees([EmployeeID])
)

CREATE TABLE Payroll(
	 [PayrollId] [INT] IDENTITY(1,1) NOT NULL
	,[EmployeeId] [INT] NULL
	,[Year] [INT] NULL
	,[Month] [INT] NULL
	,PRIMARY KEY ([PayrollId])
	,FOREIGN KEY ([EmployeeId]) REFERENCES Employees([EmployeeID])
)

CREATE TABLE PayrollDetails(
	 [PayrollDetailsId] [INT] IDENTITY(1,1) NOT NULL
	,[PayrollId] [INT] NULL
	,[TypeId] [INT] NULL
	,[SubTypeId] [INT] NULL
	,[Amount] [FLOAT] NULL
	,PRIMARY KEY ([PayrollDetailsId])
	,FOREIGN KEY ([PayrollId]) REFERENCES Payroll([PayrollId])
)

CREATE TABLE PayrollSubTypes(
	 [TypeId] [INT] NULL
	,[SubTypeId] [INT] IDENTITY(1,1) NOT NULL
	,[SubTypeName] [VARCHAR](200) NULL
	,PRIMARY KEY ([SubTypeId])
)

CREATE TABLE PayrollTypes(
	 [TypeId] [INT] IDENTITY(1,1) NOT NULL
	,[TypeName] [VARCHAR](200) NULL
	,PRIMARY KEY ([TypeId])
)

CREATE TABLE Rules(
	 [RuleYear] [INT] NOT NULL
	,[WorkHours] [INT] NULL
	,[WeekDayOverTimeRate] [FLOAT] NULL
	,[WeekEndOverTimeRate] [FLOAT] NULL
	,[SocialSecurityRate] [FLOAT] NULL
)
