
$(document).ready(function () {
   $("#CSMF1021").prepend("<table id = 'csmf1021' style = 'width:100%'></table>");
   $("#csmf1021").append($(".FirmID"), $(".GroupErrID"), $(".GroupErrName"), $(".Notes"), $(".IsCommon"), $(".Disabled"));
   if ($("#isUpdate").val() == "True") {
       $("#IsCommon").attr("disabled", "disabled");
   }
});




