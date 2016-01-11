/****** Object:  StoredProcedure [dbo].[HP7111]    Script Date: 01/03/2012 14:31:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP7111]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP7111]
GO

/****** Object:  StoredProcedure [dbo].[HP7111]    Script Date: 01/03/2012 14:31:22 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

/********************************************  
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]  
'********************************************/  
CREATE PROCEDURE [dbo].[HP7111]   
 @DivisionID nvarchar(50) ,  
 @ReportCode nvarchar(50),  
 @Scale int,  
 @GetFormat tinyint,  
 @DecimalSymbol char(1),  
 @DigitGroupSymbol char(1),  
 @PrintType int  
  
AS  
  
DECLARE  @RowCount int,  
  @sql nvarchar(4000),  
  @sql1 nvarchar(4000),  
  @Caption nvarchar(100),  
  @i int,@j int,  
  @cur cursor,  
    
  @COL1 nvarchar(4000),  
  @COL2 nvarchar(4000),  
    
  @PhongBan nvarchar(20), @ToNhom nvarchar(20), @MaNV nvarchar(20), @HoTen nvarchar(20),  
  @KyNhan nvarchar(20)  
  
SET NOCOUNT OFF  
--Goi thu tuc tinh so thu tu de in phieu luong  
EXEC HP7110 @DivisionID, @PrintType   

SET @i=1  
SET @j=1  
  
set @PhongBan = N'Phòng ban:'  
set @ToNhom = N'Tổ nhóm:'  
set @MaNV = N'Mã nhân viên:'  
set @HoTen = N'Họ và tên:'  
set @KyNhan = N'Ký Nhận:'  
   
--SET @RowCount = (SELECT COUNT(*) FROM HT4712 WHERE ReportCode=@ReportCode AND Disabled=1 GROUP BY ReportCode)  
  
SET @sql=''  
SET @sql1=''  
  
 SET @cur=CURSOR FOR  
 SELECT Caption,FOrders FROM HT4712 WHERE ReportCode=@ReportCode AND DivisionID = @DivisionID 
 AND Disabled=1 ORDER BY  FOrders  
 SELECT Caption,FOrders FROM HT4712 WHERE ReportCode=@ReportCode AND DivisionID = @DivisionID 
 AND Disabled=1 ORDER BY  FOrders  
 open @cur  
 FETCH NEXT FROM @cur into @Caption,@i  
 WHILE @@FETCH_STATUS=0  
 BEGIN  
  IF @i<10   
  BEGIN  
   SET @sql=@sql+ N''''+@Caption+'''' + '+CHAR(58)'+'+CHAR(13)+CHAR(10)+N'  
   SET @sql1=@sql1+ 'isnull(dbo.HS0001(ColumnAmount0' + cast(@i as nvarchar(1)) + ',' + cast(@Scale as varchar(1)) + ',' + cast(@GetFormat as varchar(1))+','+CHAR(39)+@DecimalSymbol+CHAR(39)+','+CHAR(39)+@DigitGroupSymbol+CHAR(39)+'),0)+CHAR(13)+CHAR(10)+
'  
  END  
     
  ELSE  
  BEGIN  
   SET @sql=@sql+ N''''+@Caption+'''' + '+CHAR(58)'+'+CHAR(13)+CHAR(10)+N'  
   SET @sql1=@sql1+ 'isnull(dbo.HS0001(ColumnAmount' + cast(@i as nvarchar(2)) + ',' + cast(@Scale as varchar(1)) + ',' + cast(@GetFormat as varchar(1))+','+CHAR(39)+@DecimalSymbol+CHAR(39)+','+CHAR(39)+@DigitGroupSymbol+CHAR(39)+'),0)+CHAR(13)+CHAR(10)+'
  
  END  
  FETCH NEXT FROM @cur into @Caption,@i  
  
 END  
   
 close @cur  
 DEALLOCATE @cur  
   
  
--print LEN(@sql)  
 SET @sql=LEFT(@sql,LEN(@sql)-1)  
 SET @sql1=LEFT(@sql1,LEN(@sql1)-1)  
   
 SET @sql=  
  Case @PrintType  
  When 0 Then   
   'INSERT INTO HT7111(DivisionID, COL1,COL2) SELECT DivisionID, N' + ''''+@PhongBan+'''' + ' +CHAR(13)+CHAR(10)+N'   + ''''+@ToNhom+'''' + ' +CHAR(13)+CHAR(10)+N' + ''''+@MaNV+'''' + ' +CHAR(13)+CHAR(10)+N' +  
   ''''+@HoTen+'''' + ' + CHAR(13)+CHAR(10)+N' + @sql + '+N' +''''+@KyNhan+'''' + ',' +  
   'DepartmentName + CHAR(13)+CHAR(10)+' + 'TeamName + CHAR(13)+CHAR(10)+' + 'EmployeeID + CHAR(13)+CHAR(10)+'+'fullname + CHAR(13)+CHAR(10)+' + @sql1 + '  + ''.''+CHAR(13)+CHAR(10)+ CHAR(32)' +  
   ' FROM HT7110 WHERE DivisionID = '''+@DivisionID + ''' ORDER BY DivisionID,DepartmentID,TeamID,EmployeeID'  
  When 1 Then   
   'INSERT INTO HT7111(DivisionID, COL1,COL2) SELECT DivisionID, N' + ''''+@PhongBan+'''' + ' +CHAR(13)+CHAR(10)+N'   + ''''+@ToNhom+'''' + ' +CHAR(13)+CHAR(10)+N' + ''''+@MaNV+'''' + ' +CHAR(13)+CHAR(10)+N' +  
   ''''+@HoTen+'''' + ' + CHAR(13)+CHAR(10)+N' + @sql + '+N' +''''+@KyNhan+'''' + ',' +  
   'DepartmentName + CHAR(13)+CHAR(10)+' + 'TeamName + CHAR(13)+CHAR(10)+' + 'EmployeeID + CHAR(13)+CHAR(10)+'+'fullname + CHAR(13)+CHAR(10)+' + @sql1  + '  +''.''+CHAR(13)+CHAR(10)+ CHAR(32)' +  
   ' FROM HT7110 Where DivisionID = '''+@DivisionID + ''' AND (Len(BankAccountNo)>0 Or BankAccountNo Is Not Null) ORDER BY DivisionID,DepartmentID,TeamID,EmployeeID'  
  When 2 Then   
   'INSERT INTO HT7111(DivisionID, COL1,COL2) SELECT DivisionID, N' + ''''+@PhongBan+'''' + ' +CHAR(13)+CHAR(10)+N'   + ''''+@ToNhom+'''' + ' +CHAR(13)+CHAR(10)+N' + ''''+@MaNV+'''' + ' +CHAR(13)+CHAR(10)+N' +  
   ''''+@HoTen+'''' + ' + CHAR(13)+CHAR(10)+N' + @sql + '+' +N''''+@KyNhan+'''' + ',' +  
   'DepartmentName + CHAR(13)+CHAR(10)+' + 'TeamName + CHAR(13)+CHAR(10)+' + 'EmployeeID + CHAR(13)+CHAR(10)+'+'fullname + CHAR(13)+CHAR(10)+' + @sql1  + '  + ''.''+CHAR(13)+CHAR(10)+  CHAR(32)' +  
   ' FROM HT7110  WHERE DivisionID = '''+@DivisionID + ''' AND  (Len(BankAccountNo)<=0 Or BankAccountNo Is Null) ORDER BY DivisionID,DepartmentID,TeamID,EmployeeID'  
  End  
 DELETE FROM HT7111 WHERE DivisionID = @DivisionID
 DBCC CHECKIDENT (HT7111,RESEED,0) WITH NO_INFOMSGS  
 EXEC (@sql)  
--Xu ly du lieu tu bang HT7111 sang HT7112  
 DELETE FROM HT7112  WHERE DivisionID = @DivisionID
 DBCC CHECKIDENT (HT7112,RESEED,0) WITH NO_INFOMSGS
  
 SET @sql=''  
 SET @sql1=''   
 SET @j=1  
 SET @cur=CURSOR FOR  
 SELECT CAST(COL1 as nvarchar(4000)),CAST(COL2 as nvarchar(4000)) FROM HT7111 WHERE DivisionID = @DivisionID ORDER BY [ID]  
 open @cur  
  FETCH NEXT FROM @cur INTO @COL1,@COL2  
    
  WHILE @@FETCH_STATUS=0  
  BEGIN  
	
   SET @sql = @sql + CHAR(39) + @COL1 + CHAR(39) + ',' + CHAR(39) + @COL2 + CHAR(39) + ','
   SET @j=@j+1  
   IF @j>3  
    BEGIN  
     SET @j=1  
     SET @sql = LEFT(@sql,len(@sql)-1)  
     SET @Sql1='INSERT INTO HT7112 VALUES(NEWID(),'''+@DivisionID+ ''',' + @sql + ')'   
    
     EXEC (@sql1)  
     SET @sql=''  
     SET @sql1=''  
    END  
   FETCH NEXT FROM @cur INTO @COL1,@COL2    
  END  
 close @cur  
  
SET NOCOUNT OFF  
  
DEALLOCATE @cur