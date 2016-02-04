namespace ToKhaiTTDB
{
    partial class DSToKhaiTTDB
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.layoutControl1 = new DevExpress.XtraLayout.LayoutControl();
            this.btnEdit = new DevExpress.XtraEditors.SimpleButton();
            this.gcDetail = new DevExpress.XtraGrid.GridControl();
            this.gvDetail = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.clNgayToKhaiTTDB = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clDeclareType = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clDelareTypeName = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clInputDate = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clKyToKhaiTTDB = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clNamToKhaiTTDB = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clInLanDauName = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clSoLanIn = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clAmendedReturnDate = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clIsOutputAppendix = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clIsInputAppendix = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clDienGiai = new DevExpress.XtraGrid.Columns.GridColumn();
            this.btnCancel = new DevExpress.XtraEditors.SimpleButton();
            this.btnAdd = new DevExpress.XtraEditors.SimpleButton();
            this.btnDelete = new DevExpress.XtraEditors.SimpleButton();
            this.btnEsc = new DevExpress.XtraEditors.SimpleButton();
            this.layoutControlGroup1 = new DevExpress.XtraLayout.LayoutControlGroup();
            this.layoutControlItem1 = new DevExpress.XtraLayout.LayoutControlItem();
            this.layoutControlItem2 = new DevExpress.XtraLayout.LayoutControlItem();
            this.layoutControlItem3 = new DevExpress.XtraLayout.LayoutControlItem();
            this.emptySpaceItem3 = new DevExpress.XtraLayout.EmptySpaceItem();
            this.layoutControlItem4 = new DevExpress.XtraLayout.LayoutControlItem();
            this.layoutControlItem5 = new DevExpress.XtraLayout.LayoutControlItem();
            this.emptySpaceItem1 = new DevExpress.XtraLayout.EmptySpaceItem();
            this.emptySpaceItem2 = new DevExpress.XtraLayout.EmptySpaceItem();
            this.emptySpaceItem4 = new DevExpress.XtraLayout.EmptySpaceItem();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControl1)).BeginInit();
            this.layoutControl1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gcDetail)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gvDetail)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlGroup1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem4)).BeginInit();
            this.SuspendLayout();
            // 
            // layoutControl1
            // 
            this.layoutControl1.Controls.Add(this.btnEdit);
            this.layoutControl1.Controls.Add(this.gcDetail);
            this.layoutControl1.Controls.Add(this.btnCancel);
            this.layoutControl1.Controls.Add(this.btnAdd);
            this.layoutControl1.Controls.Add(this.btnDelete);
            this.layoutControl1.Controls.Add(this.btnEsc);
            this.layoutControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.layoutControl1.Location = new System.Drawing.Point(0, 0);
            this.layoutControl1.Name = "layoutControl1";
            this.layoutControl1.OptionsCustomizationForm.DesignTimeCustomizationFormPositionAndSize = new System.Drawing.Rectangle(283, 204, 250, 350);
            this.layoutControl1.Root = this.layoutControlGroup1;
            this.layoutControl1.Size = new System.Drawing.Size(936, 431);
            this.layoutControl1.TabIndex = 0;
            this.layoutControl1.Text = "layoutControl1";
            // 
            // btnEdit
            // 
            this.btnEdit.Location = new System.Drawing.Point(648, 397);
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Size = new System.Drawing.Size(88, 22);
            this.btnEdit.StyleController = this.layoutControl1;
            this.btnEdit.TabIndex = 7;
            this.btnEdit.Text = "F3-Sửa";
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // gcDetail
            // 
            this.gcDetail.Location = new System.Drawing.Point(12, 12);
            this.gcDetail.MainView = this.gvDetail;
            this.gcDetail.Name = "gcDetail";
            this.gcDetail.Size = new System.Drawing.Size(912, 381);
            this.gcDetail.TabIndex = 6;
            this.gcDetail.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.gvDetail});
            // 
            // gvDetail
            // 
            this.gvDetail.Columns.AddRange(new DevExpress.XtraGrid.Columns.GridColumn[] {
            this.clNgayToKhaiTTDB,
            this.clDeclareType,
            this.clDelareTypeName,
            this.clInputDate,
            this.clKyToKhaiTTDB,
            this.clNamToKhaiTTDB,
            this.clInLanDauName,
            this.clSoLanIn,
            this.clAmendedReturnDate,
            this.clIsOutputAppendix,
            this.clIsInputAppendix,
            this.clDienGiai});
            this.gvDetail.GridControl = this.gcDetail;
            this.gvDetail.Name = "gvDetail";
            this.gvDetail.OptionsBehavior.Editable = false;
            this.gvDetail.OptionsCustomization.AllowGroup = false;
            this.gvDetail.OptionsView.ShowGroupPanel = false;
            // 
            // clNgayToKhaiTTDB
            // 
            this.clNgayToKhaiTTDB.Caption = "Ngày chứng từ";
            this.clNgayToKhaiTTDB.FieldName = "NgayToKhaiTTDB";
            this.clNgayToKhaiTTDB.Name = "clNgayToKhaiTTDB";
            this.clNgayToKhaiTTDB.Visible = true;
            this.clNgayToKhaiTTDB.VisibleIndex = 0;
            this.clNgayToKhaiTTDB.Width = 38;
            // 
            // clDeclareType
            // 
            this.clDeclareType.Caption = "Kỳ tính thuế";
            this.clDeclareType.FieldName = "DeclareType";
            this.clDeclareType.Name = "clDeclareType";
            this.clDeclareType.Visible = true;
            this.clDeclareType.VisibleIndex = 1;
            this.clDeclareType.Width = 23;
            // 
            // clDelareTypeName
            // 
            this.clDelareTypeName.Caption = "Tên kỳ tính thuế";
            this.clDelareTypeName.FieldName = "DeclareTypeName";
            this.clDelareTypeName.Name = "clDelareTypeName";
            this.clDelareTypeName.Visible = true;
            this.clDelareTypeName.VisibleIndex = 2;
            this.clDelareTypeName.Width = 44;
            // 
            // clInputDate
            // 
            this.clInputDate.Caption = "Ngày tính thuế";
            this.clInputDate.FieldName = "InputDate";
            this.clInputDate.Name = "clInputDate";
            this.clInputDate.Visible = true;
            this.clInputDate.VisibleIndex = 3;
            this.clInputDate.Width = 38;
            // 
            // clKyToKhaiTTDB
            // 
            this.clKyToKhaiTTDB.Caption = "Tháng";
            this.clKyToKhaiTTDB.FieldName = "KyToKhaiTTDB";
            this.clKyToKhaiTTDB.Name = "clKyToKhaiTTDB";
            this.clKyToKhaiTTDB.Visible = true;
            this.clKyToKhaiTTDB.VisibleIndex = 4;
            this.clKyToKhaiTTDB.Width = 30;
            // 
            // clNamToKhaiTTDB
            // 
            this.clNamToKhaiTTDB.Caption = "Năm";
            this.clNamToKhaiTTDB.FieldName = "NamToKhaiTTDB";
            this.clNamToKhaiTTDB.Name = "clNamToKhaiTTDB";
            this.clNamToKhaiTTDB.Visible = true;
            this.clNamToKhaiTTDB.VisibleIndex = 5;
            this.clNamToKhaiTTDB.Width = 30;
            // 
            // clInLanDauName
            // 
            this.clInLanDauName.Caption = "In lần đầu";
            this.clInLanDauName.FieldName = "InLanDauName";
            this.clInLanDauName.MinWidth = 40;
            this.clInLanDauName.Name = "clInLanDauName";
            this.clInLanDauName.Visible = true;
            this.clInLanDauName.VisibleIndex = 6;
            this.clInLanDauName.Width = 64;
            // 
            // clSoLanIn
            // 
            this.clSoLanIn.Caption = "Bổ sung lần thứ";
            this.clSoLanIn.FieldName = "SoLanIn";
            this.clSoLanIn.Name = "clSoLanIn";
            this.clSoLanIn.Visible = true;
            this.clSoLanIn.VisibleIndex = 7;
            this.clSoLanIn.Width = 23;
            // 
            // clAmendedReturnDate
            // 
            this.clAmendedReturnDate.Caption = "Ngày lập KHBS";
            this.clAmendedReturnDate.FieldName = "AmendedReturnDate";
            this.clAmendedReturnDate.Name = "clAmendedReturnDate";
            this.clAmendedReturnDate.Visible = true;
            this.clAmendedReturnDate.VisibleIndex = 8;
            this.clAmendedReturnDate.Width = 34;
            // 
            // clIsOutputAppendix
            // 
            this.clIsOutputAppendix.Caption = "Phụ lục thuế TTDB bán ra";
            this.clIsOutputAppendix.FieldName = "IsOutputAppendix";
            this.clIsOutputAppendix.Name = "clIsOutputAppendix";
            this.clIsOutputAppendix.Visible = true;
            this.clIsOutputAppendix.VisibleIndex = 9;
            this.clIsOutputAppendix.Width = 40;
            // 
            // clIsInputAppendix
            // 
            this.clIsInputAppendix.Caption = "Phụ lục thuế TTDB mua vào";
            this.clIsInputAppendix.FieldName = "IsInputAppendix";
            this.clIsInputAppendix.Name = "clIsInputAppendix";
            this.clIsInputAppendix.Visible = true;
            this.clIsInputAppendix.VisibleIndex = 10;
            this.clIsInputAppendix.Width = 47;
            // 
            // clDienGiai
            // 
            this.clDienGiai.Caption = "Diễn giải";
            this.clDienGiai.FieldName = "DienGiai";
            this.clDienGiai.Name = "clDienGiai";
            this.clDienGiai.Visible = true;
            this.clDienGiai.VisibleIndex = 11;
            this.clDienGiai.Width = 87;
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(981, 12);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(72, 22);
            this.btnCancel.StyleController = this.layoutControl1;
            this.btnCancel.TabIndex = 2;
            this.btnCancel.Text = "ESC-Thoát";
            // 
            // btnAdd
            // 
            this.btnAdd.Location = new System.Drawing.Point(531, 397);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(101, 22);
            this.btnAdd.StyleController = this.layoutControl1;
            this.btnAdd.TabIndex = 4;
            this.btnAdd.Text = "F2-Thêm";
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.Location = new System.Drawing.Point(750, 397);
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(81, 22);
            this.btnDelete.StyleController = this.layoutControl1;
            this.btnDelete.TabIndex = 3;
            this.btnDelete.Text = "F4-Xóa";
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // btnEsc
            // 
            this.btnEsc.Location = new System.Drawing.Point(847, 397);
            this.btnEsc.Name = "btnEsc";
            this.btnEsc.Size = new System.Drawing.Size(77, 22);
            this.btnEsc.StyleController = this.layoutControl1;
            this.btnEsc.TabIndex = 2;
            this.btnEsc.Text = "ESC-Thoát";
            this.btnEsc.Click += new System.EventHandler(this.btnEsc_Click);
            // 
            // layoutControlGroup1
            // 
            this.layoutControlGroup1.CustomizationFormText = "Root";
            this.layoutControlGroup1.EnableIndentsWithoutBorders = DevExpress.Utils.DefaultBoolean.True;
            this.layoutControlGroup1.GroupBordersVisible = false;
            this.layoutControlGroup1.Items.AddRange(new DevExpress.XtraLayout.BaseLayoutItem[] {
            this.layoutControlItem1,
            this.layoutControlItem2,
            this.layoutControlItem3,
            this.emptySpaceItem3,
            this.layoutControlItem4,
            this.layoutControlItem5,
            this.emptySpaceItem1,
            this.emptySpaceItem2,
            this.emptySpaceItem4});
            this.layoutControlGroup1.Location = new System.Drawing.Point(0, 0);
            this.layoutControlGroup1.Name = "Root";
            this.layoutControlGroup1.Size = new System.Drawing.Size(936, 431);
            this.layoutControlGroup1.Text = "Root";
            this.layoutControlGroup1.TextVisible = false;
            // 
            // layoutControlItem1
            // 
            this.layoutControlItem1.Control = this.gcDetail;
            this.layoutControlItem1.CustomizationFormText = "layoutControlItem1";
            this.layoutControlItem1.Location = new System.Drawing.Point(0, 0);
            this.layoutControlItem1.Name = "layoutControlItem1";
            this.layoutControlItem1.Size = new System.Drawing.Size(916, 385);
            this.layoutControlItem1.Text = "layoutControlItem1";
            this.layoutControlItem1.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem1.TextToControlDistance = 0;
            this.layoutControlItem1.TextVisible = false;
            // 
            // layoutControlItem2
            // 
            this.layoutControlItem2.Control = this.btnEsc;
            this.layoutControlItem2.CustomizationFormText = "layoutControlItem2";
            this.layoutControlItem2.Location = new System.Drawing.Point(835, 385);
            this.layoutControlItem2.Name = "layoutControlItem2";
            this.layoutControlItem2.Size = new System.Drawing.Size(81, 26);
            this.layoutControlItem2.Text = "layoutControlItem2";
            this.layoutControlItem2.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem2.TextToControlDistance = 0;
            this.layoutControlItem2.TextVisible = false;
            // 
            // layoutControlItem3
            // 
            this.layoutControlItem3.Control = this.btnDelete;
            this.layoutControlItem3.CustomizationFormText = "layoutControlItem3";
            this.layoutControlItem3.Location = new System.Drawing.Point(738, 385);
            this.layoutControlItem3.Name = "layoutControlItem3";
            this.layoutControlItem3.Size = new System.Drawing.Size(85, 26);
            this.layoutControlItem3.Text = "layoutControlItem3";
            this.layoutControlItem3.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem3.TextToControlDistance = 0;
            this.layoutControlItem3.TextVisible = false;
            // 
            // emptySpaceItem3
            // 
            this.emptySpaceItem3.AllowHotTrack = false;
            this.emptySpaceItem3.CustomizationFormText = "emptySpaceItem3";
            this.emptySpaceItem3.Location = new System.Drawing.Point(0, 385);
            this.emptySpaceItem3.Name = "emptySpaceItem3";
            this.emptySpaceItem3.Size = new System.Drawing.Size(519, 26);
            this.emptySpaceItem3.Text = "emptySpaceItem3";
            this.emptySpaceItem3.TextSize = new System.Drawing.Size(0, 0);
            // 
            // layoutControlItem4
            // 
            this.layoutControlItem4.Control = this.btnAdd;
            this.layoutControlItem4.CustomizationFormText = "layoutControlItem4";
            this.layoutControlItem4.Location = new System.Drawing.Point(519, 385);
            this.layoutControlItem4.Name = "layoutControlItem4";
            this.layoutControlItem4.Size = new System.Drawing.Size(105, 26);
            this.layoutControlItem4.Text = "layoutControlItem4";
            this.layoutControlItem4.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem4.TextToControlDistance = 0;
            this.layoutControlItem4.TextVisible = false;
            // 
            // layoutControlItem5
            // 
            this.layoutControlItem5.Control = this.btnEdit;
            this.layoutControlItem5.CustomizationFormText = "layoutControlItem5";
            this.layoutControlItem5.Location = new System.Drawing.Point(636, 385);
            this.layoutControlItem5.Name = "layoutControlItem5";
            this.layoutControlItem5.Size = new System.Drawing.Size(92, 26);
            this.layoutControlItem5.Text = "layoutControlItem5";
            this.layoutControlItem5.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem5.TextToControlDistance = 0;
            this.layoutControlItem5.TextVisible = false;
            // 
            // emptySpaceItem1
            // 
            this.emptySpaceItem1.AllowHotTrack = false;
            this.emptySpaceItem1.CustomizationFormText = "emptySpaceItem1";
            this.emptySpaceItem1.Location = new System.Drawing.Point(624, 385);
            this.emptySpaceItem1.Name = "emptySpaceItem1";
            this.emptySpaceItem1.Size = new System.Drawing.Size(12, 26);
            this.emptySpaceItem1.Text = "emptySpaceItem1";
            this.emptySpaceItem1.TextSize = new System.Drawing.Size(0, 0);
            // 
            // emptySpaceItem2
            // 
            this.emptySpaceItem2.AllowHotTrack = false;
            this.emptySpaceItem2.CustomizationFormText = "emptySpaceItem2";
            this.emptySpaceItem2.Location = new System.Drawing.Point(728, 385);
            this.emptySpaceItem2.Name = "emptySpaceItem2";
            this.emptySpaceItem2.Size = new System.Drawing.Size(10, 26);
            this.emptySpaceItem2.Text = "emptySpaceItem2";
            this.emptySpaceItem2.TextSize = new System.Drawing.Size(0, 0);
            // 
            // emptySpaceItem4
            // 
            this.emptySpaceItem4.AllowHotTrack = false;
            this.emptySpaceItem4.CustomizationFormText = "emptySpaceItem4";
            this.emptySpaceItem4.Location = new System.Drawing.Point(823, 385);
            this.emptySpaceItem4.Name = "emptySpaceItem4";
            this.emptySpaceItem4.Size = new System.Drawing.Size(12, 26);
            this.emptySpaceItem4.Text = "emptySpaceItem4";
            this.emptySpaceItem4.TextSize = new System.Drawing.Size(0, 0);
            // 
            // DSToKhaiTTDB
            // 
            this.Appearance.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Appearance.Options.UseFont = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(936, 431);
            this.Controls.Add(this.layoutControl1);
            this.KeyPreview = true;
            this.Name = "DSToKhaiTTDB";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "DANH MỤC TỜ KHAI THUẾ TIÊU THỤ ĐẶC BIỆT";
            this.Load += new System.EventHandler(this.DSToKhaiTTDB_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.DSToKhaiTTDB_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.layoutControl1)).EndInit();
            this.layoutControl1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.gcDetail)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gvDetail)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlGroup1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem4)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevExpress.XtraLayout.LayoutControl layoutControl1;
        private DevExpress.XtraLayout.LayoutControlGroup layoutControlGroup1;
        private DevExpress.XtraGrid.GridControl gcDetail;
        private DevExpress.XtraGrid.Views.Grid.GridView gvDetail;
        private DevExpress.XtraGrid.Columns.GridColumn clNgayToKhaiTTDB;
        private DevExpress.XtraGrid.Columns.GridColumn clDeclareType;
        private DevExpress.XtraGrid.Columns.GridColumn clDelareTypeName;
        private DevExpress.XtraGrid.Columns.GridColumn clInputDate;
        private DevExpress.XtraGrid.Columns.GridColumn clKyToKhaiTTDB;
        private DevExpress.XtraGrid.Columns.GridColumn clNamToKhaiTTDB;
        private DevExpress.XtraGrid.Columns.GridColumn clInLanDauName;
        private DevExpress.XtraGrid.Columns.GridColumn clSoLanIn;
        private DevExpress.XtraGrid.Columns.GridColumn clAmendedReturnDate;
        private DevExpress.XtraGrid.Columns.GridColumn clIsOutputAppendix;
        private DevExpress.XtraGrid.Columns.GridColumn clIsInputAppendix;
        private DevExpress.XtraGrid.Columns.GridColumn clDienGiai;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem1;
        private DevExpress.XtraEditors.SimpleButton btnCancel;
        private DevExpress.XtraEditors.SimpleButton btnEsc;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem2;
        private DevExpress.XtraEditors.SimpleButton btnDelete;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem3;
        private DevExpress.XtraEditors.SimpleButton btnAdd;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem3;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem4;
        private DevExpress.XtraEditors.SimpleButton btnEdit;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem5;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem1;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem2;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem4;

    }
}