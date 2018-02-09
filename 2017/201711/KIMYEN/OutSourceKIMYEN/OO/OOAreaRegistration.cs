using System.Web.Mvc;

namespace ASOFT.ERP.OO
{
    public class OOAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "OO";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "OO_default",
                "OO/{controller}/{action}/{id}",
                 defaults: new
                 {
                     area = "OO",
                     controller = "DashBoard",
                     action = "Index",
                     id = UrlParameter.Optional
                 });
        }
    }
}
