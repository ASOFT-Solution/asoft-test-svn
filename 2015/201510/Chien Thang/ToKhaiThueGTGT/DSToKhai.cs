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
using CDTControl;

namespace ToKhaiThueGTGT
{
    /// <summary>
    /// Danh sách tờ khai thuế GTGT
    /// [Chiến Thắng] tạo mới 09/12/2015
    /// </summary>
    public partial class DSToKhai : DevExpress.XtraEditors.XtraForm
    {
        public DSToKhai()
        {
            InitializeComponent();
        }

        #region ---- Member variables ----

        private Database _Database = Database.NewDataDatabase();

        #endregion

        #region ---- Private Methods ----
        /// <summary>
        /// Lấy danh sách tờ khai.
        /// </summary>
        private void LoadData(int indexType)
        {
            string sql = "Select Stt, MToKhaiID, NgayToKhai, KyToKhai, QuyToKhai, NamToKhai, Case when (KyToKhai != 0 and QuyToKhai = 0) or DeclareType = 1 then N'Tháng'";
            sql += " when (KyToKhai = 0 and QuyToKhai != 0) or DeclareType = 2 then N'Quy' else null end as PeriodName, Case when (KyToKhai != 0 and QuyToKhai = 0) then KyToKhai";
            sql += " when (KyToKhai = 0 and QuyToKhai != 0) then QuyToKhai else null end PeriodNum, InLanDau, Case when InLanDau = 1 then N'Lần đầu' else N'Bổ sung lần' end as DeclareName,";
            sql += " Case when InLanDau = 1 then null else SoLanIn end as SoLanIn, AmendedReturnDate, DienGiai, IsInputAppendix, IsOutputAppendix From MToKhai Order by NamToKhai, KyToKhai, QuyToKhai, SoLanIn";
            gridControl1.DataSource = _Database.GetDataTable(sql);
            gvDSToKhai.BestFitColumns();
            int index = gvDSToKhai.FocusedRowHandle;
            switch (indexType)
            {
                case 0:
                    // Chọn dòng hiện tại
                    gvDSToKhai.FocusedRowHandle = Math.Min(gvDSToKhai.RowCount - 1, index);
                    break;

                case 1:
                    // Chọn dòng đầu tiên
                    gvDSToKhai.FocusedRowHandle = Math.Min(gvDSToKhai.RowCount - 1, 0);
                    break;
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

        #endregion


        #region ----Handle Events----
        /// <summary>
        /// Xử lý sự kiện Form Load
        /// </summary>
        private void DSToKhai_Load(object sender, EventArgs e)
        {
            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
            LoadData(0);
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            CapNhatToKhai frm = new CapNhatToKhai();
            frm.ShowDialog();
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// Xử lý sự kiện Click của btnDelete
        /// </summary>
        private void btnDelete_Click(object sender, EventArgs e)
        {
            StringBuilder sqlDelete = new StringBuilder();
            object obj = gvDSToKhai.GetRowCellValue(gvDSToKhai.FocusedRowHandle, "MToKhaiID");
            if (obj == null)
                return;

            string MToKhaiID = obj.ToString();
            string sqlCheck = string.Format(@"Declare @Ky int, @Nam int,@SoLanIn int            
                                Select @Ky =(Case when KyToKhai != 0 or DeclareType = 1 then KyToKhai else QuyToKhai end), @nam = NamToKhai, @SoLanIn = SoLanIn
                                From MTokhai
                                Where MToKhaiID = '{0}'
                                Select Top 1 1
                                From (
                                        Select MToKhaiID from MTokhai
                                        Where (Case when KyToKhai != 0 or DeclareType = 1 then KyToKhai else QuyToKhai end) > @Ky and NamToKhai >=@Nam
                                        Union all
                                        Select MToKhaiID from MTokhai
                                        Where (Case when KyToKhai != 0 or DeclareType = 1 then KyToKhai else QuyToKhai end) = @Ky and NamToKhai >=@Nam and SoLanIn >@SoLanIn
                                        ) x", MToKhaiID);
            if (_Database.GetValue(sqlCheck) != null)
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

                sqlDelete.AppendLine(string.Format(" Delete from DToKhai where MToKhaiID = '{0}'", MToKhaiID));
                sqlDelete.AppendLine(string.Format(" Delete from DToKhaiKHBS where MToKhaiID = '{0}' ", MToKhaiID));
                sqlDelete.AppendLine(string.Format(" Delete from MToKhai where MToKhaiID = '{0}' ", MToKhaiID));
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
                this.LoadData(0);
            }
            else
            {
                ShowASoftMsg("Không thể xóa tờ khai.");
            }

        }

        private void btnCancel_Click(object sender, EventArgs e)
        {

        }

        private void DSToKhai_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.KeyCode)
            {
                case Keys.Escape:
                    this.Close();
                    break;
            }
        }
        #endregion

    }
}
