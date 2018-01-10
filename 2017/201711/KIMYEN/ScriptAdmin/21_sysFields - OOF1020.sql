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
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'0'
set @TabIndexGrid=N'0'
set @TabIndexPopup=N'0'
set @TabIndexView=N'0'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'APK'
set @sysDataTypeID=N'1'
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
set @FieldID=N'APK_OOT1020'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'APK_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0004')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh') 
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'4'
set @TabIndex=N'1'
set @TabIndexGrid=N'1'
set @TabIndexPopup=null
set @TabIndexView=N'1'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'DivisionID'
set @sysDataTypeID=N'1'
set @GridVisible=N'1'
set @FieldVisible=N'1'
set @PopupVisible=N'0'
set @ViewVisible=N'1'
set @UniqueField=N'0'
set @RefTable=null 
set @MaxLenght=null 
set @SpecialControl=null 
set @RefDisplayField=null 
set @RefValueField=null 
set @RefViewTable=null 
set @FieldID=N'DivisionID_OOT1020'
set @GridWidth=N'100'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'DivisionID_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh') 
set @sysTable=N'OOT1020'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'2'
set @TabIndexGrid=N'2'
set @TabIndexPopup=N'1'
set @TabIndexView=N'2'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProcessID'
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
set @FieldID=N'ProcessID_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition = N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProcessID_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh')
set @sysTable=N'OOT1020'
set @AllowNull=N'0'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'3'
set @TabIndexGrid=N'3'
set @TabIndexPopup=N'2'
set @TabIndexView=N'3'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'ProcessName'
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
set @FieldID=N'ProcessName_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'ProcessName_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_VViewIsCommon')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh')
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'2'
set @TabIndex=N'4'
set @TabIndexGrid=N'7'
set @TabIndexPopup=N'5'
set @TabIndexView=N'4'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'IsCommon'
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
set @FieldID=N'IsCommon_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'IsCommon_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=(select top 1 sysComboBoxID from sysComboBox where ComboBoxID = 'CB_0012')
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh')
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'2'
set @TabIndex=N'5'
set @TabIndexGrid=N'8'
set @TabIndexPopup=N'4'
set @TabIndexView=N'5'
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
set @FieldID=N'Disabled_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Disabled_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh')
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'13'
set @TabIndex=N'6'
set @TabIndexGrid=null
set @TabIndexPopup=N'6'
set @TabIndexView=N'6'
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
set @FieldID=N'Description_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=N'3'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Description_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'7'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=N'7'
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
set @FieldID=N'RelatedToTypeID_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'RelatedToTypeID_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='OOF1022.XemChiTietQuyTrinh')
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'8'
set @TabIndexGrid=N'4'
set @TabIndexPopup=N'3'
set @TabIndexView=N'8'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'Orders'
set @sysDataTypeID=N'5'
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
set @FieldID=N'Orders_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=N'0'
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'Orders_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=N'9'
set @TabIndexGrid=N'6'
set @TabIndexPopup=null
set @TabIndexView=N'9'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CreateDate'
set @sysDataTypeID=N'9'
set @GridVisible=N'1'
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
set @FieldID=N'CreateDate_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateDate_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'10'
set @TabIndexGrid=N'5'
set @TabIndexPopup=null
set @TabIndexView=N'10'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'CreateUserID'
set @sysDataTypeID=N'7'
set @GridVisible=N'1'
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
set @FieldID=N'CreateUserID_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'CreateUserID_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'5'
set @TabIndex=N'11'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=N'11'
set @MinValue=null 
set @MaxValue=null 
set @DefaultValue=null 
set @Visible=N'1'
set @ColumnName=N'LastModifyDate'
set @sysDataTypeID=N'9'
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
set @FieldID=N'LastModifyDate_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyDate_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=(select top 1 convert(varchar(50),sysGroupID) from sysGroup where GroupID='GR.HeThong') 
set @sysTable=N'OOT1020'
set @AllowNull=N'1'
set @ReadOnly=N'0'
set @Type=N'1'
set @TabIndex=N'12'
set @TabIndexGrid=null
set @TabIndexPopup=null
set @TabIndexView=N'12'
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
set @FieldID=N'LastModifyUserID_OOT1020'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'LastModifyUserID_OOT1020')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End

set @sysComboBoxID=null
set @sysRegularID=null
set @sysEditorTemplateID=null
set @sysClientTemplateID=null
set @GroupID=null
set @sysTable=N'VViewIsCommon'
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
set @FieldID=N'VViewIsCommon_Description'
set @GridWidth=N'100'
set @LayoutPosition=null
If not exists(select top 1 1 from [dbo].[sysFields] where  [FieldID] = N'VViewIsCommon_Description')Begin 
insert into sysFields(sysTable,AllowNull,ReadOnly,sysComboBoxID,Type,TabIndex,TabIndexGrid,TabIndexPopup,TabIndexView,MinValue,MaxValue,DefaultValue,Visible,ColumnName,sysRegularID,sysDataTypeID,GridVisible,FieldVisible,PopupVisible,ViewVisible,UniqueField,RefTable,GroupID,sysEditorTemplateID,MaxLenght,SpecialControl,RefDisplayField,RefValueField,RefViewTable,sysClientTemplateID,FieldID,GridWidth,LayoutPosition)values(@sysTable,@AllowNull,@ReadOnly,@sysComboBoxID,@Type,@TabIndex,@TabIndexGrid,@TabIndexPopup,@TabIndexView,@MinValue,@MaxValue,@DefaultValue,@Visible,@ColumnName,@sysRegularID,@sysDataTypeID,@GridVisible,@FieldVisible,@PopupVisible,@ViewVisible,@UniqueField,@RefTable,@GroupID,@sysEditorTemplateID,@MaxLenght,@SpecialControl,@RefDisplayField,@RefValueField,@RefViewTable,@sysClientTemplateID,@FieldID,@GridWidth,@LayoutPosition)
End
