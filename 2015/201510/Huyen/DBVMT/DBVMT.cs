using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using DevExpress.XtraLayout;
using DevExpress.XtraGrid;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraEditors;
using DevExpress.XtraEditors.Repository;
using DevExpress.XtraGrid.Columns;
using DevExpress.XtraGrid.Views.Grid;
using Plugins;
using DataFactory;
using CDTDatabase;
using CDTLib;
using CDTControl;

namespace DBVMT
{
    public class DBVMT : ICControl
    {
        //Lệ Huyền tạo mới ngày 22/01/2016
        // Xử lý tab Bảng thuế Bảo vệ môi trường

        private Database _dbData = Database.NewDataDatabase();
        private string _dbvmtName;
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.MasterDetailDt);
        GridView gvDBVMT;

        #region ICControl Members

        public DataCustomFormControl Data
        {
            set { _data = value; }
        }

        public InfoCustomControl Info
        {
            get { return _info; }
        }
        #endregion ICControl Members

        public void AddEvent()
        {
            string table = _data.DrTableMaster["TableName"].ToString();
            string[] tmp = new string[] {"MT32"};
            List<string> lstTable = new List<string>();
            lstTable.AddRange(tmp);
            if (!lstTable.Contains(table))
                return;
            _dbvmtName = "DBVMT";
            gvDBVMT = (_data.FrmMain.Controls.Find(_dbvmtName, true)[0] as GridControl).MainView as GridView;
            if (table.Contains("MT32"))
            {
                gvDBVMT.Columns["Notes"].Visible = false;
                gvDBVMT.Columns["Type"].Visible = false;
                gvDBVMT.Columns["VoucherCode"].Visible = false;
                gvDBVMT.Columns["VoucherDate"].Visible = false;
                gvDBVMT.Columns["InvoiceType"].Visible = false;
                gvDBVMT.Columns["FormID"].Visible = false;
                gvDBVMT.Columns["FormSymbol"].Visible = false;
                gvDBVMT.Columns["InvoiceDate"].Visible = false;
                gvDBVMT.Columns["InvoiceNo"].Visible = false;
                gvDBVMT.Columns["InvoiceSeriNo"].Visible = false;
                gvDBVMT.Columns["ObjectID"].Visible = false;
                gvDBVMT.Columns["ObjectName"].Visible = false;
                gvDBVMT.Columns["Address"].Visible = false;
                gvDBVMT.Columns["Description"].Visible = false;
                gvDBVMT.Columns["SortOrder"].Visible = false;
                _data.BsMain.DataSourceChanged += new EventHandler(BsMain_DataSourceChanged);
                BsMain_DataSourceChanged(_data.BsMain, new EventArgs());
            }
        }
        private void BsMain_DataSourceChanged(object sender, EventArgs e)
        {
            DataSet dsData = _data.BsMain.DataSource as DataSet;
            if (dsData == null)
                return;
            dsData.Tables[1].ColumnChanged += new DataColumnChangeEventHandler(ChiTiet_DBVMT_ColumnChanged);
            dsData.Tables[1].RowChanged += new DataRowChangeEventHandler(ChiTiet_DBVMT_RowChanged);
            dsData.Tables[1].RowDeleting += new DataRowChangeEventHandler(ChiTiet_DBVMT_RowDeleting);
        }
        void ChiTiet_DBVMT_ColumnChanged(object sender, DataColumnChangeEventArgs e)
        {
            DataRow drDBVMT = GetDesFromSource(e.Row);

            if (drDBVMT != null)
            {
                // Đang thao tác cột ChiuThueBVMT
                if (e.Column.ColumnName.ToUpper().Equals("CHIUTHUEBVMT") &&
                    e.ProposedValue.GetType() == typeof(bool))
                {
                    // Bỏ chọn thuế chịu thuế BVMT
                    if (!Utils.parseBoolean(e.ProposedValue))
                    {
                        // Tính toán lại
                        DoBeforeRemoveDBVMT(e.Row, drDBVMT);
                    }
                }
            }
        }
        /// <summary>
        /// Calculate before remove row DBVMT
        /// </summary>
        /// <param name="drDetail"></param>
        /// <param name="drTTDB"></param>
        private void DoBeforeRemoveDBVMT(DataRow drDetail, DataRow drDBVMT)
        {
            string tableName = _data.DrTableMaster["TableName"].ToString();
        }
        /// <summary>
        /// Khi 1 dòng trong bảng chi tiết hóa đơn xóa
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void ChiTiet_DBVMT_RowDeleting(object sender, DataRowChangeEventArgs e)
        {
            DataRow drDes = GetDesFromSource(e.Row);
            if (drDes != null)
                drDes.Delete();
        }

        void ChiTiet_DBVMT_RowChanged(object sender, DataRowChangeEventArgs e)
        {
            try
            {
                bool chiuThueBVMT = false;

                // TH them moi dong
                if (e.Action == DataRowAction.Add)
                {
                    if (!bool.TryParse(e.Row["ChiuThueBVMT"].ToString(), out chiuThueBVMT))
                    {
                        chiuThueBVMT = false;
                    }

                    if (chiuThueBVMT)
                    {
                        // Tao moi dong DBVMT
                        DataSet dsData = _data.BsMain.DataSource as DataSet;
                        DataRow drDes = dsData.Tables[4].NewRow();
                        string mtPk = _data.DrTableMaster["Pk"].ToString();
                        drDes["MTID"] = e.Row[mtPk];
                        string dtPk = _data.DrTable["Pk"].ToString();
                        drDes["MTIDDT"] = e.Row[dtPk];
                        dsData.Tables[4].Rows.Add(drDes);
                        CopyData(e.Row, drDes);
                    }
                }

                // TH sua
                if (e.Action == DataRowAction.Change)
                {
                    if (!bool.TryParse(e.Row["ChiuThueBVMT"].ToString(), out chiuThueBVMT))
                    {
                        chiuThueBVMT = false;
                    }

                    DataRow drDes = GetDesFromSource(e.Row);

                    // Check chiuThueBVMT
                    if (chiuThueBVMT)
                    {
                        string mtPk = _data.DrTableMaster["Pk"].ToString();
                        // Da ton tai dong
                        if (drDes != null)
                        {
                            if (drDes["MTID"].ToString() == "")
                                drDes["MTID"] = e.Row[mtPk];
                            CopyData(e.Row, drDes);
                        }
                        // Chua ton tai dong
                        else
                        {
                            // Tao dong DBVMT moi
                            DataSet dsData = _data.BsMain.DataSource as DataSet;
                            drDes = dsData.Tables[4].NewRow();
                            drDes["MTID"] = e.Row[mtPk];
                            string dtPk = _data.DrTable["Pk"].ToString();
                            drDes["MTIDDT"] = e.Row[dtPk];
                            dsData.Tables[4].Rows.Add(drDes);
                            CopyData(e.Row, drDes);
                        }
                    }
                    // Bo check chiuThueBVMT
                    else
                    {
                        if (drDes != null)
                        {
                            drDes.Delete();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private DataRow GetDesFromSource(DataRow drSource)
        {
            DataSet dsData = _data.BsMain.DataSource as DataSet;
            DataView dv = new DataView(dsData.Tables[4]);
            string dtPk = _data.DrTable["Pk"].ToString();
            dv.RowStateFilter = DataViewRowState.CurrentRows;
            dv.RowFilter = "MTIDDT = '" + Utils.parseStringToDB(drSource[dtPk].ToString()) + "'";
            if (dv.Count > 0)
                return dv[0].Row;
            else
                return null;
        }
        private void CopyData(DataRow drSource, DataRow drDes)
        {
            DataTable tableDBVMT = null;
            double quantity = 0;
            double taxConvertedUnit = 0;
            double taxRate = 0;
            double taxAmount = 0;
            string makho = string.Empty;
            string mavt = string.Empty;
            FormulaCaculator.NeedCaculateFormula = false;

            if (drSource.Table.Columns.Contains("MaDVT") && drDes.Table.Columns.Contains("UnitID"))
                drDes["UnitID"] = drSource["MaDVT"];
            if (drSource.Table.Columns.Contains("TKDT") && drDes.Table.Columns.Contains("DebitAccountID"))
                drDes["DebitAccountID"] = drSource["TKDT"];
            if (drSource.Table.Columns.Contains("GhiChu") && drDes.Table.Columns.Contains("Notes"))
                drDes["Notes"] = drSource["GhiChu"];
            if (drSource.Table.Columns.Contains("SoLuong") && drDes.Table.Columns.Contains("Quantity"))
                drDes["Quantity"] = drSource["SoLuong"];
            if (drSource.Table.Columns.Contains("Stt") && drDes.Table.Columns.Contains("SortOrder"))
                drDes["SortOrder"] = drSource["Stt"];
            if (drSource.Table.Columns.Contains("MaVT") && drDes.Table.Columns.Contains("InventoryID"))
                drDes["InventoryID"] = drSource["MaVT"];

            drDes["Type"] = 2;

            if (drDes["InventoryID"] != DBNull.Value)
            {
                using (DataTable tableDMVT = _dbData.GetDataTable(string.Format("select TenVT from DMVT where MaVT = '{0}'", Utils.parseStringToDB(drDes["InventoryID"]))))
                {
                    if (tableDMVT != null && tableDMVT.Rows.Count > 0)
                    {
                        drDes["InventoryName"] = tableDMVT.Rows[0]["TenVT"];
                    }
                }
            }

            DataRow drCurMaster = (_data.BsMain.Current as DataRowView).Row;
            int handle = FindRowHandleByDataRow(gvDBVMT, drDes);
            if (handle != GridControl.InvalidRowHandle)
            {
                int stt = 0;
                for (int i = 0; i < gvDBVMT.RowCount-1; i++)
                {
                    stt++;
                }
                drDes["SortOrder"] = stt;
                gvDBVMT.SetRowCellValue(handle, "FormID", drCurMaster["FormID"]);
                drDes["FormID"] = drCurMaster["FormID"];
                gvDBVMT.SetRowCellValue(handle, "FormSymbol", drCurMaster["FormSymbol"]);
                drDes["FormSymbol"] = drCurMaster["FormSymbol"];
                gvDBVMT.SetRowCellValue(handle, "ObjectID", drCurMaster["MaKH"]);
                drDes["ObjectID"] = drCurMaster["MaKH"];
                if (drDes["ObjectID"] != DBNull.Value)
                {
                    using (DataTable tableDMVT = _dbData.GetDataTable(string.Format("select TenKH,DiaChi from DMKH where MaKH = '{0}'", Utils.parseStringToDB(drDes["ObjectID"]))))
                    {
                        if (tableDMVT != null && tableDMVT.Rows.Count > 0)
                        {
                            drDes["ObjectName"] = tableDMVT.Rows[0]["TenKH"];
                            drDes["Address"] = tableDMVT.Rows[0]["DiaChi"];
                        }
                    }
                }
            }
            if(drSource.Table.Columns.Contains("MaVT") && drSource.Table.Columns.Contains("MaKho"))
            {
                mavt = Utils.parseStringToDB(drSource["MaVT"]);
                makho = Utils.parseStringToDB(drSource["MaKho"]);
                using (DataTable tableTonKho = _dbData.GetDataTable(string.Format("select * from wTonKhoTucThoi where MaVT = '{0}' and makho = '{1}'",mavt,makho)))
                {
                    if (tableTonKho != null && tableTonKho.Rows.Count > 0)
                    {
                        drDes["TaxID"] = tableTonKho.Rows[0]["TaxID"];
                        drDes["TaxUnit"] = tableTonKho.Rows[0]["TaxUnit"];
                        drDes["TaxConvertedUnit"] = tableTonKho.Rows[0]["TaxConvertedUnit"];
                        drDes["TaxRate"] = tableTonKho.Rows[0]["TaxRate"];
                        quantity = Utils.parseDouble(drSource["SoLuong"]);
                        taxRate = Utils.parseDouble(drDes["TaxRate"]);
                        taxConvertedUnit = Utils.parseDouble(drDes["TaxConvertedUnit"]);
                        taxAmount = quantity * taxRate * taxConvertedUnit;
                       
                    }
                }
                drDes["TaxAmount"] = taxAmount;
            }
            if (tableDBVMT != null)
            {
                tableDBVMT.Clear();
                tableDBVMT.Dispose();
            }
            FormulaCaculator.NeedCaculateFormula = true;
        }

        private int FindRowHandleByDataRow(GridView view, DataRow row)
        {
            for (int i = 0; i < view.DataRowCount; i++)
                if (view.GetDataRow(i) == row)
                    return i;
            return GridControl.InvalidRowHandle;
        }
        private int FindRowHandleByDataRow2(GridView view, DataRow row)
        {
            for (int i = 0; i < view.DataRowCount; i++)
                if (view.GetDataRow(i)["MTIDDT"].ToString() == row["OldId"].ToString())
                    return i;
            return GridControl.InvalidRowHandle;
        }

    }
}
