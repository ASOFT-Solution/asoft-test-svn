
$(document).ready(function () {
   $("#CSMF1031").prepend("<table id = 'csmf1031' style = 'width:100%'></table>");
   $("#csmf1031").append($(".ErrorID"), $(".ErrorName"), $(".GroupErrID"), $(".Notes"), $(".IsCommon"), $(".Disabled"));
   if ($("#isUpdate").val() == "True") {
       $("#IsCommon").attr("disabled", "disabled");
   }
});


