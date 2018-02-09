$(document).ready(function () {

    //Thời gian đào tạo
    $(".TrainingFromDate").parent().addClass("TrainingDate");
    $(".TrainingDate .content-label").text("Thời gian đào tạo");
    if ($(".TrainingFromDate").text() != "" && $(".TrainingToDate").text() != "") {
        $(".TrainingFromDate").text($(".TrainingFromDate").text() + " - " + $(".TrainingToDate").text());
    }
    $(".TrainingToDate").parent().css("display", "none");
    ////
    CheckCanEdit();
})

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF2080/CheckUpdateData?TrainingRequestID=' + pk + "&Mode=0",
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").parent().addClass('asf-disabled-li');
            }
        }
    });
}

/**  
* Get data Send Mail
*
* [Kim Vu] Create New [11/12/2017]
**/
function customSendMail() {
    var dataSet = {};
    var url = "/HRM/Common/GetUsersSendMail"
    ASOFT.helper.postTypeJson(url, { formID: 'HRMF2081', departmentID: $(".DepartmentID").html() }, function (result) {
        dataSet.EmailToReceiver = result;
    });
    return dataSet;
}

