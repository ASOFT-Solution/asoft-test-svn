var NatureDISC = [];
var AdaptiveDISC = [];
var employ = null;

$(document).ready(function () {
    var groupA = "<fieldset id='groupA'><legend><label>" + $($(".GroupA td")[0]).text() + "</label></legend><table class='asf-table-view'></table></fieldset>";
    var groupB = "<fieldset id='groupB'><legend><label>" + $($(".GroupB td")[0]).text() + "</label></legend><table class='asf-table-view'></table></fieldset>";
    $($(".grid_6")[0]).append(groupA);
    $($(".grid_6")[0]).append(groupB);
    $("#groupA .asf-table-view").append($(".Nature_D"));
    $("#groupA .asf-table-view").append($(".Nature_I"));
    $("#groupA .asf-table-view").append($(".Nature_S"));
    $("#groupA .asf-table-view").append($(".Nature_C"));
    $("#groupA .asf-table-view").append($(".Nature"));

    $("#groupB .asf-table-view").append($(".Adaptive_D"));
    $("#groupB .asf-table-view").append($(".Adaptive_I"));
    $("#groupB .asf-table-view").append($(".Adaptive_S"));
    $("#groupB .asf-table-view").append($(".Adaptive_C"));
    $("#groupB .asf-table-view").append($(".Adaptive"));
    $("#Descriptions").attr("style", "width: 99%; height: 1400%");
    $(".GroupA").remove();
    $(".GroupB").remove();

    employ = $("#EmployeeID").data("kendoComboBox");
    if ($("#isUpdate").val() == "False") {
        employ.value(ASOFTEnvironment.UserID);
        $("#EvaluationDate").data("kendoDatePicker").value(new Date());
        var dtEmploy = employ.dataItem(employ.select());
        if (dtEmploy) {
            $("#DepartmentID").data("kendoComboBox").value(dtEmploy.DepartmentID);
            $("#DutyID").data("kendoComboBox").value(dtEmploy.DutyID);
            $("#TitleID").data("kendoComboBox").value(dtEmploy.TitleID);
        }

        ASOFT.helper.postTypeJson("/HRM/HRMF2110/returmAPK", {}, function (result) {
            $("#APK").val(result);
        })
    }
    $("#Nature").attr("readonly", "readonly");
    $("#Adaptive").attr("readonly", "readonly");


    employ.bind('change', function (e) {
        dtEmploy = employ.dataItem(e.sender.select());
        if (dtEmploy) {
            $("#DepartmentID").data("kendoComboBox").value(dtEmploy.DepartmentID);
            $("#DutyID").data("kendoComboBox").value(dtEmploy.DutyID);
            $("#TitleID").data("kendoComboBox").value(dtEmploy.TitleID);
        }
        else {
            $("#DepartmentID").data("kendoComboBox").value("");
            $("#DutyID").data("kendoComboBox").value("");
            $("#TitleID").data("kendoComboBox").value("");
        }
    })

    $("#Nature_D").bind("focusout", function () {
        focusOutNature();
    })
    $("#Nature_I").bind("focusout", function () {
        focusOutNature();
    })
    $("#Nature_S").bind("focusout", function () {
        focusOutNature();
    })
    $("#Nature_C").bind("focusout", function () {
        focusOutNature();
    })

    $("#Adaptive_D").bind("focusout", function () {
        focusOutAdaptive();
    })
    $("#Adaptive_I").bind("focusout", function () {
        focusOutAdaptive();
    })
    $("#Adaptive_S").bind("focusout", function () {
        focusOutAdaptive();
    })
    $("#Adaptive_C").bind("focusout", function () {
        focusOutAdaptive();
    })
    if (window.parent.id == "HRMF1031") {
        $("#EmployeeID").parent().parent().remove();
        $(".EmployeeID").append('<td class="asf-td-field" colspan="2"><input class="asf-textbox" id="EmployeeID" initvalue="" maxlength="" message="" name="EmployeeID" regular="" requaird="1" style="width:100%;height:22px;" type="text" value="" aria-disabled="false" data-val-required="The field is required." readonly="readonly"></td>');
        if ($("#CheckInList").val() == "EmployeeID") {
            $("#CheckInList").remove();
        };
        $("#EmployeeID").val(window.parent.SCREEN1031.EmployeeID);
        $("#DepartmentID").data("kendoComboBox").value(window.parent.SCREEN1031.DepartmentID);
        $("#DutyID").data("kendoComboBox").value(window.parent.SCREEN1031.DutyID);
        $("#Close").unbind();
        $("#Close").bind("click", CustomBtnClose_Click);
    }
})

function focusOutNature() {
    NatureDISC = [];
    if ($("#Nature_D").val() >= 50) {
        NatureDISC.push("D:" + $("#Nature_D").val());
    }
    if ($("#Nature_I").val() >= 50) {
        NatureDISC.push("I:" + $("#Nature_I").val());
    }
    if ($("#Nature_S").val() >= 50) {
        NatureDISC.push("S:" + $("#Nature_S").val());
    }
    if ($("#Nature_C").val() >= 50) {
        NatureDISC.push("C:" + $("#Nature_C").val());
    }

    if (NatureDISC.length == 1) {
        $("#Nature").val(NatureDISC[0].split(':')[0]);
    }
    if (NatureDISC.length == 0) {
        $("#Nature").val("");
    }
    if (NatureDISC.length > 1) {
        for (var i = 0; i < NatureDISC.length; i++)
        {
            for (var j = i; j < NatureDISC.length; j++)
            {
                if (parseFloat(NatureDISC[i].split(':')[1]) < parseFloat(NatureDISC[j].split(':')[1]))
                {
                    var temp = NatureDISC[i];
                    NatureDISC[i] = NatureDISC[j];
                    NatureDISC[j] = temp;
                }
            }
        }
        var strNature = "";
        for (var i = 0; i < NatureDISC.length; i++)
        {
            strNature = strNature + NatureDISC[i].split(':')[0];
        }
        $("#Nature").val(strNature);
    }
}

function focusOutAdaptive() {
    AdaptiveDISC = [];
    if ($("#Adaptive_D").val() >= 50) {
        AdaptiveDISC.push("D:" + $("#Adaptive_D").val());
    }
    if ($("#Adaptive_I").val() >= 50) {
        AdaptiveDISC.push("I:" + $("#Adaptive_I").val());
    }
    if ($("#Adaptive_S").val() >= 50) {
        AdaptiveDISC.push("S:" + $("#Adaptive_S").val());
    }
    if ($("#Adaptive_C").val() >= 50) {
        AdaptiveDISC.push("C:" + $("#Adaptive_C").val());
    }

    if (AdaptiveDISC.length == 1) {
        $("#Adaptive").val(AdaptiveDISC[0].split(':')[0]);
    }
    if (AdaptiveDISC.length == 0) {
        $("#Adaptive").val("");
    }
    if (AdaptiveDISC.length > 1) {
        for (var i = 0; i < AdaptiveDISC.length; i++) {
            for (var j = i; j < AdaptiveDISC.length; j++) {
                if (parseFloat(AdaptiveDISC[i].split(':')[1]) < parseFloat(AdaptiveDISC[j].split(':')[1])) {
                    var temp = AdaptiveDISC[i];
                    AdaptiveDISC[i] = AdaptiveDISC[j];
                    AdaptiveDISC[j] = temp;
                }
            }
        }
        var strAdaptive = "";
        for (var i = 0; i < AdaptiveDISC.length; i++) {
            strAdaptive = strAdaptive + AdaptiveDISC[i].split(':')[0];
        }
        $("#Adaptive").val(strAdaptive);
    }
}

function onAfterInsertSuccess(result, action) {
    if (action == 1 && result.Status == 0) {
        employ.value(ASOFTEnvironment.UserID);
        $("#EvaluationDate").data("kendoDatePicker").value(new Date());
        var dtEmploy = employ.dataItem(employ.select());
        if (dtEmploy) {
            $("#DepartmentID").data("kendoComboBox").value(dtEmploy.DepartmentID);
            $("#DutyID").data("kendoComboBox").value(dtEmploy.DutyID);
            $("#TitleID").data("kendoComboBox").value(dtEmploy.TitleID);
        }

        ASOFT.helper.postTypeJson("/HRM/HRMF2110/returmAPK", {}, function (result) {
            $("#APK").val(result);
        })
    }

    if (action == 2 && result.Status == 0) {
        ASOFT.helper.postTypeJson("/HRM/HRMF2110/returmAPK", {}, function (result) {
            $("#APK").val(result);
        })
    }
}

function CustomBtnClose_Click(e) {
    //popupClose_Click(e);
    window.parent.SCREEN1031.CallBackFromHRMF2111();
};

