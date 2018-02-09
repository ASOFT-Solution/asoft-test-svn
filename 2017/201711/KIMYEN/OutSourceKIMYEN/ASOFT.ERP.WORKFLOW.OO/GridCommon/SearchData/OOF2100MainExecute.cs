using System;
using System.Activities;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.A00.Entities.Common;
using ASOFT.ERP.OO.Business;

namespace ASOFT.ERP.WORKFLOW.OO.GridCommon.SearchData
{
   public class OOF2100MainExecute : CodeActivity
    {
        public InOutArgument<Dictionary<string, Object>> InOut { get; set; }
        public InOutArgument<string> Area { get; set; }
        public InOutArgument<string> ScreenID { get; set; }

        // If your activity returns a value, derive from CodeActivity<TResult>
        // and return the value from the Execute method.
        protected override void Execute(CodeActivityContext context)
        {
            int requestPage = int.Parse(InOut.Get(context)["requestPage"].ToString());
            int requestPageSize = int.Parse(InOut.Get(context)["requestPageSize"].ToString());
            
            Dictionary<string, List<string>> args = (Dictionary<string, List<string>>)InOut.Get(context)["args"];
            Dictionary<string, Object> output = InOut.Get(context);
            List<string> systemInfo = args["systemInfo[]"];

            ASOFTSysGrid ds = new ASOFTSysGrid();
            DataTable dt = new DataTable();

            dt = new OOF2100BL().LoadData(ASOFTUtilities.GetDataByKey("DivisionID", args), ASOFTUtilities.GetDataByKey("FromDatePeriodControl", args), ASOFTUtilities.GetDataByKey("ToDatePeriodControl", args), ASOFTUtilities.GetDataByKey("ProjectID", args), ASOFTUtilities.GetDataByKey("ProjectName", args), ASOFTUtilities.GetDataByKey("ContractID", args), ASOFTUtilities.GetDataByKey("LeaderID", args), ASOFTUtilities.GetDataByKey("DepartmentID", args), ASOFTUtilities.GetDataByKey("StatusID", args), ASOFTUtilities.GetDataByKey("AssignedToUserID", args), "1" , requestPage, requestPageSize);

            ds.Data = dt;
            int GridTotalRaw = 0;
            if (dt.Rows.Count > 0)
            {
                if (int.TryParse(dt.Rows[0]["TotalRow"].ToString(), out GridTotalRaw))
                {
                    ds.TotalRow = GridTotalRaw;
                }
            }

            output.Add("kq", ds);
        }
    }
}
