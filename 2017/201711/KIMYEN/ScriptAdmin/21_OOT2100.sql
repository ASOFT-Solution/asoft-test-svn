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
set @sysTable=N'OOT2100'
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
set @FieldID=N'APK_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'APK_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'4'
set @TabIndex=N'3'
set @TabIndexGrid=null
set @TabIndexPopup=N'1'
set @TabIndexView=N'3'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DivisionID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
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
set @FieldID=N'DivisionID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DivisionID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_DepartmentID_OOF2100')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'3'
set @TabIndex=N'4'	
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=N'4'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DepartmentID'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'DepartmentID_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DepartmentID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'VViewDepartmentID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'15'
set @TabIndex=N'4'	
set @TabIndexGrid=null
set @TabIndexPopup=N'9'
set @TabIndexView=N'4'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DepartmentName'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'DepartmentName_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DepartmentName_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewDepartmentID_OOF2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'1'	
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DepartmentID'
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
set @FieldID=N'DepartmentID_VViewDepartmentID_OOF2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DepartmentID_VViewDepartmentID_OOF2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewDepartmentID_OOF2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'2'	
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DepartmentName'
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
set @FieldID=N'DepartmentName_VViewDepartmentID_OOF2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DepartmentName_VViewDepartmentID_OOF2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'7'
set @TabIndexGrid=null
set @TabIndexPopup=N'1'
set @TabIndexView=N'7'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProjectID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'1'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ProjectID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProjectID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'8'
set @TabIndexGrid=null
set @TabIndexPopup=N'2'
set @TabIndexView=N'8'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProjectName'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ProjectName_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProjectName_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'9'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=N'8'
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProjectType'
set @sysDataTypeID=N'5'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ProjectType_OOT2100'
set @GridWidth=N'100'
set @sysRadioButtonID=(select top 1 sysRadioButtonID from sysRadioButton where RadioButtonID = 'Rdo_ProjectType')
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProjectType_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,sysRadioButtonID)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@sysRadioButtonID)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_TaskSampleID_OOF2100')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn') 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=N'4'
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'TaskSampleID'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'TaskSampleID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'TaskSampleID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewTasKSampleID_OOF2100'
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
set @ColumnName=N'TasKSampleName'
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
set @FieldID=N'TasKSampleName_VViewTaskSampleID_OOF2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'TasKSampleName_VViewTaskSampleID_OOF2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'6'
set @TabIndex=N'1'
set @TabIndexGrid=null
set @TabIndexPopup=N'5'
set @TabIndexView=N'1'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StartDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=N'1'
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StartDate_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StartDate_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'6'
set @TabIndex=N'2'
set @TabIndexGrid=null
set @TabIndexPopup=N'6'
set @TabIndexView=N'2'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'EndDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'EndDate_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'EndDate_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn') 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=null
set @TabIndexGrid=null
set @TabIndexPopup=N'7'
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CheckingDate'
set @sysDataTypeID=N'9'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'CheckingDate_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CheckingDate_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_LeaderID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'5'
set @TabIndexGrid=null
set @TabIndexPopup=N'9'
set @TabIndexView=N'5'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LeaderID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'LeaderID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LeaderID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_LeaderID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'5'
set @TabIndexGrid=null
set @TabIndexPopup=N'9'
set @TabIndexView=N'5'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LeaderName'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'LeaderName_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LeaderName_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewLeaderID'
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
set @ColumnName=N'LeaderID'
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
set @FieldID=N'LeaderID_VViewLeaderID'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LeaderID_VViewLeaderID')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewLeaderID'
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
set @ColumnName=N'LeaderName'
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
set @FieldID=N'LeaderName_VViewLeaderID'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LeaderName_VViewLeaderID')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_ContractID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'8'
set @TabIndexGrid=null
set @TabIndexPopup=N'4'
set @TabIndexView=N'8'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ContractID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ContractID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ContractID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_ContractID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'8'
set @TabIndexGrid=null
set @TabIndexPopup=N'4'
set @TabIndexView=N'8'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ContractNo'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ContractNo_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ContractNo_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End




set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewContractID'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'1'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ContractID'
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
set @FieldID=N'ContractID_VViewContractID'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ContractID_VViewContractID')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewContractID'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'2'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ContractName'
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
set @FieldID=N'ContractName_VViewContractID'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ContractName_VViewContractID')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End


set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_StatusID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn')
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'3'
set @TabIndex=N'9'	
set @TabIndexGrid=null
set @TabIndexPopup=N'12'
set @TabIndexView=N'9'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'StatusID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'StatusID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StatusID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'VViewStatusID'
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
set @ColumnName=N'StatusName'
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
set @FieldID=N'StatusName_VViewStatusID'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'StatusName_VViewStatusID')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'OOT2100'
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
set @ColumnName=N'RelatedToTypeID'
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
set @FieldID=N'RelatedToTypeID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'RelatedToTypeID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'GR.HeThong') 
set @sysTable=N'OOT2100'
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
set @ColumnName=N'CreateUserID'
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
set @FieldID=N'CreateUserID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateUserID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'GR.HeThong') 
set @sysTable=N'OOT2100'
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
set @ColumnName=N'CreateDate'
set @sysDataTypeID=N'13'
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
set @FieldID=N'CreateDate_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateDate_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'GR.HeThong')
set @sysTable=N'OOT2100'
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
set @ColumnName=N'LastModifyUserID'
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
set @FieldID=N'LastModifyUserID_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyUserID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'GR.HeThong')
set @sysTable=N'OOT2100'
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
set @ColumnName=N'LastModifyDate'
set @sysDataTypeID=N'13'
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
set @FieldID=N'LastModifyDate_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyDate_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'OOT2100'
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
set @ColumnName=N'DeleteFlg'
set @sysDataTypeID=N'6'
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
set @FieldID=N'DeleteFlg_OOT2100'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DeleteFlg_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 sysGroupID from sysGroup where GroupID = 'OOF2102.ChiTietDuAn') 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=null	
set @TabIndexGrid=null
set @TabIndexPopup=N'10'
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'AssignedToUserID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'AssignedToUserID_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'AssignedToUserID_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_AssignedToUserID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'15'
set @TabIndex=null	
set @TabIndexGrid=null
set @TabIndexPopup=N'11'
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'AssignedToUserName'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'AssignedToUserName_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'AssignedToUserName_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End


set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_ContractID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null 
set @sysTable=N'OOT2100'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'16'
set @TabIndex=N'8'
set @TabIndexGrid=null
set @TabIndexPopup=N'4'
set @TabIndexView=N'8'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ContractName'
set @sysDataTypeID=N'7'
set @GridVisible=NULL
set @FieldVisible=NULL
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ContractName_OOT2100'
set @GridWidth=N'100'
set @IsNoUpdate=N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ContractName_OOT2100')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,IsNoUpdate)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@IsNoUpdate)
End

