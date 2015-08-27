using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TestKendo.Models
{
    public class EmailModels
    {
        public string From { get; set; }
        public string To { get; set; }
        public string Object { get; set; }
        public string Body { get; set; }
    }
}