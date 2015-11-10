using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using DevExpress.XtraLayout;
using DevExpress.XtraGrid;
using DevExpress.XtraEditors;
using DevExpress.XtraGrid.Columns;
using DevExpress.XtraGrid.Views.Grid;
using System.Windows.Forms;
using System.Data;

namespace ThemKhachHang
{
    public class ThemKhachHang : ICControl
    {
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.SingleDt);
        public DataCustomFormControl Data
        {
            set { _data = value; }
        }

        InfoCustomControl ICControl.Info
        {
            get { return _info; }
        }
        public void AddEvent()
        {
            // Thêm sự kiện FormLoad
            _data.FrmMain.Load += new EventHandler(FormLoad);
        }
        void FormLoad(object sender, EventArgs e)
        {
            // [Chiến Thắng] Tạo mới 09/11/2015
            // Tự động check vào các ô nhân viên, khách hàng, nhà cung cấp khi Form load lên.
            BindingSource bindingSource = null;
            DataRow mtRowView = null;
            bindingSource = _data.BsMain as BindingSource;
            mtRowView = (bindingSource.Current as DataRowView).Row;
            if (mtRowView.RowState != DataRowState.Added)
                return;
            DataRow dr = _data.DrTable;
            if (_data.DrTable["ListType"].ToString() == "2") //Trường hợp Form load lên thuộc danh mục nhân viên
            {
                mtRowView["isNV"] = true;
            }
            else if (_data.DrTable["ListType"].ToString() == "3") //Trường hợp Form load lên thuộc danh mục khách hàng
            {
                mtRowView["isKH"] = true;
            }
            else if (_data.DrTable["ListType"].ToString() == "4") //Trường hợp Form load lên thuộc danh mục nhà cung cấp
            {
                mtRowView["isNCC"] = true;
            }
            
        }
    }
}
