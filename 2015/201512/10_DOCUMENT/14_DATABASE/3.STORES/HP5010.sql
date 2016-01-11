IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5010]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5010]
GO
--created by Huynh Trung Dung  
---Date 23/12/2010  
---Purpose: Tao table tam de chua du lieu Import "Cham Cong Ngay" tu file Excel  
--Edit by Huynh Trung Dung  
---Date 11/05/2011  
---Purpose: Sua kieu du lieu cho cot C1 tu kieu Int sang kieu Money   
---(Giai quyet van de ngay cong la so thap phan)  
  
CREATE PROCEDURE  HP5010   
          @ConnID varchar(100) =''  
as  
Declare @sSql as varchar(1000)  
  
if exists (Select Top 1 1 From sysObjects Where id = Object_ID('HT5010' +  @ConnID) and xType = 'U')  
exec ('Drop Table HT5010' + @ConnID)  
--Tao bang  
Set @sSql='  
CREATE TABLE [dbo].[HT5010' + @ConnID + '] (  
 [EmployeeID] [nvarchar] (50) NOT NULL ,   
 [AbsentDate] [datetime] NULL ,  
 [C1] [Money] NOT NULL   
) ON [PRIMARY]  
'  
exec (@sSql)  