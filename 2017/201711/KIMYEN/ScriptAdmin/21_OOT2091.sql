declare @sysTable nvarchar(MAX) declare @AllowNull nvarchar(MAX) declare @ReadOnly nvarchar(MAX) declare @sysComboBoxID nvarchar(MAX) declare @Type nvarchar(MAX) declare @TabIndex nvarchar(MAX) declare @TabIndexGrid nvarchar(MAX) declare @TabIndexPopup nvarchar(MAX) declare @TabIndexView nvarchar(MAX) declare @MinValue nvarchar(MAX) declare @MaxValue nvarchar(MAX) declare @DefaultValue nvarchar(MAX) declare @Visible nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @sysRegularID nvarchar(MAX) declare @sysDataTypeID nvarchar(MAX) declare @GridVisible nvarchar(MAX) declare @FieldVisible nvarchar(MAX) declare @PopupVisible nvarchar(MAX) declare @ViewVisible nvarchar(MAX) declare @UniqueField nvarchar(MAX) declare @RefTable nvarchar(MAX) declare @GroupID nvarchar(MAX) declare @sysEditorTemplateID nvarchar(MAX) declare @MaxLenght nvarchar(MAX) declare @SpecialControl nvarchar(MAX) declare @RefDisplayField nvarchar(MAX) declare @RefValueField nvarchar(MAX) declare @RefViewTable nvarchar(MAX) declare @sysClientTemplateID nvarchar(MAX) declare @FieldID nvarchar(MAX) declare @GridWidth nvarchar(MAX) declare @sysRadioButtonID nvarchar(MAX) declare @LanguageID nvarchar(MAX) declare @IsImport nvarchar(MAX) declare @RefTableComboboxID nvarchar(MAX) declare @GroupOnGrid nvarchar(MAX) declare @CountOnGrid nvarchar(MAX) declare @SumOnGrid nvarchar(MAX) declare @AverageOnGrid nvarchar(MAX) declare @MaxOnGrid nvarchar(MAX) declare @MinOnGrid nvarchar(MAX) declare @LayoutPosition nvarchar(MAX) declare @IsNoUpdate nvarchar(MAX) declare @GridOneTable nvarchar(MAX) 


--set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
--set @sysRegularID=null
--set @sysEditorTemplateID=null
--set @sysClientTemplateID=null
--set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='SOF2002.ThongTinDonHang') 
--set @sysTable=N'OT2001'
--set @AllowNull=N'0'
--set @ReadOnly=N'0'
--set @Type=N'4'
--set @TabIndex=N'2'
--set @TabIndexGrid=N'1'
--set @TabIndexPopup=N'1'
--set @TabIndexView=N'1'
--set @MinValue=null 
--set @MaxValue=null 
--set @DefaultValue=null 
--set @Visible=N'1'
--set @ColumnName=N'DivisionID'
--set @sysDataTypeID=N'7'
--set @GridVisible=N'1'
--set @FieldVisible=N'1'
--set @PopupVisible=N'1'
--set @ViewVisible=N'1'
--set @UniqueField=N'0'
--set @RefTable=null 
--set @MaxLenght=null 
--set @SpecialControl=null 
--set @RefDisplayField=null 
--set @RefValueField=null 
--set @RefViewTable=null 
--set @FieldID=N'Field0013'
--set @GridWidth=N'100'
--If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Field0013')Begin 
--insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
--End


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'APK'
set @sysDataTypeID=N'1'
set @GridVisible=null
set @FieldVisible=N'1'
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'APK_OOT2091'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'APK_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'APKMaster'
set @sysDataTypeID=N'1'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'APKMaster_OOT2091'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'APKMaster_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProcessID'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ProcessID_OOT2091'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProcessID_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StepID'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StepID_OOT2091'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StepID_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Orders'
set @sysDataTypeID=N'5'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'Orders_OOT2091'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Orders_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

Update sysFields set RefTable = 'OOT2090' where ColumnName = 'APKMaster' and sysTable = 'OOT2091'
--Update sysFields set GroupOnGrid = '#= value #' where ColumnName='ProcessID' and sysTable = 'OOT2091'


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProcessName'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ProcessName_OOT2091'
set @GridWidth=N'100'
set @IsNoUpdate = N'1'
set @GroupOnGrid=null

If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProcessName_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate,GroupOnGrid)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate,@GroupOnGrid)
End
Update sysFields set GroupOnGrid = '<input type=''checkbox'' onclick=''process_Click(this)'' group=''#= value #''/> #= value #' where ColumnName='ProcessName' and sysTable = 'OOT2091'

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'1'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StepName'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StepName_OOT2091'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
set @sysClientTemplateID=(select top 1 sysClientTemplateID from sysClientTemplate where ClientTemplateID = 'GenCheckBoxStepName')
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StepName_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate,sysClientTemplateID)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate,@sysClientTemplateID)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2091'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ChooseID'
set @sysDataTypeID=N'6'
set @GridVisible=N'0'
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ChooseID_OOT2091'
set @GridWidth=null
set @IsNoUpdate=N'1'
set @sysClientTemplateID=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ChooseID_OOT2091')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate,sysClientTemplateID)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate,@sysClientTemplateID)
End







