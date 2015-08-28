using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TestKendo.Models;

namespace TestKendo.Controllers
{
    public class TestViewController : Controller
    {
        //
        // GET: /TestView/

        public ActionResult Index()
        {
            EmailModels a = new EmailModels() { Body = "co body" };
            return View(a);
        }

    }
}
