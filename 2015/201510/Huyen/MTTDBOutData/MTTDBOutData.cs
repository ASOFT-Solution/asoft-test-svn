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
            //DataView dvMst = null;
            //DataRowView drvMst = null;
            //DataView dvDt = null;
            //string tkNo = string.Empty;
            //dvMst = new DataView(_data.DsData.Tables[0]);

            //#region "Delete"

            //dvMst.RowStateFilter = DataViewRowState.Deleted;

            //if (dvMst.Count > 0)
            //{
            //    drvMst = dvMst[0];
            //    //DeleteRow(drvMst);
            //    return;
            //}
            //#endregion "Delete"
        }
        public void ExecuteBefore()
        {
            DataView dvMst = new DataView(_data.DsData.Tables[0]);
            string query = string.Empty;
            object exists = null;
            dvMst.RowStateFilter = DataViewRowState.Added ;

            if (dvMst.Count > 0)
            {

                query = string.Format(@"select 1 from  MTTDBOut 
                    where (Case when {0} = 1 then KyBKBRTTDB end) = {1}
                    or
                   (Case when {0} = 2 then InputDate end) = cast({2} as datetime)
                    and NamBKBRTTDB = {3}", dvMst[0]["DeclareType"].ToString(), dvMst[0]["KyBKBRTTDB"].ToString(), dvMst[0]["InputDate"].ToString() == "" ? DateTime.Now.ToShortDateString() : dvMst[0]["InputDate"].ToString(), NamTaiChinh());
                exists = _data.DbData.GetValue(query);

                if (exists != null)
                {
                    ShowMessageBox("Bảng kê đã tồn tại!");
                    _info.Result = false;
                    return;
                }
                else
                {
                    _info.Result = true;
                }
            }
                dvMst.RowStateFilter = DataViewRowState.Deleted;
                if (dvMst.Count > 0)
                {
                    query = string.Format(@"Select 1 from  MToKhaiTTDB Where IsOutputAppendix = 1 and  (Case when {0} = 1 then KyToKhaiTTDB end) = {1}  or
                                (Case when {0} = 2 then InputDate end) = cast({2} as datetime)
                                and NamToKhaiTTDB = {3}", dvMst[0]["DeclareType"].ToString(), dvMst[0]["KyBKBRTTDB"].ToString(), dvMst[0]["InputDate"].ToString() == "" ? DateTime.Now.ToShortDateString() : dvMst[0]["InputDate"].ToString(), NamTaiChinh());
                    exists = _data.DbData.GetValue(query);
                    if (exists != null)
                    {
                        ShowMessageBox("Bảng kê được sử dụng bên tờ khai, bạn không được phép xóa.!");
                        _info.Result = false;
                        return;
                    }
                    else
                    {
                        query = string.Format(@"delete from MTTDBOut where MTTDBOutID = '{0}'",
                                    dvMst[0]["MTTDBOutID"].ToString());

                        _data.DbData.UpdateByNonQuery(query);

                        // Delete DTTDBOut
                        query = string.Format(@"delete from DTTDBOut where MTTDBOutID = '{0}'",
                                            dvMst[0]["MTTDBOutID"].ToString());

                        _data.DbData.UpdateByNonQuery(query);
                        _info.Result = true;
                    }

                }

        }

         public void ExecuteBeforeCheckRules()
         {
             
         }
         private void DeleteRow(DataRowView pDrv)
         {
            //string query = string.Format(@"Select 1 from  MTTDBOut Where MTTDBOutID = {0}",pDrv["MTTDBOutID"].ToString());
            //DataTable table = _data.DbData.GetDataTable(query);
            //foreach (DataRow dr in table.Rows)
            //{
            //    // Delete MTTDBOut
            //    query = string.Format("delete from MTTDBOut where MTTDBOutID = {0}",
            //                        dr["MTTDBOutID"].ToString());

            //    _data.DbData.UpdateByNonQuery(query);

            //    // Delete DTTDBOut
            //    query = string.Format("delete from DTTDBOut where MTTDBOutID = {0}",
            //                        dr["MTTDBOutID"].ToString());

            //    _data.DbData.UpdateByNonQuery(query);
            //}
         }
         private int NamTaiChinh()
         {
             return (Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString()));
         }
         private void ShowMessageBox(string msg)
         {
             if (Config.GetValue("Language").ToString() == "1")
                 msg = UIDictionary.Translate(msg);
             XtraMessageBox.Show(msg);
         }
        #endregion ICData Members

    }
}
