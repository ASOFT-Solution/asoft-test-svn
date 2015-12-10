declare @sql nvarchar(MAX),
		@dbName varchar(16)
		
SELECT @dbName = db_name()

set @sql = N'
declare @BankName nvarchar(250),
		@SoTK nvarchar(50),
		@ChiNhanhNH nvarchar(250),
		@DF_BankID varchar(16),
		@DF_BankAccountID varchar(16)
		
-- 1) Chuyển thông tin ngân hàng trong CDT.dbo.sysConfig vào DMNH và DMTKNH
set @DF_BankID  = N''Bank1''
set @DF_BankAccountID  = N''BankAccount1''

select @BankName = LTRIM(RTRIM(_Value)) from CDT.dbo.sysConfig where _Key = N''TenNH'' AND DbName=N''' + @dbName +  ''';'+
'select @SoTK = LTRIM(RTRIM(_Value)) from CDT.dbo.sysConfig where _Key = N''SoTK'' AND DbName=N''' + @dbName +  ''';' +
'select @ChiNhanhNH = LTRIM(RTRIM(_Value)) from CDT.dbo.sysConfig where _Key = N''ChiNhanhNH'' AND DbName=N''' + @dbName +  ''';' +
'if isnull(@BankName,'''') <> ''''
BEGIN
	INSERT into DMNH(BankID, BankName,Disabled)
	VALUES(@DF_BankID,@BankName,0)
	
	if isnull(@SoTK,'''') <> ''''
	BEGIN
		INSERT into DMTKNH(BankAccountID, BankAccountNo, BankID, BankBranch, Disabled)
		VALUES(@DF_BankAccountID, @SoTK, @DF_BankID, @ChiNhanhNH, 0)
	END
	'+
	' -- 2) Update thông tin ngân hàng cho các nghiệp vụ giấy báo nợ, báo có, hóa đơn bán hàng, hóa đơn dịch vụ
	Update MT16 set BankID = @DF_BankID, BankAccountID = @DF_BankAccountID;
	Update MT15 set BankID = @DF_BankID, BankAccountID = @DF_BankAccountID;
	Update MT32 set BankID = @DF_BankID, BankAccountID = @DF_BankAccountID;
	Update MT31 set BankID = @DF_BankID, BankAccountID = @DF_BankAccountID;'
+
'
END

-- 3) Xóa 3 key trong sysConfig
delete from CDT.dbo.sysConfig where _Key IN (N''TenNH'',N''SoTK'',N''ChiNhanhNH'') AND DbName=N''' + @dbName +  ''';
'
exec(@sql)