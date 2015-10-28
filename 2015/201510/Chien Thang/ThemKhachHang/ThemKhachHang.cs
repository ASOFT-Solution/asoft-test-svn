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
            _data.FrmMain.Load += new EventHandler(FormLoad);
            
        }
        void FormLoad(object sender, EventArgs e)
        {
            BindingSource bindingSource = null;
            DataRow mtRowView = null;
            string frmName = _data.FrmMain.Text;
            bindingSource = _data.BsMain as BindingSource;
            mtRowView = (bindingSource.Current as DataRowView).Row;
            if (frmName == "Nhân viên")
                mtRowView["IsNV"] = true;
            else if (frmName == "Khách hàng")
                mtRowView["IsKH"] = true;
            else
                mtRowView["IsNCC"] = true;
        }
    }
}
