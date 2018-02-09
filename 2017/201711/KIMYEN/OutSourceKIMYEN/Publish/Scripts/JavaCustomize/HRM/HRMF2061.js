var templateIsQuarterYear = "<tr class ='templateIsQuarterYear'><td class=\"asf-td-caption\"><label>Lập ngân sách theo</label></td><td colspan=\"2\" class = \"asf-td-field\"></td></tr>";
var divQuarterYear = "<div id=\"divQuarterYear\"></div>";
var oldVoucherNo = "";

$(document).ready(function () {    
    $("#btnAssignedToUserName").bind('click', btnChooseUserName_Click);
    $("#btnDeleteAssignedToUserName").bind('click', btnDeleteUserNameD_Click);
    $(".TranQuarterYear").before(templateIsQuarterYear);
    $(".templateIsQuarterYear .asf-td-field").append(divQuarterYear);
    var rdo = $("input[type='radio']").parent().parent();
    $($("input[type='radio']").parent().parent()).css('width', '46%');
    $($("input[type='radio']").parent().parent()).css('float', 'left');
    $(".TranQuarterYear").before(rdo[0]);
    $(".TranQuarterYear").before(rdo[1]);
    $('div#divQuarterYear').append(rdo);
    $('.templateIsQuarterYear td').css('vertical-align', 'top');
    if ($("#IsBugetYear").val()) {
        $('input:radio[id="IsQuarterYear"][value="' + $("#IsBugetYear").val() + '"]').prop('checked', true);
    } else {
        $("#IsQuarterYear").prop('checked', true);
        $("#IsBugetYear").val("1"); 
    }

    $("input[type='radio']").bind('click', function () {
        $("#IsBugetYear").val($(this).val());
        $("#TranQuarterYear").data("kendoComboBox").value("");
    });

    var cboQuarterYear = $("#TranQuarterYear").data("kendoComboBox");
    if (cboQuarterYear) {
        cboQuarterYear.bind('change', function () {
            var data = cboQuarterYear.dataItem();
            $("#TranQuarter").val(data.TranQuarter);
            $("#TranYear").val(data.TranYear);
        });
    }

    $(".IsBugetYear").css('display', 'none');
    if ($('#isUpdate').val() != "True") {
        autoCode();
    }
    else {
        $("#BudgetID").attr("readonly", true);
    }

    $("#DepartmentID").bind('change', function(e) {
        var cbo = $("#DepartmentID").data('kendoComboBox');
        if (cbo) {
            var item = cbo.dataItem();
            if (item.DepartmentID == '%') {
                $("#IsAll").prop('checked', true);
                IsAll_CheckedChange(null);
            }
        }
    });
    $("#IsAll").bind('click', IsAll_CheckedChange);
});

function btnChooseUserName_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});    
}

function btnDeleteUserNameD_Click() {
    $("#AssignedToUserID").val('');
    $('#AssignedToUserName').val('');
}

function receiveResult(result) {
    $("#AssignedToUserID").val(result.EmployeeID);
    $('#AssignedToUserName').val(result.EmployeeName);
};

// Event IsAll checked change
function IsAll_CheckedChange(e) {
    if ($("#IsAll").prop('checked')) {
        $($("#DepartmentID").parent().parent()).addClass('asf-disabled-li');
        $("#DepartmentID").val("%");
        //$("#DepartmentID").data('kendoComboBox').select(0);
    } else {
        $($("#DepartmentID").parent().parent()).removeClass('asf-disabled-li');
        //$("#DepartmentID").data('kendoComboBox').select(1);
    }
};

/**  
* Process auto Code
*
* [Kim Vu] Create New [11/12/2017]
**/
function autoCode() {
    var url = "/HRM/HRMF2060/GetVoucherNoText"
    ASOFT.helper.postTypeJson(url, {}, function (result) {
        if (result) {
            $("#BudgetID").val(result);
            oldVoucherNo = result;
        }
    })
}

/**  
* Process after insert data
*
* [Kim Vu] Create New [11/12/2017]
**/
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && ($("#isUpdate").val() != "True")) {
        var url = "/HRM/HRMF2060/UpdateVoucherNo"
        ASOFT.helper.postTypeJson(url, { VoucherNo: oldVoucherNo }, null);
        if (action == 1) {
            $("#HRMF2061")[0].reset();
        }
        autoCode();
    }
}

function CustomerCheck() {
    var messagemaster = [];
    var msg = "{0} Không được là số âm";

    if (Number($("#BudgetAmount").val()) < 0) {
        messagemaster.push(msg.f(ASOFT.helper.getLanguageString("HRMF2061.BudgetAmount", "HRMF2061", "HRM")));
    }
    if (messagemaster.length > 0) {
        ASOFT.form.displayError("#HRMF2061", messagemaster);
        return true;
    }
}