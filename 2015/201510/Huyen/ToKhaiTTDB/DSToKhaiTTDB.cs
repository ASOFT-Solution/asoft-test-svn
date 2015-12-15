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
    public partial class DSToKhaiTTDB : DevExpress.XtraEditors.XtraForm
    {
       #region ---- Member variables ----

        private Database _Database = Database.NewDataDatabase();
        private string _MToKhaiTTDBID = string.Empty;
        private DateTime _NgayToKhaiTTDB = DateTime.MinValue;
        private int _KyToKhaiTTDB = -1;
        private int _NamToKhaiTTDB = 0;
        private string _DienGiai = string.Empty;
        private bool _InLanDau = false;
        private int _SoLanIn = 0;


        #endregion ---- Member variables ----

        #region ---- Properties ----

        public string MToKhaiTTDBID
        {
            get { return _MToKhaiTTDBID; }
            set { _MToKhaiTTDBID = value; }
        }
        public int KyToKhaiTTDB
        {
            get { return _KyToKhaiTTDB; }
            set { _KyToKhaiTTDB = value; }
        }
        public DateTime NgayToKhaiTTDB
        {
            get { return _NgayToKhaiTTDB; }
            set { _NgayToKhaiTTDB = value; }
        }
        public int NamToKhaiTTDB
        {
            get { return _NamToKhaiTTDB; }
            set { _NamToKhaiTTDB = value; }
        }

        public string DienGiai
        {
            get { return _DienGiai; }
            set { _DienGiai = value; }
        }

        public bool InLanDau
        {
            get { return _InLanDau; }
            set { _InLanDau = value; }
        }

        public int SoLanIn
        {
            get { return _SoLanIn; }
            set { _SoLanIn = value; }
        }

        #endregion ---- Properties ----

        #region ---- Constructors & Destructors ----
        /// <history>
        ///  [Lệ Huyền] Tạo mới [10/12/2015]
        /// </history>
        public DSToKhaiTTDB()
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
        private void DSToKhaiTTDB_Load(object sender, EventArgs e)
        {
           LoadDSToKhaiTTDB();
        }

        #endregion ---- Handle Events ----

        private void btnAdd_Click(object sender, EventArgs e)
        {
            LaySoLieuToKhaiTTDB frmLaySoLieuToKhaiTTDB = new LaySoLieuToKhaiTTDB();
            frmLaySoLieuToKhaiTTDB.ShowDialog();
        }
    }
}