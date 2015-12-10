USE [CDT]
GO

Declare @DefaultName varchar(200), @DefaultText varchar(200), @AllowNull varchar(50), @SQL varchar(500)
If Exists (Select * From sysobjects Where name = 'Dictionary' and xtype ='U') 
Begin
          Select @AllowNull = Case When col.isnullable  = 1 Then 'NULL' Else 'NOT NULL' End 
          From syscolumns col inner join sysobjects tab 
          On col.id = tab.id where tab.name =   'Dictionary'  and col.name = 'Content'
          If @AllowNull Is Not Null        Begin 
               Select @DefaultName = def.name, @DefaultText = cmm.text from sysobjects def inner join syscomments cmm 
                   on def.id = cmm.id inner join syscolumns col on col.cdefault = def.id 
                   inner join sysobjects tab on col.id = tab.id  
                   where tab.name = 'Dictionary'  and col.name = 'Content'  
                   --drop constraint 
                   if @DefaultName Is Not Null Execute ('Alter Table Dictionary Drop Constraint ' + @DefaultName)
                   --change column type
                   Set @SQL = 'Alter Table Dictionary  Alter Column Content nvarchar(512)'  + @AllowNull 
                   Execute(@SQL) 
                   --restore constraint 
                   if @DefaultName Is Not Null 
                   Execute( 'Alter Table Dictionary  Add Constraint ' + @DefaultName   + ' Default (' + @DefaultText + ') For Content')
        End
End

If Exists (Select * From sysobjects Where name = 'Dictionary' and xtype ='U') 
Begin
          Select @AllowNull = Case When col.isnullable  = 1 Then 'NULL' Else 'NOT NULL' End 
          From syscolumns col inner join sysobjects tab 
          On col.id = tab.id where tab.name =   'Dictionary'  and col.name = 'Content2'
          If @AllowNull Is Not Null        Begin 
               Select @DefaultName = def.name, @DefaultText = cmm.text from sysobjects def inner join syscomments cmm 
                   on def.id = cmm.id inner join syscolumns col on col.cdefault = def.id 
                   inner join sysobjects tab on col.id = tab.id  
                   where tab.name = 'Dictionary'  and col.name = 'Content2'  
                   --drop constraint 
                   if @DefaultName Is Not Null Execute ('Alter Table Dictionary Drop Constraint ' + @DefaultName)
                   --change column type
                   Set @SQL = 'Alter Table Dictionary  Alter Column Content2 nvarchar(512)'  + @AllowNull 
                   Execute(@SQL) 
                   --restore constraint 
                   if @DefaultName Is Not Null 
                   Execute( 'Alter Table Dictionary  Add Constraint ' + @DefaultName   + ' Default (' + @DefaultText + ') For Content2')
        End
End

GO
 