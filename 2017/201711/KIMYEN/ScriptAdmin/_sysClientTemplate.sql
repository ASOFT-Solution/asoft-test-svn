declare @functionClientTemplate nvarchar(MAX) declare @ClientTemplateID nvarchar(MAX) 
set @functionClientTemplate=N'<input type=''checkbox'' onclick=Step_Click(this) class="#=data.ProcessID #" isCheckChild=''true'' #= data.ChooseID == 1? ''checked'' : '' # checkParent="#= data.ProcessName #"/> #=data.StepName #'
set @ClientTemplateID=N'GenCheckBoxStepName'
If not exists(select top 1 1 from [dbo].[sysClientTemplate] where  [ClientTemplateID] = N'GenCheckBoxStepName')Begin 
insert into sysClientTemplate(functionClientTemplate,ClientTemplateID)values(@functionClientTemplate,@ClientTemplateID)
End