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
            return View();
        }
        
        public string Create(HoiVien hv)
        {
            var db = new PetaPoco.Database("MyConnection");
            hv.APK = Guid.NewGuid();
            try { db.Insert(hv); }
            catch (Exception e)
            {
                if (e.Message.Contains("Violation of PRIMARY KEY"))
                {
                    return "pk";
                }
                return e.ToString();
            }
            return "ok";
        }

        [HttpPost]
        public ActionResult xoa(string[] dulieu, int trang)
        {
            var db = new PetaPoco.Database("MyConnection");
            for (int i = 0; i < dulieu.Length; i++)
            {
                string qr = string.Format("delete from hoivien where APK = '{0}'",dulieu[i]);
                db.Execute(qr);
            }
            return LoadDefault(trang);
        }

        [HttpPost]
        public ActionResult enable(string[] dulieu,int trang)
        {
            var db = new PetaPoco.Database("MyConnection");
            for (int i = 0; i < dulieu.Length; i++)
            {
                string qr = string.Format("update hoivien set Disable = '0' where APK = '{0}'", dulieu[i]);
                db.Execute(qr);
            }
            return LoadDefault(trang);
        }

        [HttpPost]
        public ActionResult disable(string[] dulieu,int trang)
        {
            var db = new PetaPoco.Database("MyConnection");
            for (int i = 0; i < dulieu.Length; i++)
            {
                string qr = string.Format("update hoivien set Disable = '1' where APK = '{0}'", dulieu[i]);
                db.Execute(qr);
            }
            return LoadDefault(trang);
        }

        [HttpPost]
        public ActionResult GanTempData(string[] dulieu,int trang)
        {
            TempData["dieukienloc"] = dulieu;
            return LoadDefault(trang);
        }
       
        public ActionResult LoadDefault(int trang)
        {
            var db = new PetaPoco.Database("MyConnection");
            PetaPoco.Page<HoiVien> kq;
            if (TempData["dieukienloc"] == null)
            {
                //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
                kq = db.Page<HoiVien>(trang,10,"select * from HoiVien");
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
                kq = db.Page<HoiVien>(trang,10,qr);
            }
            TempData["total"] = kq.TotalPages;
            return Json(kq.Items, JsonRequestBehavior.AllowGet);
        }
        public int TotalPage()
        {
            int t = int.Parse(TempData["total"].ToString());
            return t;
        }
    }
}
