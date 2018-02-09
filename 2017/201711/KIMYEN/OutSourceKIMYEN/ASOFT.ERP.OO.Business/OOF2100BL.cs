using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Business;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.OO.DataAccess;

namespace ASOFT.ERP.OO.Business
{
   public class OOF2100BL : ASOFTBaseBL
    {
       public DataTable LoadData(string DivisionIDList, string FromDate, string ToDate, string ProjectID, string ProjectName, string ContractID, string LeaderID, string DepartmentID, string StatusID, string AssignedToUserID, string Mode, int PageNumber, int PageSize)
       {
           DbCommand command = null;
           try
           {
               OOF2100DAL dal = new OOF2100DAL();
               DataTable result = dal.LoadData(DivisionIDList, FromDate, ToDate, ProjectID, ProjectName, ContractID, LeaderID, DepartmentID, StatusID, AssignedToUserID, Mode, PageNumber, PageSize);
               return result;
           }
          // catch (ASOFTException) { throw; }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
       }
    }
}
