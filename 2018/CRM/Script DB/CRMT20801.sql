---- Create by HOANGVU on 3/13/2017 9:35:22 AM
---- Danh muc yêu cầu

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CRMT20801]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[CRMT20801]
(
  [APK] UNIQUEIDENTIFIER DEFAULT newid() NOT NULL,
  [RequestID] INT NOT NULL,
  [DivisionID] VARCHAR(50) NOT NULL,
  [RequestSubject] NVARCHAR(Max) NOT NULL,
  [RelatedToTypeID] INT NULL,
  [RequestStatus] INT NOT NULL,
  [PriorityID] INT NOT NULL,
  [TimeRequest] DATETIME NOT NULL,
  [DeadlineRequest] DATETIME NOT NULL,
  [AssignedToUserID] VARCHAR(50) NOT NULL,
  [FeedbackDescription] NVARCHAR(Max) NOT NULL,
  [RequestDescription] NVARCHAR(Max) NOT NULL,
  [DeleteFlg] TINYINT DEFAULT (0) NOT NULL,
  [CreateDate] DATETIME NOT NULL,
  [CreateUserID] VARCHAR(50) NOT NULL,
  [LastModifyDate] DATETIME NOT NULL,
  [LastModifyUserID] VARCHAR(50) NOT NULL
CONSTRAINT [PK_CRMT20801] PRIMARY KEY CLUSTERED
(
  [RequestID],
  [DivisionID]
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'RequestTypeID') 
   ALTER TABLE CRMT20801 ADD RequestTypeID INT NULL 
END

/*===============================================END RequestTypeID===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'BugTypeID') 
   ALTER TABLE CRMT20801 ADD BugTypeID VARCHAR(250) NULL 
END

/*===============================================END BugTypeID===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'ProjectID') 
   ALTER TABLE CRMT20801 ADD ProjectID VARCHAR(50) NULL 
END

/*===============================================END ProjectID===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'DeadlineExpect') 
   ALTER TABLE CRMT20801 ADD DeadlineExpect DATETIME NULL 
END

/*===============================================END DeadlineExpect===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'CompleteDate') 
   ALTER TABLE CRMT20801 ADD CompleteDate DATETIME NULL 
END

/*===============================================END CompleteDate===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'DurationTime') 
   ALTER TABLE CRMT20801 ADD DurationTime DECIMAL(10,2) NULL 
END

/*===============================================END DurationTime===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'RealTime') 
   ALTER TABLE CRMT20801 ADD RealTime DECIMAL(10,2) NULL 
END

/*===============================================END RealTime===============================================*/ 

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT20801' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT20801' AND col.name = 'ProjectID') 
   ALTER TABLE CRMT20801 ADD ProjectID VARCHAR(50) NULL 
END

/*===============================================END ProjectID===============================================*/ 


