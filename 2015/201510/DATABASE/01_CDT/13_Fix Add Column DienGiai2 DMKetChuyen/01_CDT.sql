use [CDT]

declare @sysTableID as int 

select @sysTableID = sysTableID from sysTable
where TableName = 'DmKetChuyen'

if not exists (select 1 from sysField where FieldName = 'DienGiai2' and sysTableID = @sysTableID)
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
           ,'DienGiai2'
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,2
           ,N'Diễn giải tiếng Anh'
           ,N'Description in English'
           ,10
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
           ,0
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,NULL)


