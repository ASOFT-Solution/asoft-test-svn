namespace ChinhSachGiaBan
{
    partial class FrmChinhSach
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
            this.gcCS = new DevExpress.XtraGrid.GridControl();
            this.gvCS = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.colMaKH = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colMaVT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colTenVT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colDVT = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colGia = new DevExpress.XtraGrid.Columns.GridColumn();
            this.colCheck = new DevExpress.XtraGrid.Columns.GridColumn();
            this.repositoryItemCheckEdit1 = new DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit();
            this.gridView2 = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.checkBox = new System.Windows.Forms.CheckBox();
            this.btClose = new System.Windows.Forms.Button();
            this.btSave = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.gcCS)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gvCS)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView2)).BeginInit();
            this.SuspendLayout();
            // 
            // gcCS
            // 
            this.gcCS.Dock = System.Windows.Forms.DockStyle.Top;
            this.gcCS.Location = new System.Drawing.Point(0, 0);
            this.gcCS.MainView = this.gvCS;
            this.gcCS.Name = "gcCS";
            this.gcCS.RepositoryItems.AddRange(new DevExpress.XtraEditors.Repository.RepositoryItem[] {
            this.repositoryItemCheckEdit1});
            this.gcCS.Size = new System.Drawing.Size(805, 286);
            this.gcCS.TabIndex = 0;
            this.gcCS.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[] {
            this.gvCS,
            this.gridView2});
            // 
            // gvCS
            // 
            this.gvCS.Columns.AddRange(new DevExpress.XtraGrid.Columns.GridColumn[] {
            this.colMaKH,
            this.colMaVT,
            this.colTenVT,
            this.colDVT,
            this.colGia,
            this.colCheck});
            this.gvCS.GridControl = this.gcCS;
            this.gvCS.GroupCount = 1;
            this.gvCS.Name = "gvCS";
            this.gvCS.OptionsSelection.MultiSelect = true;
            this.gvCS.SortInfo.AddRange(new DevExpress.XtraGrid.Columns.GridColumnSortInfo[] {
            new DevExpress.XtraGrid.Columns.GridColumnSortInfo(this.colMaKH, DevExpress.Data.ColumnSortOrder.Ascending)});
            // 
            // colMaKH
            // 
            this.colMaKH.Caption = "Mã khách hàng";
            this.colMaKH.FieldName = "MaKH";
            this.colMaKH.Name = "colMaKH";
            this.colMaKH.OptionsColumn.AllowEdit = false;
            // 
            // colMaVT
            // 
            this.colMaVT.Caption = "Mã vật tư";
            this.colMaVT.FieldName = "MaVT";
            this.colMaVT.Name = "colMaVT";
            this.colMaVT.OptionsColumn.AllowEdit = false;
            this.colMaVT.Visible = true;
            this.colMaVT.VisibleIndex = 0;
            // 
            // colTenVT
            // 
            this.colTenVT.Caption = "Tên vật tư";
            this.colTenVT.FieldName = "TenVT";
            this.colTenVT.Name = "colTenVT";
            this.colTenVT.OptionsColumn.AllowEdit = false;
            this.colTenVT.Visible = true;
            this.colTenVT.VisibleIndex = 1;
            // 
            // colDVT
            // 
            this.colDVT.Caption = "Đơn vị tính";
            this.colDVT.FieldName = "MaDVT";
            this.colDVT.Name = "colDVT";
            this.colDVT.OptionsColumn.AllowEdit = false;
            this.colDVT.Visible = true;
            this.colDVT.VisibleIndex = 2;
            // 
            // colGia
            // 
            this.colGia.Caption = "Đơn giá";
            this.colGia.FieldName = "Gia";
            this.colGia.Name = "colGia";
            this.colGia.OptionsColumn.AllowEdit = false;
            this.colGia.Visible = true;
            this.colGia.VisibleIndex = 3;
            // 
            // colCheck
            // 
            this.colCheck.Caption = "Chọn";
            this.colCheck.FieldName = "Check";
            this.colCheck.Name = "colCheck";
            this.colCheck.Visible = true;
            this.colCheck.VisibleIndex = 4;
            // 
            // repositoryItemCheckEdit1
            // 
            this.repositoryItemCheckEdit1.AutoHeight = false;
            this.repositoryItemCheckEdit1.Name = "repositoryItemCheckEdit1";
            // 
            // gridView2
            // 
            this.gridView2.GridControl = this.gcCS;
            this.gridView2.Name = "gridView2";
            // 
            // checkBox
            // 
            this.checkBox.AutoSize = true;
            this.checkBox.Location = new System.Drawing.Point(12, 298);
            this.checkBox.Name = "checkBox";
            this.checkBox.Size = new System.Drawing.Size(98, 17);
            this.checkBox.TabIndex = 1;
            this.checkBox.Text = "Chọn/bỏ tất cả";
            this.checkBox.UseVisualStyleBackColor = true;
            this.checkBox.CheckedChanged += new System.EventHandler(this.checkBox_CheckedChanged);
            // 
            // btClose
            // 
            this.btClose.Location = new System.Drawing.Point(652, 292);
            this.btClose.Name = "btClose";
            this.btClose.Size = new System.Drawing.Size(141, 27);
            this.btClose.TabIndex = 2;
            this.btClose.Text = "Esc-Thoát";
            this.btClose.UseVisualStyleBackColor = true;
            this.btClose.Click += new System.EventHandler(this.btClose_Click);
            // 
            // btSave
            // 
            this.btSave.Location = new System.Drawing.Point(505, 292);
            this.btSave.Name = "btSave";
            this.btSave.Size = new System.Drawing.Size(141, 27);
            this.btSave.TabIndex = 3;
            this.btSave.Text = "F12-Lưu";
            this.btSave.UseVisualStyleBackColor = true;
            this.btSave.Click += new System.EventHandler(this.btSave_Click);
            // 
            // FrmChinhSach
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(805, 342);
            this.Controls.Add(this.btSave);
            this.Controls.Add(this.btClose);
            this.Controls.Add(this.checkBox);
            this.Controls.Add(this.gcCS);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.Name = "FrmChinhSach";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Chính sách giá bán vật tư theo khách hàng";
            this.Load += new System.EventHandler(this.FrmChinhSach_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.FrmChinhSach_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.gcCS)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gvCS)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.repositoryItemCheckEdit1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridView2)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DevExpress.XtraGrid.GridControl gcCS;
        private DevExpress.XtraGrid.Views.Grid.GridView gvCS;
        private DevExpress.XtraGrid.Views.Grid.GridView gridView2;
        private System.Windows.Forms.CheckBox checkBox;
        private System.Windows.Forms.Button btClose;
        private System.Windows.Forms.Button btSave;
        private DevExpress.XtraGrid.Columns.GridColumn colMaKH;
        private DevExpress.XtraGrid.Columns.GridColumn colMaVT;
        private DevExpress.XtraGrid.Columns.GridColumn colTenVT;
        private DevExpress.XtraGrid.Columns.GridColumn colDVT;
        private DevExpress.XtraGrid.Columns.GridColumn colGia;
        private DevExpress.XtraGrid.Columns.GridColumn colCheck;
        private DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit repositoryItemCheckEdit1;
    }
}