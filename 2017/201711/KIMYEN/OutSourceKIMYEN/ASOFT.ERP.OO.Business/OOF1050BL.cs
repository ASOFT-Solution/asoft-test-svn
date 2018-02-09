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
    public class OOF1050BL: ASOFTBaseBL
    {
        public DataTable LoadData(string DivisionIDList, string EffectDate, string ExpiryDate, string InformType, string CreateUserID, string DepartmentID, string Disabled, int PageNumber, int PageSize)
        { 
            DbCommand command = null;
            try
            {
                OOF1050DAL dal = new OOF1050DAL();
                DataTable result = dal.LoadData(DivisionIDList, EffectDate, ExpiryDate, InformType, CreateUserID, DepartmentID, Disabled, PageNumber, PageSize);
                    return result;
            }
             catch (ASOFTException) { throw; }
             catch (Exception ex)
            {
                throw ASOFTException.FromCommand(command, ex);
            }
        }
        
    }
}
