use [CDT]

declare @sysTableID as int 

select @sysTableID = sysTableID from sysTable
where TableName = 'sysConfig'

if not exists (select 1 from sysField where FieldName = 'DbName' and sysTableID = @sysTableID)
INSERT INTO [CDT].[dbo].[sysField]
           ([sysTableID]
           ,[FieldName]
           ,[AllowNull]
           ,[RefField]
           ,[RefTable]
           ,[DisplayMember]
           ,[RefCriteria]
           ,[Type]
           ,[LabelName]
           ,[LabelName2]
           ,[TabIndex]
           ,[Formula]
           ,[FormulaDetail]
           ,[MaxValue]
           ,[MinValue]
           ,[DefaultValue]
           ,[Tip]
           ,[TipE]
           ,[Visible]
           ,[IsBottom]
           ,[IsFixCol]
           ,[IsGroupCol]
           ,[SmartView]
           ,[RefName]
           ,[DefaultName]
           ,[EditMask]
           ,[IsUnique]
           ,[DynCriteria])
     VALUES
           (@sysTableID
           ,'DbName'
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,N'Tên cơ sở dữ liệu'
           ,N'Database name'
           ,7
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,0
           ,0
           ,1
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,NULL)


