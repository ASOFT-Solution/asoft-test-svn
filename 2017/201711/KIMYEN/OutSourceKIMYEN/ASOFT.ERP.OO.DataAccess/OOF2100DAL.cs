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
   public class OOF2100DAL : ASOFTBaseDAL
    {
       public OOF2100DAL() { }

        public DataTable LoadData(string DivisionIDList, string FromDate, string ToDate, string ProjectID, string ProjectName, string ContractID, string LeaderID, string DepartmentID, string StatusID, string AssignedToUserID, string Mode, int PageNumber, int PageSize, string SearchWhere = "")
        {

            DbCommand command = null;
            try
            {
                Dictionary<string, object> data = new Dictionary<string, object>();
                DateTime fromDate, toDate;
                DateTime.TryParse(FromDate, out fromDate);
                DateTime.TryParse(ToDate, out toDate);

                using (command = ASOFTDatabase.GetStoredProcCommand("OOP2100"))
                {
                    ASOFTDatabase.AddInParameter(command, "DivisionID", DbType.String, ASOFTEnvironment.DivisionID);
                    ASOFTDatabase.StringParseParameter(command, "DivisionIDList", DbType.String, DivisionIDList);
                    ASOFTDatabase.AddInParameter(command, "FromDate", DbType.DateTime, fromDate);
                    ASOFTDatabase.AddInParameter(command, "ToDate", DbType.DateTime, toDate);
                    ASOFTDatabase.AddInParameter(command, "ProjectID", DbType.String, ProjectID);
                    ASOFTDatabase.AddInParameter(command, "ProjectName", DbType.String, ProjectName);
                    ASOFTDatabase.AddInParameter(command, "ContractID", DbType.String, ContractID);
                    ASOFTDatabase.AddInParameter(command, "LeaderID", DbType.String, LeaderID);
                    ASOFTDatabase.AddInParameter(command, "DepartmentID", DbType.String, DepartmentID);
                    ASOFTDatabase.AddInParameter(command, "StatusID", DbType.String, StatusID);
                    ASOFTDatabase.AddInParameter(command, "AssignedToUserID", DbType.String, AssignedToUserID);
                    ASOFTDatabase.AddInParameter(command, "Mode", DbType.String, Mode);
                    ASOFTDatabase.AddInParameter(command, "UserID", DbType.String, ASOFTEnvironment.UserID);
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
