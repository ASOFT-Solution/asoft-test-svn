namespace ToKhaiThueGTGT
{
    partial class LaySoLieu
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
            this.grdDetail = new DevExpress.XtraGrid.GridControl();
            this.gridView2 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colSTT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colChiTieu = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colCodeGT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colGTHHDV = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colCodeThue = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colThueGTGT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colSortOrder = new DevExpress.XtraGrid.Columns.GridColumn();
            this.chk21 = new DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit();
            this.btnClose = new DevExpress.XtraEditors.SimpleButton();
            this.btnSave = new DevExpress.XtraEditors.SimpleButton();
            this.layoutControlGroup1 = new DevExpress.XtraLayout.LayoutControlGroup();
            this.layoutControlItem1 = new DevExpress.XtraLayout.LayoutControlItem();
            this.emptySpaceItem5 = new DevExpress.XtraLayout.EmptySpaceItem();
            this.layoutControlItem5 = new DevExpress.XtraLayout.LayoutControlItem();
            this.layoutControlItem3 = new DevExpress.XtraLayout.LayoutControlItem();
            this.emptySpaceItem1 = new DevExpress.XtraLayout.EmptySpaceItem();
            this.gridColumn1 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn2 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.emptySpaceItem2 = new DevExpress.XtraLayout.EmptySpaceItem();
            this.gridColumn3 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn4 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn5 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn6 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn7 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn8 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn9 = new DevExpress.XtraGrid.Columns.GridColumn();
            this.gridColumn10 = new DevExpress.XtraGrid.Columns.GridColumn();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControl1)).BeginInit();
            this.layoutControl1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.grdDetail)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.chk21)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlGroup1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem2)).BeginInit();
            this.SuspendLayout();
            // 
            // layoutControl1
            // 
            this.layoutControl1.Controls.Add(this.grdDetail);
            this.layoutControl1.Controls.Add(this.btnClose);
            this.layoutControl1.Controls.Add(this.btnSave);
            this.layoutControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.layoutControl1.Location = new System.Drawing.Point(0, 0);
            this.layoutControl1.Name = "layoutControl1";
            this.layoutControl1.Root = this.layoutControlGroup1;
            this.layoutControl1.Size = new System.Drawing.Size(914, 637);
            this.layoutControl1.TabIndex = 0;
            this.layoutControl1.Text = "layoutControl1";
            // 
            // grdDetail
            // 
            this.grdDetail.Location = new System.Drawing.Point(6, 6);
            this.grdDetail.MainView = this.gridView2;
            this.grdDetail.Name = "grdDetail";
            this.grdDetail.RepositoryItems.AddRange(new DevExpress.XtraEditors.Repository.RepositoryItem[] {
            this.chk21});
            this.grdDetail.Size = new System.Drawing.Size(902, 579);
            this.grdDetail.TabIndex = 5;
            this.grdDetail.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.gridView2});
            // 
            // gridView2
            // 
            this.gridView2.Appearance.HeaderPanel.Options.UseTextOptions = true;
            this.gridView2.Appearance.HeaderPanel.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.gridView2.Columns.AddRange(new DevExpress.XtraGrid.Columns.GridColumn[] {
            this.colSTT,
            this.colChiTieu,
            this.colCodeGT,
            this.colGTHHDV,
            this.colCodeThue,
            this.colThueGTGT,
            this.colSortOrder});
            this.gridView2.CustomizationFormBounds = new System.Drawing.Rectangle(981, 376, 208, 170);
            this.gridView2.GridControl = this.grdDetail;
            this.gridView2.Name = "gridView2";
            this.gridView2.OptionsBehavior.Editable = false;
            this.gridView2.OptionsCustomization.AllowGroup = false;
            this.gridView2.OptionsView.ShowGroupPanel = false;
            this.gridView2.ValidatingEditor += new DevExpress.XtraEditors.Controls.BaseContainerValidateEditorEventHandler(this.gridView2_ValidatingEditor);
            this.gridView2.CellValueChanged += new DevExpress.XtraGrid.Views.Base.CellValueChangedEventHandler(this.gridView2_CellValueChanged);
            this.gridView2.CustomRowCellEdit += new DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventHandler(this.gridView2_CustomRowCellEdit);
            this.gridView2.ShowingEditor += new System.ComponentModel.CancelEventHandler(this.gridView2_ShowingEditor);
            // 
            // colSTT
            // 
            this.colSTT.AppearanceCell.Options.UseTextOptions = true;
            this.colSTT.AppearanceCell.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.colSTT.Caption = "STT";
            this.colSTT.FieldName = "Stt";
            this.colSTT.Name = "colSTT";
            this.colSTT.Visible = true;
            this.colSTT.VisibleIndex = 0;
            this.colSTT.Width = 39;
            // 
            // colChiTieu
            // 
            this.colChiTieu.Caption = "Chỉ tiêu";
            this.colChiTieu.FieldName = "ChiTieu";
            this.colChiTieu.Name = "colChiTieu";
            this.colChiTieu.Visible = true;
            this.colChiTieu.VisibleIndex = 1;
            this.colChiTieu.Width = 395;
            // 
            // colCodeGT
            // 
            this.colCodeGT.AppearanceCell.Options.UseTextOptions = true;
            this.colCodeGT.AppearanceCell.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.colCodeGT.Caption = "Mã Giá trị HHDV";
            this.colCodeGT.FieldName = "CodeGT";
            this.colCodeGT.Name = "colCodeGT";
            this.colCodeGT.Visible = true;
            this.colCodeGT.VisibleIndex = 2;
            this.colCodeGT.Width = 107;
            // 
            // colGTHHDV
            // 
            this.colGTHHDV.AppearanceCell.Options.UseTextOptions = true;
            this.colGTHHDV.AppearanceCell.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.colGTHHDV.Caption = "Giá trị HHDV";
            this.colGTHHDV.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.colGTHHDV.FieldName = "GTHHDV";
            this.colGTHHDV.Name = "colGTHHDV";
            this.colGTHHDV.Visible = true;
            this.colGTHHDV.VisibleIndex = 3;
            this.colGTHHDV.Width = 118;
            // 
            // colCodeThue
            // 
            this.colCodeThue.AppearanceCell.Options.UseTextOptions = true;
            this.colCodeThue.AppearanceCell.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.colCodeThue.Caption = "Mã thuế GTGT";
            this.colCodeThue.FieldName = "CodeThue";
            this.colCodeThue.Name = "colCodeThue";
            this.colCodeThue.Visible = true;
            this.colCodeThue.VisibleIndex = 4;
            this.colCodeThue.Width = 96;
            // 
            // colThueGTGT
            // 
            this.colThueGTGT.AppearanceCell.Options.UseTextOptions = true;
            this.colThueGTGT.AppearanceCell.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.colThueGTGT.Caption = "Thuế GTGT";
            this.colThueGTGT.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.colThueGTGT.FieldName = "ThueGTGT";
            this.colThueGTGT.Name = "colThueGTGT";
            this.colThueGTGT.Visible = true;
            this.colThueGTGT.VisibleIndex = 5;
            this.colThueGTGT.Width = 125;
            // 
            // colSortOrder
            // 
            this.colSortOrder.Caption = "SortOrder";
            this.colSortOrder.FieldName = "SortOrder";
            this.colSortOrder.Name = "colSortOrder";
            // 
            // chk21
            // 
            this.chk21.AutoHeight = false;
            this.chk21.Name = "chk21";
            this.chk21.ValueChecked = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.chk21.ValueUnchecked = new decimal(new int[] {
            0,
            0,
            0,
            0});
            this.chk21.CheckedChanged += new System.EventHandler(this.checkEdit_CheckedChanged);
            // 
            // btnClose
            // 
            this.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnClose.Location = new System.Drawing.Point(790, 595);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(118, 22);
            this.btnClose.StyleController = this.layoutControl1;
            this.btnClose.TabIndex = 4;
            this.btnClose.Text = "ESC-Thoát";
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnSave
            // 
            this.btnSave.Location = new System.Drawing.Point(672, 595);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(108, 22);
            this.btnSave.StyleController = this.layoutControl1;
            this.btnSave.TabIndex = 3;
            this.btnSave.Text = "F12-Lưu";
            this.btnSave.Visible = false;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // layoutControlGroup1
            // 
            this.layoutControlGroup1.CustomizationFormText = "layoutControlGroup1";
            this.layoutControlGroup1.Items.AddRange(new DevExpress.XtraLayout.BaseLayoutItem[] {
            this.layoutControlItem1,
            this.emptySpaceItem5,
            this.layoutControlItem5,
            this.layoutControlItem3,
            this.emptySpaceItem1});
            this.layoutControlGroup1.Location = new System.Drawing.Point(0, 0);
            this.layoutControlGroup1.Name = "layoutControlGroup1";
            this.layoutControlGroup1.Padding = new DevExpress.XtraLayout.Utils.Padding(0, 0, 0, 0);
            this.layoutControlGroup1.Size = new System.Drawing.Size(914, 637);
            this.layoutControlGroup1.Text = "layoutControlGroup1";
            this.layoutControlGroup1.TextVisible = false;
            // 
            // layoutControlItem1
            // 
            this.layoutControlItem1.Control = this.btnSave;
            this.layoutControlItem1.CustomizationFormText = "layoutControlItem1";
            this.layoutControlItem1.Location = new System.Drawing.Point(666, 589);
            this.layoutControlItem1.Name = "layoutControlItem1";
            this.layoutControlItem1.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
            this.layoutControlItem1.Size = new System.Drawing.Size(118, 32);
            this.layoutControlItem1.Text = "layoutControlItem1";
            this.layoutControlItem1.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem1.TextToControlDistance = 0;
            this.layoutControlItem1.TextVisible = false;
            // 
            // emptySpaceItem5
            // 
            this.emptySpaceItem5.AllowHotTrack = false;
            this.emptySpaceItem5.CustomizationFormText = "emptySpaceItem5";
            this.emptySpaceItem5.Location = new System.Drawing.Point(0, 621);
            this.emptySpaceItem5.Name = "emptySpaceItem5";
            this.emptySpaceItem5.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
            this.emptySpaceItem5.Size = new System.Drawing.Size(912, 14);
            this.emptySpaceItem5.Text = "emptySpaceItem5";
            this.emptySpaceItem5.TextSize = new System.Drawing.Size(0, 0);
            // 
            // layoutControlItem5
            // 
            this.layoutControlItem5.Control = this.btnClose;
            this.layoutControlItem5.CustomizationFormText = "layoutControlItem5";
            this.layoutControlItem5.Location = new System.Drawing.Point(784, 589);
            this.layoutControlItem5.Name = "layoutControlItem5";
            this.layoutControlItem5.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
            this.layoutControlItem5.Size = new System.Drawing.Size(128, 32);
            this.layoutControlItem5.Text = "layoutControlItem5";
            this.layoutControlItem5.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem5.TextToControlDistance = 0;
            this.layoutControlItem5.TextVisible = false;
            // 
            // layoutControlItem3
            // 
            this.layoutControlItem3.Control = this.grdDetail;
            this.layoutControlItem3.CustomizationFormText = "layoutControlItem3";
            this.layoutControlItem3.Location = new System.Drawing.Point(0, 0);
            this.layoutControlItem3.Name = "layoutControlItem3";
            this.layoutControlItem3.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
            this.layoutControlItem3.Size = new System.Drawing.Size(912, 589);
            this.layoutControlItem3.Text = "layoutControlItem3";
            this.layoutControlItem3.TextSize = new System.Drawing.Size(0, 0);
            this.layoutControlItem3.TextToControlDistance = 0;
            this.layoutControlItem3.TextVisible = false;
            // 
            // emptySpaceItem1
            // 
            this.emptySpaceItem1.AllowHotTrack = false;
            this.emptySpaceItem1.CustomizationFormText = "emptySpaceItem1";
            this.emptySpaceItem1.Location = new System.Drawing.Point(0, 589);
            this.emptySpaceItem1.Name = "emptySpaceItem1";
            this.emptySpaceItem1.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
            this.emptySpaceItem1.Size = new System.Drawing.Size(666, 32);
            this.emptySpaceItem1.Text = "emptySpaceItem1";
            this.emptySpaceItem1.TextSize = new System.Drawing.Size(0, 0);
            // 
            // gridColumn1
            // 
            this.gridColumn1.Caption = "Mã nhóm";
            this.gridColumn1.FieldName = "MaNhom";
            this.gridColumn1.Name = "gridColumn1";
            this.gridColumn1.Visible = true;
            this.gridColumn1.VisibleIndex = 0;
            // 
            // gridColumn2
            // 
            this.gridColumn2.Caption = "Tên nhóm";
            this.gridColumn2.FieldName = "TenNhom";
            this.gridColumn2.Name = "gridColumn2";
            this.gridColumn2.Visible = true;
            this.gridColumn2.VisibleIndex = 1;
            // 
            // emptySpaceItem2
            // 
            this.emptySpaceItem2.AllowHotTrack = false;
            this.emptySpaceItem2.CustomizationFormText = "emptySpaceItem2";
            this.emptySpaceItem2.Location = new System.Drawing.Point(0, 135);
            this.emptySpaceItem2.Name = "emptySpaceItem2";
            this.emptySpaceItem2.Size = new System.Drawing.Size(332, 37);
            this.emptySpaceItem2.Text = "emptySpaceItem2";
            this.emptySpaceItem2.TextSize = new System.Drawing.Size(0, 0);
            // 
            // gridColumn3
            // 
            this.gridColumn3.Caption = "Tài khoản";
            this.gridColumn3.FieldName = "tk";
            this.gridColumn3.Name = "gridColumn3";
            this.gridColumn3.Visible = true;
            this.gridColumn3.VisibleIndex = 0;
            this.gridColumn3.Width = 57;
            // 
            // gridColumn4
            // 
            this.gridColumn4.Caption = "Khách hàng";
            this.gridColumn4.FieldName = "makh";
            this.gridColumn4.Name = "gridColumn4";
            this.gridColumn4.Visible = true;
            this.gridColumn4.VisibleIndex = 1;
            this.gridColumn4.Width = 69;
            // 
            // gridColumn5
            // 
            this.gridColumn5.Caption = "Tên khách hàng";
            this.gridColumn5.FieldName = "tenkh";
            this.gridColumn5.Name = "gridColumn5";
            this.gridColumn5.Visible = true;
            this.gridColumn5.VisibleIndex = 2;
            this.gridColumn5.Width = 210;
            // 
            // gridColumn6
            // 
            this.gridColumn6.Caption = "Tiền lãi";
            this.gridColumn6.DisplayFormat.FormatString = "### ### ##0";
            this.gridColumn6.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.gridColumn6.FieldName = "tienLai";
            this.gridColumn6.Name = "gridColumn6";
            this.gridColumn6.Visible = true;
            this.gridColumn6.VisibleIndex = 3;
            this.gridColumn6.Width = 80;
            // 
            // gridColumn7
            // 
            this.gridColumn7.Caption = "Tiền lỗ";
            this.gridColumn7.DisplayFormat.FormatString = "### ### ##0";
            this.gridColumn7.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.gridColumn7.FieldName = "tienLo";
            this.gridColumn7.Name = "gridColumn7";
            this.gridColumn7.Visible = true;
            this.gridColumn7.VisibleIndex = 4;
            this.gridColumn7.Width = 80;
            // 
            // gridColumn8
            // 
            this.gridColumn8.Caption = "Bộ phận";
            this.gridColumn8.FieldName = "mabp";
            this.gridColumn8.Name = "gridColumn8";
            this.gridColumn8.Visible = true;
            this.gridColumn8.VisibleIndex = 5;
            this.gridColumn8.Width = 80;
            // 
            // gridColumn9
            // 
            this.gridColumn9.Caption = "Hợp đồng";
            this.gridColumn9.FieldName = "mavv";
            this.gridColumn9.Name = "gridColumn9";
            this.gridColumn9.Visible = true;
            this.gridColumn9.VisibleIndex = 6;
            this.gridColumn9.Width = 80;
            // 
            // gridColumn10
            // 
            this.gridColumn10.Caption = "Khoản mục phí";
            this.gridColumn10.FieldName = "maphi";
            this.gridColumn10.Name = "gridColumn10";
            this.gridColumn10.Visible = true;
            this.gridColumn10.VisibleIndex = 7;
            this.gridColumn10.Width = 102;
            // 
            // LaySoLieu
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnClose;
            this.ClientSize = new System.Drawing.Size(914, 637);
            this.Controls.Add(this.layoutControl1);
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "LaySoLieu";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Thêm mới tờ khai thuế VAT";
            this.Load += new System.EventHandler(this.LaySoLieu_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.LaySoLieu_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.layoutControl1)).EndInit();
            this.layoutControl1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.grdDetail)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.chk21)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlGroup1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.layoutControlItem3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.emptySpaceItem2)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevExpress.XtraLayout.LayoutControl layoutControl1;
        private DevExpress.XtraLayout.LayoutControlGroup layoutControlGroup1;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem5;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn1;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn2;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem2;
        private DevExpress.XtraEditors.SimpleButton btnClose;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem5;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn3;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn4;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn5;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn6;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn7;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn8;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn9;
        private DevExpress.XtraGrid.Columns.GridColumn gridColumn10;
        private DevExpress.XtraGrid.GridControl grdDetail;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView2;
        private DevExpress.XtraGrid.Columns.GridColumn colSTT;
        private DevExpress.XtraGrid.Columns.GridColumn colChiTieu;
        private DevExpress.XtraGrid.Columns.GridColumn colCodeGT;
        private DevExpress.XtraGrid.Columns.GridColumn colGTHHDV;
        private DevExpress.XtraGrid.Columns.GridColumn colCodeThue;
        private DevExpress.XtraGrid.Columns.GridColumn colThueGTGT;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem3;
        private DevExpress.XtraEditors.SimpleButton btnSave;
        private DevExpress.XtraLayout.LayoutControlItem layoutControlItem1;
        private DevExpress.XtraLayout.EmptySpaceItem emptySpaceItem1;
        private DevExpress.XtraGrid.Columns.GridColumn colSortOrder;
        private DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit chk21;
    }
}