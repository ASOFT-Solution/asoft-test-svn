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
    public class OOF2092_OOT2091MainExecute : CodeActivity
    {
        public InOutArgument<Dictionary<string, Object>> InOut { get; set; }
        public InOutArgument<string> Area { get; set; }
        public InOutArgument<string> ScreenID { get; set; }

        protected override void Execute(CodeActivityContext context)
        {
            Dictionary<string, List<string>> args = (Dictionary<string, List<string>>)InOut.Get(context)["args"];
            int requestPage = int.Parse(InOut.Get(context)["requestPage"].ToString());
            int requestPageSize = int.Parse(InOut.Get(context)["requestPageSize"].ToString());
            ASOFTSysGrid ds = new ASOFTSysGrid();
            List<string> list = new List<string>();
            args.TryGetValue("value[]", out list);
            Guid apk;

            OOF2092BL OOF2092bl = new OOF2092BL();

            if (Guid.TryParse(list[0], out apk))
            {
                ds.Data = OOF2092bl.LoadData(apk, requestPageSize, requestPage);
            }

            Dictionary<string, Object> Ouput = InOut.Get(context);
            Ouput.Add("kq", ds);
        }

    }
}
