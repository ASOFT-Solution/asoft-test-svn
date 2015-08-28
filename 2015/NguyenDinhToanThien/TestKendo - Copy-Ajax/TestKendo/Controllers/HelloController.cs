using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using MyConnection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TestKendo.Models;

namespace TestKendo.Controllers
{
    public class HelloController : Controller
    {
        //
        // GET: /Hello/

        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(FormCollection frmc)
        {
            TempData["frmc"] = frmc;
            return View();
        }
        public ActionResult Customers_Read([DataSourceRequest]DataSourceRequest request)
        {
            IEnumerable<HoiVien> kq;
            TempData.Keep("frmc");
            if (TempData["frmc"] == null)
            {
                var db = new PetaPoco.Database("MyConnection");
                //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
                kq = db.Query<HoiVien>("select * from HoiVien");
            }
            else
            {
                FormCollection frmc = (FormCollection)TempData["frmc"];
                var db = new PetaPoco.Database("MyConnection");
                //Thiet lap cau truy van dua tren dieu kien loc
                string qr = "select * from HoiVien where 1=1";
                if (frmc["donvi"] != "")
                {
                    qr = qr + string.Format(" and DivisionID like N'%{0}%'", frmc["donvi"]);
                }
                if (frmc["diachi"] != "")
                {
                    qr = qr + string.Format(" and Address like N'%{0}%'", frmc["diachi"]);
                }
                if (frmc["sodienthoai"] != "")
                {
                    qr = qr + string.Format(" and Phone like N'%{0}%'", frmc["sodienthoai"]);
                }
                if (frmc["mahoivien"] != "")
                {
                    qr = qr + string.Format(" and MemberID like N'%{0}%'", frmc["mahoivien"]);
                }
                if (frmc["cmnd"] != "")
                {
                    qr = qr + string.Format(" and Identify like N'%{0}%'", frmc["cmnd"]);
                }
                if (frmc["fax"] != "")
                {
                    qr = qr + string.Format(" and Fax like N'%{0}%'", frmc["fax"]);
                }
                if (frmc["tenhoivien"] != "")
                {
                    qr = qr + string.Format(" and MemberName like N'%{0}%'", frmc["tenhoivien"]);
                }
                if (frmc["dtdd"] != "")
                {
                    qr = qr + string.Format(" and Tel like N'%{0}%'", frmc["dtdd"]);
                }
                if (frmc["email"] != "")
                {
                    qr = qr + string.Format(" and Email like N'%{0}%'", frmc["email"]);
                }
                kq = db.Query<HoiVien>(qr);
            }
            return Json(kq.ToDataSourceResult(request));
        }
        public ActionResult Xoa()
        {
            return null;
        }
        public ActionResult Menu()
        {
            var db = new PetaPoco.Database("MyConnection");
            //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
            return PartialView(db.Query<MenuDaCap>("select * from MenuDaCap").ToList());
        }
        public ActionResult SendMail()
        {
            return View();
        }
        public ActionResult Combobox()
        {
            List<LopModels> lmd = new List<LopModels>();
            List<SelectListItem> ds = new List<SelectListItem>();
            for (int i = 1; i < 6; i++)
            {
                LopModels l = new LopModels();
                l.MaLop = i.ToString();
                l.TenLop = "Lop " + i;
                SelectListItem sl = new SelectListItem()
                {
                    Text = l.TenLop,
                    Value = l.MaLop
                };
                ds.Add(sl);
                lmd.Add(l);
            }
            ViewBag.ds = ds;
            return View(lmd);
        }

        public ActionResult Ketqua(FormCollection fr)
        {
            ViewBag.ds = fr["lop"];
            return View();
        }
    }
}
