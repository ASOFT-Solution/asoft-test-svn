using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Plugins;
using System.Data;
using CDTDatabase;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid;
using DevExpress.XtraEditors;


namespace CheckDefaultDMKH
{
    class CheckDefaultDMKH : ICControl
    {
        private readonly string[] COLUMN_NAME = { "isKH = 1", "isNCC = 1", "isNV = 1" };
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.SingleDt);
        private Database _dbData = Database.NewDataDatabase();

        //[Lệ Huyền] Created [28/10/2015]
        // Check mặc định loại nhân viên, KH, NCC

        #region ICControl Members

        public DataCustomFormControl Data
        {
            set { _data = value; }
        }
        public InfoCustomControl Info
        {
            get { return _info; }
        }

        public void AddEvent()
        {
            _data.FrmMain.Load += new EventHandler(FormLoad);
        }

        // Update [09/11/2015]
        // Check mặc định loại nhân viên, KH, NCC

        private void FormLoad(object sender, EventArgs e)
        {
            BindingSource bindingSource = null;
            DataRow mtRowView = null;

            bindingSource = _data.BsMain as BindingSource;
            if (bindingSource == null || bindingSource.Current == null)
                return;

            mtRowView = (bindingSource.Current as DataRowView).Row;
            if (mtRowView == null || mtRowView.RowState == DataRowState.Deleted)
                return;
			if(mtRowView.RowState == DataRowState.Added)
			{
				string _strCheck = _data.DrTable["ExtraSql"].ToString();
				if (!COLUMN_NAME.Contains(_strCheck))
					return;
				if (_strCheck == "isKH = 1")
				{
					mtRowView["IsKH"] = true;
				}
				else if (_strCheck == "isNV = 1")
				{
					mtRowView["IsNV"] = true;
				}
				else
				{
					mtRowView["IsNCC"] = true;
				}
			}
        }
        #endregion
    }
}
