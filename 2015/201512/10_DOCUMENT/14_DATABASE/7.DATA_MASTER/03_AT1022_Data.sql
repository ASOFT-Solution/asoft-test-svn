-- <Summary>
---- Insert Danh mục mối quan hệ gia đình (dữ liệu ngầm theo HTKK)
-- <History>
---- Create on 05/01/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
DECLARE @DivisionID VARCHAR(50) = (SELECT TOP 1 DefDivisionID FROM AT0000)

IF NOT EXISTS (SELECT TOP 1 1 FROM AT1022)
BEGIN
	INSERT INTO AT1022 (DivisionID, RelationID, RelationName, DISABLED, IsCommon, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		VALUES (@DivisionID, '01',N'Con',0,1, 'ASOFTADMIN', GETDATE(), 'ASOFTADMIN', GETDATE())
	INSERT INTO AT1022 (DivisionID, RelationID, RelationName, DISABLED, IsCommon, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		VALUES (@DivisionID, '02',N'Vợ/chồng',0,1, 'ASOFTADMIN', GETDATE(), 'ASOFTADMIN', GETDATE())
	INSERT INTO AT1022 (DivisionID, RelationID, RelationName, DISABLED, IsCommon, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		VALUES (@DivisionID, '03',N'Cha/mẹ',0,1, 'ASOFTADMIN', GETDATE(), 'ASOFTADMIN', GETDATE())
	INSERT INTO AT1022 (DivisionID, RelationID, RelationName, DISABLED, IsCommon, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		VALUES (@DivisionID, '04',N'Khác',0,1, 'ASOFTADMIN', GETDATE(), 'ASOFTADMIN', GETDATE())
END