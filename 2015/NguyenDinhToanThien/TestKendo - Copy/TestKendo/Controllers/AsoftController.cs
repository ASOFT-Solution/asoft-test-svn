using MyConnection;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TestKendo.Controllers
{
    public class AsoftController : Controller
    {
        //
        // GET: /Asoft/

        public ActionResult Index()
        {
            var db = new PetaPoco.Database("MyConnection");
            //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
            var kq = db.Query<HoiVien>("select * from HoiVien");
            return View(kq);
        }
        [HttpPost]
        public ActionResult Index(FormCollection frmc)
        {
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
            var kq = db.Query<HoiVien>(qr);
            return View(kq);
        }
        public ActionResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(HoiVien hv)
        {
            var db = new PetaPoco.Database("MyConnection");
            hv.APK = Guid.NewGuid();
            try { db.Insert(hv); }
            catch (Exception e)
            {
                if (e.Message.Contains("Violation of PRIMARY KEY"))
                {
                    ViewBag.loi = "Lỗi trùng khóa chính";
                }
                return View();
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult xoa(string[] dulieu)
        {
            var db = new PetaPoco.Database("MyConnection");
            for (int i = 0; i < dulieu.Length; i++)
            {
                string qr = string.Format("delete from hoivien where APK = '{0}'",dulieu[i]);
                db.Execute(qr);
            }
            return LoadDefault();
        }

        [HttpPost]
        public ActionResult enable(string[] dulieu)
        {
            var db = new PetaPoco.Database("MyConnection");
            for (int i = 0; i < dulieu.Length; i++)
            {
                string qr = string.Format("update hoivien set Disable = '0' where APK = '{0}'", dulieu[i]);
                db.Execute(qr);
            }
            return LoadDefault();
        }

        [HttpPost]
        public ActionResult disable(string[] dulieu)
        {
            var db = new PetaPoco.Database("MyConnection");
            for (int i = 0; i < dulieu.Length; i++)
            {
                string qr = string.Format("update hoivien set Disable = '1' where APK = '{0}'", dulieu[i]);
                db.Execute(qr);
            }
            return LoadDefault();
        }

        [HttpPost]
        public ActionResult GanTempData(string[] dulieu)
        {
            TempData["dieukienloc"] = dulieu;
            return LoadDefault();
        }
       
        public ActionResult LoadDefault()
        {
            var db = new PetaPoco.Database("MyConnection");
            IEnumerable kq;
            if (TempData["dieukienloc"] == null)
            {
                //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
                kq = db.Query<HoiVien>("select * from HoiVien");
            }
            else
            {
                TempData.Keep("dieukienloc");
                string[] frmc = (string[])TempData["dieukienloc"];
                //Thiet lap cau truy van dua tren dieu kien loc
                string qr = "select * from HoiVien where 1=1";
                if (frmc[0] != "")
                {
                    qr = qr + string.Format(" and DivisionID like N'%{0}%'", frmc[0]);
                }
                if (frmc[3] != "")
                {
                    qr = qr + string.Format(" and Address like N'%{0}%'", frmc[3]);
                }
                if (frmc[5] != "")
                {
                    qr = qr + string.Format(" and Phone like N'%{0}%'", frmc[5]);
                }
                if (frmc[1] != "")
                {
                    qr = qr + string.Format(" and MemberID like N'%{0}%'", frmc[1]);
                }
                if (frmc[4] != "")
                {
                    qr = qr + string.Format(" and Identify like N'%{0}%'", frmc[4]);
                }
                if (frmc[7] != "")
                {
                    qr = qr + string.Format(" and Fax like N'%{0}%'", frmc[7]);
                }
                if (frmc[2] != "")
                {
                    qr = qr + string.Format(" and MemberName like N'%{0}%'", frmc[2]);
                }
                if (frmc[6] != "")
                {
                    qr = qr + string.Format(" and Tel like N'%{0}%'", frmc[6]);
                }
                if (frmc[8] != "")
                {
                    qr = qr + string.Format(" and Email like N'%{0}%'", frmc[8]);
                }
                kq = db.Query<HoiVien>(qr);
            }
            return Json(kq, JsonRequestBehavior.AllowGet);
        }

    }
}
