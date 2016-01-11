-- <Summary>
---- Import dữ liệu ngầm loại thông tin SType
-- <History>
---- Create on 15/07/2015 by Lê Thị Hạnh 
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 1)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',1,N'Thông tin nhân viên',N'Personal Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 2)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',2,N'Thông tin nghề nghiệp',N'Career Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 3)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',3,N'Thông tin học tập',N'Educational Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 4)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',4,N'Thông tin xã hội',N'Social Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 5)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',5,N'Thông tin gia đình',N'Familial Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 6)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',6,N'Thông tin chỉ tiêu - chỉ số',N'Customized Index Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 7)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',7,N'Thông tin lưu trú',N'Residential Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM A00067 WHERE ImportTransTypeID = 'EmployeeFileID' AND SType = 8)
INSERT INTO A00067(ImportTransTypeID, SType, STypeName, STypeNameE,
            [Description], [Disabled], CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(N'EmployeeFileID',8,N'Thông tin bổ sung',N'Additional Information',NULL,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
