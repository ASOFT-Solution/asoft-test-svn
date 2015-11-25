namespace FormChinhSachGia
{
    partial class FrmCSGTheoKH
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
            this.components = new System.ComponentModel.Container();
            this.gcPN = new DevExpress.XtraGrid.GridControl();
            this.gvPN = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.clMaVT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clTenVT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clMaDVT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clGia = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clSelect = new DevExpress.XtraGrid.Columns.GridColumn();
            this.repositoryItemCheckEdit1 = new DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit();
            this.clMaKH = new DevExpress.XtraGrid.Columns.GridColumn();
            this.clTenKH = new DevExpress.XtraGrid.Columns.GridColumn();
            this.repositoryItemTextEdit1 = new DevExpress.XtraEditors.Repository.RepositoryItemTextEdit();
            this.repositoryItemCheckEdit2 = new DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit();
            this.btCancel = new DevExpress.XtraEditors.SimpleButton();
            this.btOk = new DevExpress.XtraEditors.SimpleButton();
            this.CheckAll = new DevExpress.XtraEditors.CheckEdit();
            this.dxErrorProvider1 = new DevExpress.XtraEditors.DXErrorProvider.DXErrorProvider(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.gcPN)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gvPN)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemTextEdit1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.CheckAll.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dxErrorProvider1)).BeginInit();
            this.SuspendLayout();
            // 
            // gcPN
            // 
            this.gcPN.Location = new System.Drawing.Point(-1, 4);
            this.gcPN.MainView = this.gvPN;
            this.gcPN.Name = "gcPN";
            this.gcPN.RepositoryItems.AddRange(new DevExpress.XtraEditors.Repository.RepositoryItem[] {
            this.repositoryItemTextEdit1,
            this.repositoryItemCheckEdit1,
            this.repositoryItemCheckEdit2});
            this.gcPN.Size = new System.Drawing.Size(769, 256);
            this.gcPN.TabIndex = 0;
            this.gcPN.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.gvPN});
            // 
            // gvPN
            // 
            this.gvPN.Appearance.Row.Options.UseBackColor = true;
            this.gvPN.Columns.AddRange(new DevExpress.XtraGrid.Columns.GridColumn[] {
            this.clMaVT,
            this.clTenVT,
            this.clMaDVT,
            this.clGia,
            this.clSelect,
            this.clMaKH,
            this.clTenKH});
            this.gvPN.GridControl = this.gcPN;
            this.gvPN.GroupCount = 2;
            this.gvPN.Name = "gvPN";
            this.gvPN.OptionsSelection.MultiSelect = true;
            this.gvPN.SortInfo.AddRange(new DevExpress.XtraGrid.Columns.GridColumnSortInfo[] {
            new DevExpress.XtraGrid.Columns.GridColumnSortInfo(this.clMaKH, DevExpress.Data.ColumnSortOrder.Ascending),
            new DevExpress.XtraGrid.Columns.GridColumnSortInfo(this.clTenKH, DevExpress.Data.ColumnSortOrder.Ascending)});
            // 
            // clMaVT
            // 
            this.clMaVT.AppearanceHeader.Options.UseTextOptions = true;
            this.clMaVT.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.clMaVT.Caption = "Mã vật tư";
            this.clMaVT.FieldName = "MaVT";
            this.clMaVT.Name = "clMaVT";
            this.clMaVT.Visible = true;
            this.clMaVT.VisibleIndex = 0;
            // 
            // clTenVT
            // 
            this.clTenVT.AppearanceHeader.Options.UseTextOptions = true;
            this.clTenVT.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.clTenVT.Caption = "Tên vật tư";
            this.clTenVT.FieldName = "TenVT";
            this.clTenVT.Name = "clTenVT";
            this.clTenVT.Visible = true;
            this.clTenVT.VisibleIndex = 1;
            // 
            // clMaDVT
            // 
            this.clMaDVT.AppearanceHeader.Options.UseTextOptions = true;
            this.clMaDVT.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.clMaDVT.Caption = "Đơn vị tính";
            this.clMaDVT.FieldName = "MaDVT";
            this.clMaDVT.Name = "clMaDVT";
            this.clMaDVT.Visible = true;
            this.clMaDVT.VisibleIndex = 2;
            // 
            // clGia
            // 
            this.clGia.AppearanceHeader.Options.UseTextOptions = true;
            this.clGia.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.clGia.Caption = "Đơn giá";
            this.clGia.FieldName = "Gia";
            this.clGia.Name = "clGia";
            this.clGia.Visible = true;
            this.clGia.VisibleIndex = 3;
            // 
            // clSelect
            // 
            this.clSelect.AppearanceHeader.Options.UseTextOptions = true;
            this.clSelect.AppearanceHeader.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.clSelect.Caption = "Chọn";
            this.clSelect.ColumnEdit = this.repositoryItemCheckEdit1;
            this.clSelect.FieldName = "Check";
            this.clSelect.Name = "clSelect";
            this.clSelect.OptionsColumn.AllowSize = false;
            this.clSelect.OptionsColumn.AllowSort = DevExpress.Utils.DefaultBoolean.True;
            this.clSelect.UnboundType = DevExpress.Data.UnboundColumnType.Boolean;
            this.clSelect.Visible = true;
            this.clSelect.VisibleIndex = 4;
            // 
            // repositoryItemCheckEdit1
            // 
            this.repositoryItemCheckEdit1.AutoHeight = false;
            this.repositoryItemCheckEdit1.Name = "repositoryItemCheckEdit1";
            // 
            // clMaKH
            // 
            this.clMaKH.Caption = "Mã khách hàng";
            this.clMaKH.FieldName = "MaKH";
            this.clMaKH.Name = "clMaKH";
            this.clMaKH.Visible = true;
            this.clMaKH.VisibleIndex = 5;
            // 
            // clTenKH
            // 
            this.clTenKH.Caption = "Tên khách hàng";
            this.clTenKH.FieldName = "TenKH";
            this.clTenKH.Name = "clTenKH";
            this.clTenKH.Visible = true;
            this.clTenKH.VisibleIndex = 5;
            // 
            // repositoryItemTextEdit1
            // 
            this.repositoryItemTextEdit1.AutoHeight = false;
            this.repositoryItemTextEdit1.Name = "repositoryItemTextEdit1";
            // 
            // repositoryItemCheckEdit2
            // 
            this.repositoryItemCheckEdit2.AutoHeight = false;
            this.repositoryItemCheckEdit2.Name = "repositoryItemCheckEdit2";
            // 
            // btCancel
            // 
            this.btCancel.Location = new System.Drawing.Point(639, 266);
            this.btCancel.Name = "btCancel";
            this.btCancel.Size = new System.Drawing.Size(129, 30);
            this.btCancel.TabIndex = 1;
            this.btCancel.Text = "Esc-Thoát";
            this.btCancel.Click += new System.EventHandler(this.btCancel_Click);
            // 
            // btOk
            // 
            this.btOk.Location = new System.Drawing.Point(491, 266);
            this.btOk.Name = "btOk";
            this.btOk.Size = new System.Drawing.Size(129, 30);
            this.btOk.TabIndex = 1;
            this.btOk.Text = "F12-Lưu";
            this.btOk.Click += new System.EventHandler(this.btOk_Click);
            // 
            // CheckAll
            // 
            this.CheckAll.Location = new System.Drawing.Point(12, 266);
            this.CheckAll.Name = "CheckAll";
            this.CheckAll.Properties.Caption = "Chọn/bỏ tất cả";
            this.CheckAll.Size = new System.Drawing.Size(117, 19);
            this.CheckAll.TabIndex = 2;
            this.CheckAll.CheckedChanged += new System.EventHandler(this.CheckAll_CheckedChanged);
            // 
            // dxErrorProvider1
            // 
            this.dxErrorProvider1.ContainerControl = this;
            // 
            // FrmCSGTheoKH
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(780, 297);
            this.Controls.Add(this.CheckAll);
            this.Controls.Add(this.btOk);
            this.Controls.Add(this.btCancel);
            this.Controls.Add(this.gcPN);
            this.KeyPreview = true;
            this.Name = "FrmCSGTheoKH";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Chính sách giá bán vật tư theo khách hàng";
            this.Load += new System.EventHandler(this.FormCSGTheoKH_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.FrmCSGTheoKH_KeyUp);
            ((System.ComponentModel.ISupportInitialize)(this.gcPN)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gvPN)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemTextEdit1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.CheckAll.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dxErrorProvider1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevExpress.XtraGrid.GridControl gcPN;
        private DevExpress.XtraGrid.Views.Grid.GridView gvPN;
        private DevExpress.XtraGrid.Columns.GridColumn clMaVT;
        private DevExpress.XtraGrid.Columns.GridColumn clTenVT;
        private DevExpress.XtraGrid.Columns.GridColumn clMaDVT;
        private DevExpress.XtraGrid.Columns.GridColumn clGia;
        private DevExpress.XtraGrid.Columns.GridColumn clSelect;
        private DevExpress.XtraEditors.SimpleButton btCancel;
        private DevExpress.XtraEditors.SimpleButton btOk;
        private DevExpress.XtraEditors.CheckEdit CheckAll;
        private DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit repositoryItemCheckEdit1;
        private DevExpress.XtraEditors.Repository.RepositoryItemTextEdit repositoryItemTextEdit1;
        private DevExpress.XtraGrid.Columns.GridColumn clMaKH;
        private DevExpress.XtraGrid.Columns.GridColumn clTenKH;
        private DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit repositoryItemCheckEdit2;
        private DevExpress.XtraEditors.DXErrorProvider.DXErrorProvider dxErrorProvider1;
    }
}