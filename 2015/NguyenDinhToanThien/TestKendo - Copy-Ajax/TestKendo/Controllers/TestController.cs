using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TestKendo.Controllers
{
    public class TestController : Controller
    {
        //
        // GET: /Test/

        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public void ProcessRequest(string methodParam)
        {
            int a = 0;
            int b = 1;
        }
        public ActionResult Tempdata()
        {
            ViewBag.temp = TempData["hoang"];
            return View();
        }

    }
}
