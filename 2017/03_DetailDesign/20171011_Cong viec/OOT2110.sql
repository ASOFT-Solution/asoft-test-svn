---- Create by Phan thanh hoàng vũ on 10/4/2017 9:46:00 AM
---- Danh sách công việc..

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OOT2110]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[OOT2110]
(
  [APK] UNIQUEIDENTIFIER DEFAULT newid() NOT NULL,
  [DivisionID] VARCHAR(50) NOT NULL,
  [WorkID] VARCHAR(50) NOT NULL,
  [WorkName] NVARCHAR(250) NULL,
  [ParentWorkID] VARCHAR(50) NULL,
  [PriviousWorkID] NVARCHAR(max) NULL,
  [PriorityID] TINYINT DEFAULT (0) NULL,
  [AssignedToUserID] VARCHAR(50) NULL,
  [SupportUserID] NVARCHAR(max) NULL,
  [ReviewerUserID] VARCHAR(50) NULL,
  [PercentProgress] DECIMAL(28,8) NULL,
  [StatusID] VARCHAR(50) NULL,
  [Orders] INT NULL,
  [IsRepeat] TINYINT DEFAULT (0) NULL,
  [PlanStartDate] DATETIME NULL,
  [PlanEndDate] DATETIME NULL,
  [PlanTime] DECIMAL(28,8) NULL,
  [ActualStartDate] DATETIME NULL,
  [ActualEndDate] DATETIME NULL,
  [ActualTime] DECIMAL(28,8) NULL,
  [ProjectID] VARCHAR(50) NULL,
  [ProcessID] VARCHAR(50) NULL,
  [StepID] VARCHAR(50) NULL,
  [Description] NVARCHAR(max) NULL,
  [RelatedToTypeID] INT DEFAULT 48 NULL,
  [DeleteFlg] TINYINT DEFAULT (0) NULL,
  [CreateUserID] VARCHAR(50) NULL,
  [LastModifyUserID] VARCHAR(50) NULL,
  [CreateDate] DATETIME NULL,
  [LastModifyDate] DATETIME NULL
CONSTRAINT [PK_OOT2110] PRIMARY KEY CLUSTERED
(
  [APK]
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
END