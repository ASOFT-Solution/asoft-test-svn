using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTDatabase;
using CDTLib;

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
        private int _DeclareType = 1;
        private string query = string.Empty;

        #endregion ---- Member variables ----

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
        private void LoadDSToKhaiTTDB(int indexType)
        {
            query = @"Select Isnull(DeclareType, 1) as DeclareType,
                        Case when Isnull(DeclareType, 1) = 1 or KyToKhaiTTDB !=0 
                        then N'Tờ khai tháng' else N'Tờ khai lần phát sinh' end as DeclareTypeName,
                        MToKhaiTTDBID,KyToKhaiTTDB, InputDate, NamToKhaiTTDB, NgayToKhaiTTDB, DienGiai, InLanDau,
                        Case when InLanDau = 1 then N'Khai lần đầu' else N'Khai bổ sung' end as InLanDauName,
                        SoLanIn, AmendedReturnDate, IsExten, ExtenID, VocationID, IsInputAppendix,
                        IsOutputAppendix, ExperiedDay, ExperiedAmount, PayableAmount, PayableCmt,
                        PayableDate, TaxDepartmentID, TaxDepartID, ReceivableExperied,
                        ReceivableAmount, ExperiedReason From MToKhaiTTDB
                        Order by NamToKhaiTTDB, DeclareType, KyToKhaiTTDB, InputDate, SoLanIn";
                    gcDetail.DataSource = _Database.GetDataTable(query); ;
                    gvDetail.BestFitColumns();
                    int index = gvDetail.FocusedRowHandle;
                    switch (indexType)
                    {
                        case 0:
                            // Chọn dòng hiện tại
                            gvDetail.FocusedRowHandle = Math.Min(gvDetail.RowCount - 1, index);
                            break;

                        case 1:
                            // Chọn dòng đầu tiên
                            gvDetail.FocusedRowHandle = Math.Min(gvDetail.RowCount - 1, 0);
                            break;
                        case 2:
                            // Chọn dòng cuối cùng
                            gvDetail.FocusedRowHandle = gvDetail.RowCount - 1;
                            break;
                    }
        }

        #endregion ---- Private methods ----

        #region ---- Handle Events ----
        /// <summary>
        /// Xử lý sự kiện Load của DSToKhaiThueTTDB
        /// </summary>

        #endregion ---- Handle Events ----

        private void btnAdd_Click(object sender, EventArgs e)
        {
            LaySoLieuToKhaiTTDB frmLaySoLieuToKhaiTTDB = new LaySoLieuToKhaiTTDB();
            frmLaySoLieuToKhaiTTDB.Action = LaySoLieuToKhaiTTDB.FormAction.AddNew;
            frmLaySoLieuToKhaiTTDB.ShowDialog();
            LoadDSToKhaiTTDB(2);
        }
        private void btnEsc_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void DSToKhaiTTDB_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.KeyCode)
            {
                case Keys.Escape:
                    this.Close();
                    break;
                case Keys.F2:
                    btnAdd.PerformClick();
                    break;
                case Keys.F3:
                    btnEdit.PerformClick();
                    break;
                case Keys.F4:
                    btnDelete.PerformClick();
                    break;
            }
        }

        private void DSToKhaiTTDB_Load(object sender, EventArgs e)
        {
            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
            LoadDSToKhaiTTDB(0);
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            object MToKhaiTTDBID = gvDetail.GetRowCellValue(gvDetail.FocusedRowHandle, "MToKhaiTTDBID");
            if (MToKhaiTTDBID == null) return;
            LaySoLieuToKhaiTTDB frm = new LaySoLieuToKhaiTTDB();
            frm.MToKhaiTTDBID = MToKhaiTTDBID.ToString();
            frm.Action = LaySoLieuToKhaiTTDB.FormAction.Edit;
            frm.ShowDialog();
            LoadDSToKhaiTTDB(0);
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            StringBuilder sqlDelete = new StringBuilder();
            object obj = gvDetail.GetRowCellValue(gvDetail.FocusedRowHandle, "MToKhaiTTDBID");
            if (obj == null)
                return;

            string MToKhaiTTDBID = obj.ToString();
            query = string.Format(@"Declare @SoLanIn int,
                              @Nam int,
                              @Ky int,
                              @DeclareType int,
                              @InputDate datetime
                            Select @SoLanIn = isnull(SoLanIn, 0),@Nam = NamToKhaiTTDB, @Ky = KyToKhaiTTDB
                              , @DeclareType = Isnull(DeclareType, 1), @InputDate = InputDate
                            From MToKhaiTTDB
                            Where MToKhaiTTDBID = '{0}'
                            Select Top 1 1 from
                              (-- Kiểm tra đã tồn tại tiếp theo 
                               Select  DeclareType, NamToKhaiTTDB, KyToKhaiTTDB
                                 , InputDate, SoLanIn, MToKhaiTTDBID   
                               From MToKhaiTTDB
                               Where NamToKhaiTTDB >= @Nam 
                                 and ((Case when @DeclareType = 1 and KyToKhaiTTDB != 0 
                                   then KyToKhaiTTDB end) > @Ky or
                                  (Case when @DeclareType = 2 and InputDate is not null 
                                   then InputDate end) > Cast(@InputDate as Datetime))
                               Union all 
                               --Kiềm tra đã tồn tại lần bổ sung tiếp theo
                               Select DeclareType, NamToKhaiTTDB, KyToKhaiTTDB
                                 , InputDate, SoLanIn, MToKhaiTTDBID   
                               From MToKhaiTTDB
                               Where NamToKhaiTTDB = @Nam 
                                 and ((Case when @DeclareType = 1 and KyToKhaiTTDB != 0 
                                   then KyToKhaiTTDB end) = @Ky or
                                  (Case when @DeclareType = 2 and InputDate is not null 
                                   then InputDate end) = Cast(@InputDate as Datetime))
                                 and SoLanin > @SoLanIn
                              ) x", MToKhaiTTDBID);
            if (_Database.GetValue(query) != null)
            {
                ShowASoftMsg("Đã tồn tại tờ khai kỳ tiếp theo hoặc khai bổ sung. Bạn không được phép sửa/xóa!");
                return;
            }
            if (ShowASoftMsg("Bạn có thật sự muốn xóa tờ khai không?", "Asoft Accounting") != DialogResult.Yes)
                return;
            bool Success = false;
            try
            {
                _Database.BeginMultiTrans();

                sqlDelete.AppendLine(string.Format(" Delete from DToKhaiTTDB where MToKhaiTTDBID = '{0}'", MToKhaiTTDBID));
                sqlDelete.AppendLine(string.Format(" Delete from DToKhaiKHBS where MToKhaiID = '{0}' ", MToKhaiTTDBID));
                sqlDelete.AppendLine(string.Format(" Delete from MToKhaiTTDB where MToKhaiTTDBID = '{0}' ", MToKhaiTTDBID));
                Success = _Database.UpdateByNonQuery(sqlDelete.ToString());

                if (Success)
                    _Database.EndMultiTrans();
                else
                    _Database.RollbackMultiTrans();
            }
            catch (Exception ex)
            {
                _Database.RollbackMultiTrans();
                XtraMessageBox.Show(ex.Message);
            }

            if (Success)
            {
                ShowASoftMsg("Tờ khai đã xóa thành công.");

                // Lấy danh sách tờ khai
                this.LoadDSToKhaiTTDB(0);
            }
            else
            {
                ShowASoftMsg("Không thể xóa tờ khai.");
            }
        }
        /// <summary>
        /// Hiển thị thông báo
        /// </summary>
        private DialogResult ShowASoftMsg(string pMsg, string pCaption)
        {
            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            return XtraMessageBox.Show(pMsg, pCaption, MessageBoxButtons.YesNo);
        }
        /// <summary>
        /// Hiển thị thông báo
        /// </summary>
        private void ShowASoftMsg(string pMsg)
        {
            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            XtraMessageBox.Show(pMsg);
        }

    }
}