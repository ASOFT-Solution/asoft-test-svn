using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PetaPoco;
using Kendo.Mvc.UI;
using MyConnection;
using QuanLy.Models;
using Kendo.Mvc.Extensions;
using System.Collections;

namespace QuanLy.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Message = "Modify this template to jump-start your ASP.NET MVC application.";

            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            var ds = MyConnectionDB.GetInstance().Query<HoiVien>("select * from HoiVien");
            return Json(ds.ToDataSourceResult(request));
        }

        public void srch(string[] srch)
        {
            TempData["search"] = srch;
        }

        public ActionResult Search([DataSourceRequest] DataSourceRequest request)
        {
            string sql = "Select * from HoiVien";
            string temp = "";
            IEnumerable ds;
            string[] srch = (string[])TempData["search"];
            if (srch == null)
            {
                 ds = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            }
            else
            {
                if (srch[0] != "")
                {
                   temp = temp + string.Format(" and DivisionID like N'%{0}%'", srch[0]);
                }
                if (srch[1] != "")
                {
                   temp = temp + string.Format(" and MemberID like N'%{0}%'", srch[1]);
                }
                if (srch[2] != "")
                {
                    temp = temp + string.Format(" and MemberName like N'%{0}%'", srch[2]);
                }
                if (srch[3] != "")
                {
                    temp = temp + string.Format(" and Address like N'%{0}%'", srch[3]);
                }
                if (srch[4] != "")
                {
                    temp = temp + string.Format(" and Identify like N'%{0}%'", srch[4]);
                }
                if (srch[5] != "")
                {
                    temp = temp + string.Format(" and Phone like N'%{0}%'", srch[5]);
                }
                if (srch[6] != "")
                {
                    temp = temp + string.Format(" and Tel like N'%{0}%'", srch[6]);
                }
                if (srch[7] != "")
                {
                    temp = temp + string.Format(" and Fax like N'%{0}%'", srch[7]);
                }
                if (srch[8] != "")
                {
                    temp = temp + string.Format(" and Email like N'%{0}%'", srch[8]);
                }
                if (temp != "")
                {
                    sql = sql + " where 0=0" + temp;
                }
                 ds = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            }
            return Json(ds.ToDataSourceResult(request));
        }

        public void Destroy(string[] destroy)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in destroy)
            {
                string sql = string.Format("delete from hoivien where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        public void Undisable(string[] undisable)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in undisable)
            {
                string sql = string.Format("update HoiVien set Disable = 0 where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        public void Disable(string[] disable)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in disable)
            {
                string sql = string.Format("update HoiVien set Disable = 1 where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your app description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}
