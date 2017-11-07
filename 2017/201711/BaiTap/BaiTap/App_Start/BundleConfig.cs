using System;
using System.Collections.Generic;
using System.Linq; 
using System.Web;
using System.Web.Optimization;

namespace BaiTap.App_Start
{
    public class BundleConfig
    {
        public static void RegisterBundleConfig(BundleCollection bundle)
        {

            var ScriptsBundle = new ScriptBundle("~/bundles/scripts").Include(
                "/Scripts/Library/jquery-{version}.js",
                "/Scripts/Library/kendo.all.min.js",
                "/Scripts/Library/kendo.aspnetmvc.min.js",
                "/Scripts/Library/kendo.modernizr.custom.js"
            );

            var StylesBundle = new StyleBundle("~/bundles/styles").Include(
                "/Content/Library/kendo.blueopal.min.css",
                "/Content/Library/kendo.common.min.css",
                "/Content/Library/kendo.defaut.min.css"
                );

        }
    }
}