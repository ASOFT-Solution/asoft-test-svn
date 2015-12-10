use [CDT]

DECLARE @sySiteID int, @DbName varchar(50),@cur cursor


SET @cur = CURSOR FOR SELECT DISTINCT sysSiteID,
                                      DbName
                      FROM   sysConfig
                      WHERE  sysSiteID NOT IN (SELECT sysSiteID
                                               FROM   sysSite
                                               WHERE  SiteCode = 'CDT') 
                      
OPEN @cur
FETCH NEXT FROM @cur INTO @sySiteID, @DbName
WHILE @@FETCH_STATUS = 0
  BEGIN
    ---- Insert config
    -- Số tài khoản
	IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sysConfig
                   WHERE  sysSiteID = @sySiteID
                          AND DbName = @DbName
                          AND _Key = N'SoTK') 
    
	BEGIN
		INSERT sysConfig([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig],
						 [DienGiai], [DienGiai2],[DbName],[IsFormatString])
		VALUES (N'SoTK', '', 1,  @sySiteID, 0,
				N'Số tài khoản', N'Account Number', @DbName,NULL)
    END 
    
    -- Ngân hàng
    IF NOT EXISTS (SELECT TOP 1 1
                   FROM   sysConfig
                   WHERE  sysSiteID = @sySiteID
                          AND DbName = @DbName
                          AND _Key = N'TenNH') 
    BEGIN
		INSERT sysConfig([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig],
						 [DienGiai], [DienGiai2],[DbName],[IsFormatString])
		VALUES (N'TenNH', '',1,  @sySiteID, 0,
				N'Ngân hàng', N'Bank Name', @DbName,NULL)
    END
     FETCH NEXT FROM @cur INTO @sySiteID, @DbName
  END
Close @cur
GO


