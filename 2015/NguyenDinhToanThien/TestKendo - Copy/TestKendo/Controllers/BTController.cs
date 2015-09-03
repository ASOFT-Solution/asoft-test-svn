using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MyConnection;
using System.Collections;

namespace TestKendo.Controllers
{
    public class BTController : Controller
    {
        //
        // GET: /BT/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Customers_Read([DataSourceRequest]DataSourceRequest request)
        {
            return Json(GetCustomers().ToDataSourceResult(request));
        }

        public bool GanTempData(string[] dulieu)
        {
            TempData["dieukienloc"] = dulieu;
            return true;
        }

        public IEnumerable<HoiVien> GetCustomers()
        {
            var db = new PetaPoco.Database("MyConnection");
            IEnumerable<HoiVien> kq;
            if (TempData["dieukienloc"] == null)
            {
                //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
                kq = db.Query<HoiVien>("select * from HoiVien where Disable = '0'");
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
                if (frmc[1] != "")
                {
                    qr = qr + string.Format(" and Address like N'%{0}%'", frmc[1]);
                }
                if (frmc[2] != "")
                {
                    qr = qr + string.Format(" and Phone like N'%{0}%'", frmc[2]);
                }
                if (frmc[3] != "")
                {
                    qr = qr + string.Format(" and MemberID like N'%{0}%'", frmc[3]);
                }
                if (frmc[4] != "")
                {
                    qr = qr + string.Format(" and Identify like N'%{0}%'", frmc[4]);
                }
                if (frmc[5] != "")
                {
                    qr = qr + string.Format(" and Fax like N'%{0}%'", frmc[5]);
                }
                if (frmc[6] != "")
                {
                    qr = qr + string.Format(" and MemberName like N'%{0}%'", frmc[6]);
                }
                if (frmc[7] != "")
                {
                    qr = qr + string.Format(" and Tel like N'%{0}%'", frmc[7]);
                }
                if (frmc[8] != "")
                {
                    qr = qr + string.Format(" and Email like N'%{0}%'", frmc[8]);
                }
                if (frmc[9] == "")
                {
                    qr = qr + string.Format(" and Disable = '0'");
                }
                kq = db.Query<HoiVien>(qr);
            }
            return kq;
        }
   
        public bool enable(string[] dulieu)
        {
            var db = new PetaPoco.Database("MyConnection");
            try{
                for (int i = 0; i < dulieu.Length; i++)
                {
                    string qr = string.Format("update hoivien set Disable = '0' where APK = '{0}'", dulieu[i]);
                    db.Execute(qr);
                }return true;
            }
            catch (Exception e)
            {
                return false;
            };

        }

     
        public bool disable(string[] dulieu)
        {
            var db = new PetaPoco.Database("MyConnection");
            try
            {
                for (int i = 0; i < dulieu.Length; i++)
                {
                    string qr = string.Format("update hoivien set Disable = '1' where APK = '{0}'", dulieu[i]);
                    db.Execute(qr);
                }
                return true;
            }
            catch (Exception e)
            {
                return false;
            };
        }

        public bool xoa(string[] dulieu)
        {
            var db = new PetaPoco.Database("MyConnection");
            try{
                for (int i = 0; i < dulieu.Length; i++)
                {
                    string qr = string.Format("delete from hoivien where APK = '{0}'", dulieu[i]);
                    db.Execute(qr);
                }return true;
            }
            catch (Exception e)
            {
                return false;
            };
        }


        public ActionResult testpopup()
        {
            return View();
        }

        public string create(HoiVien hv)
        {
            var db = new PetaPoco.Database("MyConnection");
            hv.APK = Guid.NewGuid();//Tao ma apk moi
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

        public ActionResult Menu()
        {
            var db = new PetaPoco.Database("MyConnection");
            //PetaPoco.Page<HoiVien> rs = MyConnectionDB.GetInstance().Page<HoiVien>(1, 2, "select * from HoiVien");
            return PartialView(db.Query<MenuDaCap>("select * from MenuDaCap").ToList());
        }

    }
}
