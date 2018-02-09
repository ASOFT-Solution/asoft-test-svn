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

namespace ASOFT.ERP.WORKFLOW.OO.EditGridCommon.SearchData
{
    public class OOF2091MainExecute : CodeActivity
    {
        
            // Define an activity input argument of type string 
            public InOutArgument<Dictionary<string, Object>> InOut { get; set; }
            public InOutArgument<string> Area { get; set; }
            public InOutArgument<string> ScreenID { get; set; }

            // If your activity returns a value, derive from CodeActivity<TResult> 
            // and return the value from the Execute method.        
            protected override void Execute(CodeActivityContext context)
            {
                // Obtain the runtime value of the Text input argument 
                // Obtain the runtime value of the Text input argument 
                Dictionary<string, List<string>> args = (Dictionary<string, List<string>>)InOut.Get(context)["args"];
                ASOFTSysGrid ds = new ASOFTSysGrid();
                List<string> list = new List<string>();
                List<string> list1 = new List<string>();
                //Dictionary<string, List<string>> args = (Dictionary<string, List<string>>)InOut.Get(context)["args"];
                //Dictionary<string, Object> Output = InOut.Get(context);
                List<string> systemInfo = args["systemInfo[]"];
                //ASOFTSysGrid ds = new ASOFTSysGrid();
                DataTable dt = new DataTable();
                List<string> value = new List<string>();
                args.TryGetValue("value[]", out list);
                if (list != null)
                {
                    dt = new OOF2091BL().LoadData(ASOFTUtilities.GetDataByKey("APKMaster", args));
                }
                else
                {
                    dt = new OOF2091BL().LoadData(string.Empty);
                }

                ds.Data = dt;
                Dictionary<string, Object> Ouput = InOut.Get(context);
                Ouput.Add("kq", ds);
            }
        }
    
}
