using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Plugins;
using DevExpress.XtraEditors;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid.Views.Base;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraGrid.Columns;
using DevExpress.XtraGrid;
using System.Data;
using CDTLib;
using CDTDatabase;


namespace FormChinhSachGia
{
    class FormChinhSachGia : ICForm
    {
        DataCustomFormControl _data;
        List<InfoCustomForm> _lstInfo = new List<InfoCustomForm>();
        private Database _dbData =Database.NewDataDatabase();
        public FormChinhSachGia()
        {
            InfoCustomForm info = new InfoCustomForm(IDataType.MasterDetailDt, 10002, "Chọn chính sách giá bán theo khách hàng", "Select policies by customer price", "MT32");
            _lstInfo.Add(info);
        }

        //[Lệ Huyền] Tạo mới [05/11/2015]
        // Xem và chọn áp phiếu điều chuyển kho để xuất hóa đơn
        #region ICForm Members

        public DataCustomFormControl Data
        {
            set { _data = value; }
        }
        public List<InfoCustomForm> LstInfo
        {
            get { return _lstInfo; }
        }
        #endregion

        public void Execute(int menuID)
        {
            if (menuID == _lstInfo[0].MenuID)
            {
                GridView gvDetail = (_data.FrmMain.Controls.Find("gcMain", true)[0] as GridControl).MainView as GridView;
                DataRow drCurMaster = (_data.BsMain.Current as DataRowView).Row;
                DataRow drCurDetail = gvDetail.GetDataRow(gvDetail.FocusedRowHandle);
                if (drCurMaster["MaKH"].ToString() == "")
                {
                    string msg = "Cần có mã khách hàng để tra phiếu nhập";
                    if (Config.GetValue("Language").ToString() == "1")
                        msg = UIDictionary.Translate(msg);
                    XtraMessageBox.Show(msg);
                    return;
                }
                FrmCSGTheoKH frm = new FrmCSGTheoKH(drCurMaster, drCurDetail);
                DialogResult dialogResult = frm.ShowDialog();
                if (dialogResult == DialogResult.OK
                        && gvDetail != null
                        && frm.Result != null
                        && frm.Result.Count > 0)
                
                {
                    // Xóa dữ liệu trên lưới
                    for (int i = gvDetail.RowCount - 1; i >= 0; i--)
                    {
                        gvDetail.DeleteRow(i);
                    }
                    //Lấy dữ liệu
                    foreach (DataRowView dataRowView in frm.Result)
                    {
                        gvDetail.AddNewRow();
                        gvDetail.SetFocusedRowCellValue(gvDetail.Columns["MaVT"], dataRowView["MaVT"]);
                        gvDetail.SetFocusedRowCellValue(gvDetail.Columns["TenVT"], dataRowView["TenVT"]);
                        gvDetail.SetFocusedRowCellValue(gvDetail.Columns["MaDVT"], dataRowView["MaDVT"]);
                        gvDetail.SetFocusedRowCellValue(gvDetail.Columns["Gia"], dataRowView["Gia"]);
                    }
                }
            }
        }
    }
}
