using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using System.Windows.Forms;
using System.Data;
using DevExpress.XtraEditors;
using CDTLib;
using CDTDatabase;

namespace MTTDBOutData
{
    class MTTDBOutData : ICData
    {
        #region "Private variables"

        private InfoCustomData _info;
        private DataCustomData _data;
        private int _NamTaiChinh = -1;
        private Database _Database = Database.NewDataDatabase();

        #endregion "Private variables"

         #region "Constructors"

        public MTTDBOutData()
        {
            _info = new InfoCustomData(IDataType.MasterDetailDt);
        }

        #endregion "Constructors"

        #region ICData Members

        public DataCustomData Data
        {
            set { _data = value; }
        }

        public InfoCustomData Info
        {
            get { return _info; }
        }
        public void ExecuteAfter()
        {
        }

        public void ExecuteBefore()
        {
            
            DataView dvMst = new DataView(_data.DsData.Tables[0]);
            dvMst.RowStateFilter = DataViewRowState.Added;

            DataView dvDt = new DataView(_data.DsData.Tables[1]);
            dvDt.RowStateFilter = DataViewRowState.Added;

            if (dvMst.Count > 0 || dvDt.Count > 0)
            {

                string query = string.Format(@"select Top MTTDBOutID  from  MTTDBOut 
                    where (Case when {0} = 1 then KyBKBRTTDB end) = {1}
                        or
                       (Case when {0} = 2 then InputDate end) = cast({2} as datetime)
                        and NamBKBRTTDB = {3}", dvMst[0]["DeclareType"].ToString(), dvMst[0]["KyBKBRTTDB"].ToString(), dvMst[0]["InputDate"].ToString(),NamTaiChinh());
                DataTable table = _Database.GetDataTable(query);
                if (table.Rows.Count > 0)
                {
                    XtraMessageBox.Show("Bảng kê đã tồn tại");
                    _info.Result = false;
                }
                else
                {
                    _info.Result = true;
                }

            }

        }

         public void ExecuteBeforeCheckRules()
         {

         }
         private int NamTaiChinh()
         {
             return (Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString()));
         }
        #endregion ICData Members

    }
}
