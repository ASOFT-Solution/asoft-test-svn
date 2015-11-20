using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using System.Data;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid;
using System.Windows.Forms;
using DevExpress.XtraEditors;

namespace ChinhSachGiaBan
{
    public class ChinhSachGiaBan : ICForm
    {
        private  List<InfoCustomForm> _lstInfo = new List<InfoCustomForm>();
        private DataCustomFormControl _data;
        public ChinhSachGiaBan()
        {
            InfoCustomForm info1 = new InfoCustomForm(IDataType.MasterDetailDt, 2307, "Chọn chính sách giá bán theo khách hàng", "Select policies price by customer", "MT32");
            _lstInfo.Add(info1);
        }
        public DataCustomFormControl Data
        {
            set
            {
                _data = value;
            }
        }

        public List<InfoCustomForm> LstInfo
        {
            get
            {
                return _lstInfo;
            }
        }
        public void Execute(int menuID)
        {
            // [Chiến Thắng] Tạo mới 09/11/2015
            // Tạo ICForm màn hình chức năng chọn bảng giá vật tư theo khách hàng

            DataRow drCurMaster = (_data.BsMain.Current as DataRowView).Row;
            if (drCurMaster["MaKH"].ToString() == string.Empty) //Chưa chọn thông tin khách hàng
                XtraMessageBox.Show("Chưa có thông tin khách hàng");
            else
            {
                GridView gvDetail = (_data.FrmMain.Controls.Find("gcMain", true)[0] as GridControl).MainView as GridView;
                FrmChinhSach frm = new FrmChinhSach(drCurMaster);
                frm.ShowDialog();
                if (frm.Result != null && frm.Result.Count > 0) //Nếu đã chọn dữ liệu 
                {
                    gvDetail.OptionsNavigation.AutoFocusNewRow = true; //Tự động focus vào dòng mới thêm. Nếu không có chạy 2 lần sẽ bị lỗi.
                    //Thêm dữ liệu vào lưới
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
