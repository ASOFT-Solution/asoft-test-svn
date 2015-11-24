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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FrmChinhSach));
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
            resources.ApplyResources(this.gcCS, "gcCS");
            this.gcCS.MainView = this.gvCS;
            this.gcCS.Name = "gcCS";
            this.gcCS.RepositoryItems.AddRange(new DevExpress.XtraEditors.Repository.RepositoryItem[] {
            this.repositoryItemCheckEdit1});
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
            this.gvCS.CellValueChanging += new DevExpress.XtraGrid.Views.Base.CellValueChangedEventHandler(this.gvCS_CellValueChanging);
            // 
            // colMaKH
            // 
            resources.ApplyResources(this.colMaKH, "colMaKH");
            this.colMaKH.FieldName = "MaKH";
            this.colMaKH.Name = "colMaKH";
            this.colMaKH.OptionsColumn.AllowEdit = false;
            // 
            // colMaVT
            // 
            resources.ApplyResources(this.colMaVT, "colMaVT");
            this.colMaVT.FieldName = "MaVT";
            this.colMaVT.Name = "colMaVT";
            this.colMaVT.OptionsColumn.AllowEdit = false;
            // 
            // colTenVT
            // 
            resources.ApplyResources(this.colTenVT, "colTenVT");
            this.colTenVT.FieldName = "TenVT";
            this.colTenVT.Name = "colTenVT";
            this.colTenVT.OptionsColumn.AllowEdit = false;
            // 
            // colDVT
            // 
            resources.ApplyResources(this.colDVT, "colDVT");
            this.colDVT.FieldName = "MaDVT";
            this.colDVT.Name = "colDVT";
            this.colDVT.OptionsColumn.AllowEdit = false;
            // 
            // colGia
            // 
            resources.ApplyResources(this.colGia, "colGia");
            this.colGia.FieldName = "Gia";
            this.colGia.Name = "colGia";
            this.colGia.OptionsColumn.AllowEdit = false;
            // 
            // colCheck
            // 
            resources.ApplyResources(this.colCheck, "colCheck");
            this.colCheck.FieldName = "Check";
            this.colCheck.Name = "colCheck";
            // 
            // repositoryItemCheckEdit1
            // 
            resources.ApplyResources(this.repositoryItemCheckEdit1, "repositoryItemCheckEdit1");
            this.repositoryItemCheckEdit1.Name = "repositoryItemCheckEdit1";
            // 
            // gridView2
            // 
            this.gridView2.GridControl = this.gcCS;
            this.gridView2.Name = "gridView2";
            // 
            // checkBox
            // 
            resources.ApplyResources(this.checkBox, "checkBox");
            this.checkBox.Name = "checkBox";
            this.checkBox.UseVisualStyleBackColor = true;
            this.checkBox.Click += new System.EventHandler(this.checkBox_Click);
            // 
            // btClose
            // 
            resources.ApplyResources(this.btClose, "btClose");
            this.btClose.Name = "btClose";
            this.btClose.UseVisualStyleBackColor = true;
            this.btClose.Click += new System.EventHandler(this.btClose_Click);
            // 
            // btSave
            // 
            resources.ApplyResources(this.btSave, "btSave");
            this.btSave.Name = "btSave";
            this.btSave.UseVisualStyleBackColor = true;
            this.btSave.Click += new System.EventHandler(this.btSave_Click);
            // 
            // FrmChinhSach
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.btSave);
            this.Controls.Add(this.btClose);
            this.Controls.Add(this.checkBox);
            this.Controls.Add(this.gcCS);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.Name = "FrmChinhSach";
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
        private DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit repositoryItemCheckEdit1;
        private DevExpress.XtraGrid.Columns.GridColumn colCheck;
    }
}