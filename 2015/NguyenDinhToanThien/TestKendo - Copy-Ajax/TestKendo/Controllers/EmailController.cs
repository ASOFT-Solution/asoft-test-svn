using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;
using TestKendo.Models;

namespace TestKendo.Controllers
{
    public class EmailController : Controller
    {
        //
        // GET: /Email/

        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(EmailModels model)
        {
            var mail = new SmtpClient("smtp.gmail.com", 25)
            {
                Credentials = new NetworkCredential("quanghoang1908@gmail.com","captcha1122"),
                EnableSsl = true
            };
            var message = new MailMessage();
            message.From = new MailAddress(model.From);
            message.ReplyToList.Add(model.From);
            message.To.Add(new MailAddress(model.To));
            message.Subject = model.Object;
            message.Body = model.Body;

            mail.Send(message);
            return RedirectToAction("Success");
            //WebMail 
        }
        public ActionResult Success()
        {
            return View();
        }
    }
}
