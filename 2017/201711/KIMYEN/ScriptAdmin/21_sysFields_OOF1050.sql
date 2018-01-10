--declare @sysTable nvarchar(MAX) declare @AllowNull nvarchar(MAX) declare @ReadOnly nvarchar(MAX) declare @sysComboBoxID nvarchar(MAX) declare @Type nvarchar(MAX) declare @TabIndex nvarchar(MAX) declare @TabIndexGrid nvarchar(MAX) declare @TabIndexPopup nvarchar(MAX) declare @TabIndexView nvarchar(MAX) declare @MinValue nvarchar(MAX) declare @MaxValue nvarchar(MAX) declare @DefaultValue nvarchar(MAX) declare @Visible nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @sysRegularID nvarchar(MAX) declare @sysDataTypeID nvarchar(MAX) declare @GridVisible nvarchar(MAX) declare @FieldVisible nvarchar(MAX) declare @PopupVisible nvarchar(MAX) declare @ViewVisible nvarchar(MAX) declare @UniqueField nvarchar(MAX) declare @RefTable nvarchar(MAX) declare @GroupID nvarchar(MAX) declare @sysEditorTemplateID nvarchar(MAX) declare @MaxLenght nvarchar(MAX) declare @SpecialControl nvarchar(MAX) declare @RefDisplayField nvarchar(MAX) declare @RefValueField nvarchar(MAX) declare @RefViewTable nvarchar(MAX) declare @sysClientTemplateID nvarchar(MAX) declare @FieldID nvarchar(MAX) declare @GridWidth nvarchar(MAX) declare @sysRadioButtonID nvarchar(MAX) declare @LanguageID nvarchar(MAX) declare @IsImport nvarchar(MAX) declare @RefTableComboboxID nvarchar(MAX) declare @GroupOnGrid nvarchar(MAX) declare @CountOnGrid nvarchar(MAX) declare @SumOnGrid nvarchar(MAX) declare @AverageOnGrid nvarchar(MAX) declare @MaxOnGrid nvarchar(MAX) declare @MinOnGrid nvarchar(MAX) declare @LayoutPosition nvarchar(MAX) declare @IsNoUpdate nvarchar(MAX) declare @GridOneTable nvarchar(MAX) 


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

declare @sysTable nvarchar(MAX) declare @AllowNull nvarchar(MAX) declare @ReadOnly nvarchar(MAX) declare @sysComboBoxID nvarchar(MAX) declare @Type nvarchar(MAX) declare @TabIndex nvarchar(MAX) declare @TabIndexGrid nvarchar(MAX) declare @TabIndexPopup nvarchar(MAX) declare @TabIndexView nvarchar(MAX) declare @MinValue nvarchar(MAX) declare @MaxValue nvarchar(MAX) declare @DefaultValue nvarchar(MAX) declare @Visible nvarchar(MAX) declare @ColumnName nvarchar(MAX) declare @sysRegularID nvarchar(MAX) declare @sysDataTypeID nvarchar(MAX) declare @GridVisible nvarchar(MAX) declare @FieldVisible nvarchar(MAX) declare @PopupVisible nvarchar(MAX) declare @ViewVisible nvarchar(MAX) declare @UniqueField nvarchar(MAX) declare @RefTable nvarchar(MAX) declare @GroupID nvarchar(MAX) declare @sysEditorTemplateID nvarchar(MAX) declare @MaxLenght nvarchar(MAX) declare @SpecialControl nvarchar(MAX) declare @RefDisplayField nvarchar(MAX) declare @RefValueField nvarchar(MAX) declare @RefViewTable nvarchar(MAX) declare @sysClientTemplateID nvarchar(MAX) declare @FieldID nvarchar(MAX) declare @GridWidth nvarchar(MAX) declare @sysRadioButtonID nvarchar(MAX) declare @LanguageID nvarchar(MAX) declare @IsImport nvarchar(MAX) declare @RefTableComboboxID nvarchar(MAX) declare @GroupOnGrid nvarchar(MAX) declare @CountOnGrid nvarchar(MAX) declare @SumOnGrid nvarchar(MAX) declare @AverageOnGrid nvarchar(MAX) declare @MaxOnGrid nvarchar(MAX) declare @MinOnGrid nvarchar(MAX) declare @LayoutPosition nvarchar(MAX) declare @IsNoUpdate nvarchar(MAX) declare @GridOneTable nvarchar(MAX) 

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'4'
set @TabIndexGrid= null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'InformName'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'0'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'InformName_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'InformName_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1050'
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
set @ColumnName=N'APK'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'0'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'APK_OOT1050'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'APK_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'1'
set @TabIndexGrid=N'1'
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DivisionID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'0'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'DivisionID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DivisionID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'3'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'0'
set @ColumnName=N'InformID'
set @sysDataTypeID=N'5'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'0'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'InformID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'InformID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End


set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=N'5'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'EffectDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'EffectDate_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'EffectDate_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=N'6'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ExpiryDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'ExpiryDate_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ExpiryDate_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_DepartmentID')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'3'
set @TabIndex=N'7'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DepartmentID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'DepartmentID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'2'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DepartmentID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_InformType')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'9'
set @TabIndex=N'8'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'InformType'
set @sysDataTypeID=N'6'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'InformType_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'2'
set @sysRadioButtonID =(select top 1 sysRadioButtonID from sysRadioButton where RadioButtonID = 'Rdo_InformType')
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'InformType_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition,sysRadioButtonID)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition,@sysRadioButtonID)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'3'
set @TabIndex=N'9'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'InformDivisionID'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'InformDivisionID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'2'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'InformDivisionID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'13'
set @TabIndex=N'10'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Description'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'Description_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'3'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Description_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0012')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1052.XemChiTietThongBao') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'2'
set @TabIndex=N'11'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Disabled'
set @sysDataTypeID=N'6'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'1'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'Disabled_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = N'1'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Disabled_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=N'12'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CreateDate'
set @sysDataTypeID=N'13'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'CreateDate_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateDate_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'13'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CreateUserID'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'CreateUserID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateUserID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'14'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LastModifyUserID'
set @sysDataTypeID=N'7'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'LastModifyUserID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyUserID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=N'15'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LastModifyDate'
set @sysDataTypeID=N'13'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'LastModifyDate_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyDate_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1050'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'16'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=null
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'RelatedToTypeID'
set @sysDataTypeID=N'5'
set @GridVisible=N'0'
set @FieldVisible=N'0'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'RelatedToTypeID_OOT1050'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'RelatedToTypeID_OOT1050')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'VViewInformType'
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
set @ColumnName=N'Description'
set @sysDataTypeID=N'7'
set @GridVisible=null
set @FieldVisible=null
set @PopupVisible=null
set @ViewVisible=null
set @UniqueField=null
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'VViewInformType_Description'
set @GridWidth=N'100'
set @LayoutPosition = null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'VViewInformType_Description')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

