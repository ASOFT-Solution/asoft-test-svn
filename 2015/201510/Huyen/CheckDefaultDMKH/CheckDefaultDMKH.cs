using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using Plugins;
using System.Data;

namespace CheckDefaultDMKH
{
    class CheckDefaultDMKH : ICControl
    {

        private readonly string[] FORM_NAME = { "Khách hàng", "Nhà cung cấp", "Nhân viên"};
        private readonly string[] COLUMN_NAME = { "IsKH", "IsNCC", "IsNV" };
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.SingleDt);

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
            string formName = _data.FrmMain.Text;

            for (int i = 0; i < FORM_NAME.Length; i++)
            {
                if ((formName == FORM_NAME[i]))
                {
                    mtRowView[COLUMN_NAME[i]] = true;
                }
            }
        }
        #endregion
    }
}
