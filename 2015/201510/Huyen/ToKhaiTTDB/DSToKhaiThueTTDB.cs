using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTDatabase;

namespace ToKhaiTTDB
{
    public partial class DSToKhaiThueTTDB : XtraForm
    {
        #region ---- Member variables ----

        private Database _Database = Database.NewDataDatabase();
        private int _NamTaiChinh = -1;
        private string _MToKhaiTTDBID = string.Empty;

        #endregion ---- Member variables ----

        #region ---- Properties ----

        public string MToKhaiTTDBID
        {
            get { return _MToKhaiTTDBID; }
            set { _MToKhaiTTDBID = value; }
        }

        #endregion ---- Properties ----

        #region ---- Constructors & Destructors ----
        /// <history>
        ///  [Lệ Huyền] Tạo mới [10/12/2015]
        /// </history>
        public DSToKhaiThueTTDB()
        {
            InitializeComponent();
            this.DialogResult = DialogResult.Cancel;
        }
        #endregion ---- Constructors & Destructors ----

        #region ---- Private methods ---

        /// <summary>
        /// Lấy thông của bảng MToKhaiTTDB
        /// </summary>
        /// <history>
        ///     [Lệ Huyền] Tạo mới [10/12/2015]
        /// </history>
        private void LoadDSToKhaiTTDB()
        {
            string query = @"Select Isnull(DeclareType, 1) as DeclareType,
                        Case when Isnull(DeclareType, 1) = 1 or KyToKhaiTTDB !=0 
                        then N'Tờ khai tháng' else N'Tờ khai lần phát sinh' end as DeclareTypeName,
                        MToKhaiTTDBID,KyToKhaiTTDB, InputDate, NamToKhaiTTDB, NgayToKhaiTTDB, DienGiai, InLanDau,
                        Case when InLanDau = 1 then N'Khai lần đầu' else N'Khai bổ sung' end as InLanDauName,
                        SoLanIn, AmendedReturnDate, IsExten, ExtenID, VocationID, IsInputAppendix,
                        IsOutputAppendix, ExperiedDay, ExperiedAmount, PayableAmount, PayableCmt,
                        PayableDate, TaxDepartmentID, TaxDepartID, ReceivableExperied,
                        ReceivableAmount, ExperiedReason From MToKhaiTTDB
                        Order by NamToKhaiTTDB, DeclareType, KyToKhaiTTDB, InputDate, SoLanIn";
                    DataTable table = _Database.GetDataTable(query);
                    gcDetail.DataSource = table;
                    gvDetail.ExpandAllGroups();
                    gvDetail.BestFitColumns();
        }

        #endregion ---- Private methods ----

        #region ---- Handle Events ----
        /// <summary>
        /// Xử lý sự kiện Load của DSToKhaiThueTTDB
        /// </summary>
        private void DSToKhaiThueTTDB_Load(object sender, EventArgs e)
        {
           LoadDSToKhaiTTDB();
        }

        #endregion ---- Handle Events ----


    }
}