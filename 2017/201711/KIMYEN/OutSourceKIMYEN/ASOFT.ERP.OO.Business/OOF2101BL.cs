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
    public class OOF2101BL : ASOFTBaseBL
    {
        public DataTable InsertData(string DivisionID, string TaskSampleID, string ProjectID)
        {
            DbCommand command = null;
            try
            {
                OOF2101DAL oof2101dal = new OOF2101DAL();
                DataTable result = oof2101dal.InsertData(DivisionID,TaskSampleID,ProjectID);
                return result;
            }
            catch (Exception ex)
            {
                throw ASOFTException.FromCommand(command, ex);
            }
        }
        public DataTable InsertDepartment(string APKProject, string DepartmentID)
        {
            DbCommand command = null;
            try {
                OOF2101DAL oof2101dal = new OOF2101DAL();
                DataTable result = oof2101dal.InsertDepartment(APKProject, DepartmentID);
                return result;
            }
            catch (Exception ex)
            {
                throw ASOFTException.FromCommand(command, ex);
            }
        }
    }
}
