using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.A00.DataAccess;

namespace ASOFT.ERP.OO.DataAccess
{
    public class OOF1050DAL: ASOFTBaseDAL
    {
        public OOF1050DAL() { }

        public DataTable LoadData(string DivisionIDList, string EffectDate, string ExpiryDate, string InformType, string CreateUserID, string DepartmentID, string Disabled, int PageNumber, int PageSize, string SearchWhere = "")
        {

            DbCommand command = null;
            try
            {
                Dictionary<string, object> data = new Dictionary<string, object>();

                using (command = ASOFTDatabase.GetStoredProcCommand("OOP1050"))
                {
                    ASOFTDatabase.AddInParameter(command, "DivisionID", DbType.String, ASOFTEnvironment.DivisionID);
                    ASOFTDatabase.StringParseParameter(command, "DivisionIDList", DbType.String, DivisionIDList);
                    ASOFTDatabase.AddInParameter(command, "EffectDate", DbType.String, EffectDate);
                    ASOFTDatabase.AddInParameter(command, "ExpiryDate", DbType.String, ExpiryDate);
                    ASOFTDatabase.AddInParameter(command, "InformType", DbType.String, InformType);
                    ASOFTDatabase.AddInParameter(command, "CreateUserID", DbType.String, CreateUserID);
                    ASOFTDatabase.AddInParameter(command, "DepartmentID", DbType.String, DepartmentID);
                    ASOFTDatabase.AddInParameter(command, "Disabled", DbType.String, Disabled);
                    ASOFTDatabase.AddInParameter(command, "UserID", DbType.String, ASOFTEnvironment.UserID);
                   // ASOFTDatabase.AddInParameter(command, "IsExcel", DbType.String, "0");
                    ASOFTDatabase.AddInParameter(command, "PageNumber", DbType.Int32, PageNumber);
                    ASOFTDatabase.AddInParameter(command, "PageSize", DbType.Int32, PageSize);
                    //ASOFTDatabase.AddInParameter(command, "SearchWhere", DbType.String, SearchWhere);
                    //ASOFTDatabase.StringParseParameter(command, "ConditionContactID", DbType.String, ASOFTEnvironment.GetCondition().ConditionContactID);
                    using (var reader = ASOFTDatabase.ExecuteReader(command, this))
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);
                        return dt;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ASOFTException.FromCommand(command, ex);
            }
        }
    }
}
