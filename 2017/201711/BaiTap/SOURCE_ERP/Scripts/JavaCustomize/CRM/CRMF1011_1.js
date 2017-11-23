
var DefaultViewModel;
var ChooseStatus;
var DivisionID = null;
var isCl = false;
var dataVarchar = null;
var para;

$(document).ready(function () {
    var urlPopup = window.location.href;
    para = urlPopup.split('?')[1];

    if ($("#isUpdate").val() == "False") {
        //$("#IsCommon").attr("checked", "checked");
        $("#RelatedToTypeID").val(3);
        $("#AssignedToUserName").val(ASOFTEnvironment.UserName);
        $("#AssignedToUserID").val(ASOFTEnvironment.UserID);
    }
    $("#SaveCopy").unbind();
    $("#SaveCopy").kendoButton({
        "click": CustomSaveCopy_Click,
    });

    $("#SaveNew").unbind();
    $("#SaveNew").kendoButton({
        "click": CustomSaveNew_Click,
    });

    DivisionID = $("#DivisionID").val();

    //Kiem tra regex

    DefaultViewModel = GetDataCRMF1011();

    ASOFT.partialView.Load("/CRM/CRMF1011/PartialBtnAccountName?IsVATAccountID=" + $("#IsVATAccountID").is(':checked'), "#VATAccountName", 0);
    ASOFT.partialView.Load("/CRM/CRMF1011/PartialBtnRouteName", "#RouteName", 0);
    setTimeout(function () {
        CustomRenderCommon();
        if ($("#isUpdate").val() == "True" && $(".InheritConvertID").length == 0 && para != "isAdd=1") {
            GetVarCharFirst();
            $("#ConvertUserID").val('N');
            CustomRenderUpdate();
            $("#S1").data("kendoComboBox").readonly(true);
            $("#S2").data("kendoComboBox").readonly(true);
            $("#S3").data("kendoComboBox").readonly(true);
            defaultViewModel = GetDataCRMF1011();
        }
        else {
            //isUpdate
            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": CustomClose_Click,
            });
            CustomRenderAddNew();
            GetAccountID();

            $("#S1").change(function () { GetAccountID() });
            $("#S2").change(function () { GetAccountID() });
            $("#S3").change(function () { GetAccountID() });
        }
        $("#RouteName").focus(function () { $(this).blur(); });
        $("#VATAccountName").focus(function () { $(this).blur(); });
        $("#ContactName").focus(function () { $(this).blur(); });

        //Lấy AccountID
    }, 500);
    $("#ReCreditLimit").val(formatDecimal(kendo.parseFloat($("#ReCreditLimit").val())));

    $("#ReCreditLimit").keyup(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    $("#PeriodWater").val(kendo.parseInt($("#PeriodWater").val()));

    $("#PeriodWater").keyup(function (e) {
        var value = $(this).val();
        value = kendo.parseInt(value);
        $(this).val(value);
    });

    $("#BottleLimit").val(formatDecimal(kendo.parseFloat($("#BottleLimit").val())));

    $("#BottleLimit").keyup(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    if ($('meta[name=customerIndex]').attr('content') == 51) {
        $("#Address").bind("focusout", function () {
            $("#DeliveryAddress").val($("#Address").val());
        })

        $("#DeliveryCountryID").val("VN");
    }

    $("#DeliveryDistrictID").change(function () {
        $("#O02ID").data("kendoComboBox").value($("#DeliveryDistrictID").val());
    })

    $(".AccountID").parent().prepend($(".S3"));
    $(".AccountID").parent().prepend($(".S2"));
    $(".AccountID").parent().prepend($(".S1"));
    $(".line_left tbody").prepend($(".AssignedToUserName"));
    //$(".line_left tbody").prepend($(".Tel"));


    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee1_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click()"></a>';

    $("#AssignedToUserName").after(btnFromEmployee);
    $("#AssignedToUserName").after(btnDelete);
    $("#AssignedToUserName").attr('disabled', 'disabled');

    $("#Varchar").remove();
    $(".Varchar .asf-td-field").append('<a id="btnChooseVarchar" style="width : 26px; height: 26px" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseVarchar_Click()"><span class="asf-button-text">...</span></a>');
})

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}

function btnSearchEmployee_Click() {
    ChooseStatus = 4;
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function CustomRenderCommon() {
    $($(".AssignedToUserName td")[0]).append('<span class="asf-label-required">*</span>')
    $(".AssignedToUserName").after($(".IsUsing"));
    $(".AssignedToUserName").after($(".IsCommon"));
    //$(".IsCommon").before($(".Fax"));
    //$(".IsCommon").before($(".Website"));
    //$(".IsCommon").before($(".Description"));
    $(".IsCommon").before($(".BirthDate"));
    $(".IsCommon").before($(".BusinessLinesID"));

    $("#AssignedToUserName").attr("data-val-required", "The field is required");
    
    if ($(".InheritConvertID").length > 0 || para == "isAdd=1") {
        //$("#IsCommon").attr("checked", "checked");
        $("#Save").unbind();
        $("#Save").kendoButton({
            "click": CustomSaveCopy_Click,
        });

        $("#AssignedToUserName").val(ASOFTEnvironment.UserName);
        $("#AssignedToUserID").val(ASOFTEnvironment.UserID);

        isCl = true;
        if (para != "isAdd=1") {
            $(".Fax").after($(".InheritConvertID"));
            $(".Fax").after($(".ConvertUserID"));
            $(".AssignedToUserName").after($(".IsCommon"));
            $(".AssignedToUserName").after($(".IsUsing"));
            //$(".AssignedToUserName").after($(".Description"));
            $(".AssignedToUserName").after($(".BirthDate"));
            $(".AssignedToUserName").after($(".BusinessLinesID"));
            //$(".AssignedToUserName").after($(".Website"));
            //$(".AssignedToUserName").after($(".Fax"));
            //$(".Email").after($(".InheritConvertID"));
            $(".IsCommon").after($(".O01ID"));
            $("#InheritConvertID").attr("readonly", "readonly");
            $("#ConvertUserID").attr("readonly", "readonly");

            var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

            var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromEmploy_Click(1)"></a>';
            $("#ConvertUserID").after(btnFromEmployee);
            $("#ConvertUserID").after(btnDelete);
        }

    }


    if (!$("#IsVATAccountID").is(':checked')) {
        $("#VATAccountName").attr("Disabled", true);
    }
    $(".IsVATAccountID").css("display", "none");
    $(".VATAccountName").find(".asf-td-caption").find("label").before($("#IsVATAccountID"));

    var AccountInfo = "<fieldset id='GroupAccountInfo'><legend><label>" + $("#CommonInfo").val() + "</label></legend></fieldset>";
    $(".container_12").after(AccountInfo);
    $("#GroupAccountInfo").prepend($(".container_12"));


    var Group = "<div class='container_12'><div class='grid_6'><fieldset id='left2'><legend><label>" + $("#BillInfo").val() + "</label></legend></fieldset></div><div class='grid_6 line_left'><fieldset id='right2'><legend><label>" + $("#DeliveryInfo").val() + "</label></legend></fieldset></div></div>";

    $("#GroupAccountInfo").after(Group);

    MoveElement("BillWard", "left2");
    MoveElement("BillDistrictID", "left2");
    MoveElement("BillCityID", "left2");
    MoveElement("BillPostalCode", "left2");
    MoveElement("BillCountryID", "left2");
    MoveElement("BillAddress", "left2");

    MoveElement("DeliveryWard", "right2");
    MoveElement("DeliveryDistrictID", "right2");
    MoveElement("DeliveryCityID", "right2");
    MoveElement("DeliveryPostalCode", "right2");
    MoveElement("DeliveryCountryID", "right2");
    MoveElement("DeliveryAddress", "right2");

    $("#IsVATAccountID").click(function () {
        if ($(this).is(':checked')) {
            $("#VATAccountName").attr("Disabled", false);
            $("#btnChooseVATAccountID").data("kendoButton").enable(true);
            $("#btnDeleteVATAccountID").data("kendoButton").enable(true);
        }
        else {
            $("#VATAccountName").attr("Disabled", true);
            $("#btnChooseVATAccountID").data("kendoButton").enable(false);
            $("#btnDeleteVATAccountID").data("kendoButton").enable(false);
        }
    });

};

function MoveElement(ClassMove, IDAppend) {
    $("#" + IDAppend).prepend($("." + ClassMove));
}

function btnDeleteFromEmploy_Click() {
    $("#ConvertUserID").val('');
}

function btnDeleteFrom_Click(ac) {
    $("#AssignedToUserName").val('');
    $("#AssignedToUserID").val('');
}

function btnSearchEmployee1_Click() {
    ChooseStatus = 5;
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function CustomRenderAddNew() {
    $(".Disabled").css("display", "none");
    $("#ContactName").attr("Disabled", true);
    var Contactname = $(".ContactName");
    $(".VATAccountName").before(Contactname);
    ASOFT.partialView.Load("/CRM/CRMF1011/PartialBtnContactName?enable=true", "#ContactName", 0);
    //$("#IsOrganize").click(function () {
    //    if ($(this).is(':checked')) {
    //        $("#ContactName").attr("Disabled", false);
    //        $("#btnChooseContactID").data("kendoButton").enable(true);
    //        $("#BtnAddNewContactID").data("kendoButton").enable(true);
    //        $("#btnDeleteContactID").data("kendoButton").enable(true);
    //    }
    //    else {
    //        $("#ContactName").attr("Disabled", true);
    //        $("#btnChooseContactID").data("kendoButton").enable(false);
    //        $("#BtnAddNewContactID").data("kendoButton").enable(false);
    //        $("#btnDeleteContactID").data("kendoButton").enable(false);
    //    }
    //});
};
function CustomRenderUpdate() {
    $("#AccountID").attr("readonly", "readonly");
    $("#AccountID").focus(function () { $(this).blur(); });
    $("#AccountID").css("background-color", "#d0c9c9");
    //if (parent.GetCountDetail() > 0) {
            //$("#IsOrganize").attr('disabled', 'disabled');
            ASOFT.partialView.Load("/CRM/CRMF1011/PartialBtnContactName?enable=true&isDelete=false", "#ContactName", 0);
    //}
    //else {
    //    //$("#IsOrganize").removeAttr("checked");
    //    $("#ContactName").attr("Disabled", true);
    //    ASOFT.partialView.Load("/CRM/CRMF1011/PartialBtnContactName", "#ContactName", 0);
    //    $("#IsOrganize").click(function () {
    //        if ($(this).is(':checked')) {
    //            $("#ContactName").attr("Disabled", false);
    //            $("#btnChooseContactID").data("kendoButton").enable(true);
    //            $("#BtnAddNewContactID").data("kendoButton").enable(true);
    //            $("#btnDeleteContactID").data("kendoButton").enable(true);
    //        }
    //        else {
    //            $("#ContactName").attr("Disabled", true);
    //            $("#btnChooseContactID").data("kendoButton").enable(false);
    //            $("#BtnAddNewContactID").data("kendoButton").enable(false);
    //            $("#btnDeleteContactID").data("kendoButton").enable(false);
    //        }
    //    });
    //}
};

function isRelativeEqual(data1, data2) {
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (data2.hasOwnProperty(prop)) {
                if (data1[prop] !== data2[prop]) {
                    return false;
                }
            }
        }
        return true;
    }
    //return undefined;
    return;
}

function isDataChanged() {
    var dataPost = GetDataCRMF1011();
    return !isRelativeEqual(dataPost, DefaultViewModel);
}

function CustomSaveCopy_Click() {
    $("#ConvertUserID").removeAttr("readonly");
    $("#AssignedToUserName").removeAttr("disabled");
    var data = ASOFT.helper.dataFormToJSON(id);
    var CheckInList;
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            $("#ConvertUserID").attr("readonly", "readonly");
            CheckInList.push(data["CheckInList"]);
        }
        else {
            CheckInList = data["CheckInList"];
        }
    }
    if (ASOFT.form.checkRequiredAndInList(id, CheckInList)) {
        $("#AssignedToUserName").attr("disabled", "disabled");
        $("#ConvertUserID").attr("readonly", "readonly");
        return;
    }
    $("#AssignedToUserName").attr("disabled", "disabled");
    $("#ConvertUserID").attr("readonly", "readonly");
    isUpdate = false;
    action = isCl ? 4 : 2;
    InsertAccount();
};

function CustomSaveNew_Click() {
    $("#ConvertUserID").removeAttr("readonly");
    var data = ASOFT.helper.dataFormToJSON(id);
    var CheckInList = [];
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            CheckInList.push(data["CheckInList"]);
        }
        else {
            CheckInList = data["CheckInList"];
        }
    }
    if (ASOFT.form.checkRequiredAndInList(id, CheckInList)) {
        $("#ConvertUserID").attr("readonly", "readonly");
        return;
    }
    $("#ConvertUserID").attr("readonly", "readonly");
    isUpdate = false;
    action = 1;
    InsertAccount();
};

function CustomClose_Click() {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(
           AsoftMessage['00ML000016'],
           function () {
               action = 4;
               $("#ConvertUserID").removeAttr("readonly");
               if (ASOFT.form.checkRequired(id)) {
                   $("#ConvertUserID").attr("readonly", "readonly");
                   return;
               }
               $("#ConvertUserID").attr("readonly", "readonly");
               InsertAccount();
           },
           function () {
               parent.popupClose()
           })
    } else {
        //Nếu dữ liệu không bị thay đổi, thì đóng màn hình
        parent.popupClose();
    }
};


function InsertAccount() {
    var data = GetDataCRMF1011();
    //if (data.IsCommon == 1) {
        ASOFT.helper.postTypeJson('/CRM/CRMF1011/CheckSQL001', data, function (result) {
            if (result.Status == 1) {
                //CheckSQL002();
                InsertAccountActivity();
            }
            else {
                ASOFT.form.displayWarning('#CRMF1011', kendo.format(ASOFT.helper.getMessage(result.Message), result.Data));
                GetAccountID();
            }
        });
    //}
    //else {
    //    ASOFT.helper.postTypeJson('/CRM/CRMF1011/CheckSQL001', data, function (result) {
    //        if (result.Status == 1) {
    //            InsertAccountActivity();
    //        }
    //        else {
    //            ASOFT.form.displayWarning('#CRMF1011', kendo.format(ASOFT.helper.getMessage(result.Message), result.Data));
    //            GetAccountID();
    //        }
    //    });
    //}
};

function GetDataCRMF1011() {
    var datamaster = ASOFT.helper.dataFormToJSON("CRMF1011");

    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            datamaster[id] = "1";
        }
        else {
            datamaster[id] = "0";
        }
    })
    return datamaster;
};

function CheckSQL002() {
    var data = GetDataCRMF1011();
    ASOFT.helper.postTypeJson('/CRM/CRMF1011/CheckSQL002', data, function (result) {
        if (result.Status == 1) {
            InsertAccountActivity();
        }
        else {
            ASOFT.form.displayWarning('#CRMF1011', ASOFT.helper.getMessage(result.Message));
        }
    });
}

function InsertAccountActivity() {
    var data = GetDataCRMF1011();
    ASOFT.helper.postTypeJson('/CRM/CRMF1011/InsertAccount', data, function (result) {
        if (result.Status == 1) {
            result.Status = 0;
            if (para == "isAdd=1") {
                if (typeof parent.QuickAddCommon === "function") {
                    parent.QuickAddCommon($("#AccountID").val());
                }
            }
            onInsertSuccess(result)
            DivisionID = $("#DivisionID").val(DivisionID);
        }
        else {
            ASOFT.form.displayWarning('#CRMF1011', ASOFT.helper.getMessage(result.Message));
        }
    });
}

//Xử lý các button trên màn hình
function btnChooseRouteID_Click() {
    ChooseStatus = 1;
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val(), {});
};
function btnChooseVATAccountID_Click() {
    ChooseStatus = 2;
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val(), {});
};
function BtnAddNewContactID_Click() {
    urlct = "/PopupLayout/Index/CRM/CRMF2007";
    ChooseStatus = 0;
    ASOFT.asoftPopup.showIframe(urlct, {});
};
function btnChooseContactID_Click() {
    ChooseStatus = 3;
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CRM/CRMF9002?DivisionID=" + $("#DivisionID").val(), {});
};
function btnDeleteRouteID_Click() {
    $("#RouteName").val("");
    $("#RouteID").val("");
};
function btnDeleteVATAccountID_Click() {
    $("#VATAccountName").val("");
    $("#VATAccountID").val("");
};
function btnDeleteContactID_Click() {
    $("#ContactName").val("");
    $("#ContactID").val("");
};

function receiveResult(result) {
    //if (ChooseStatus == 1) {
    //    $("#RouteName").val(result["RouteName"]);
    //    $("#RouteID").val(result["RouteID"]);
    //}
    //else if (ChooseStatus == 2) {
    //    $("#VATAccountName").val(result["AccountName"]);
    //    $("#VATAccountID").val(result["AccountID"]);
    //}
    //else if (ChooseStatus == 3 || ChooseStatus == 0) {
    //    $("#ContactName").val(result["ContactName"]);
    //    $("#ContactID").val(result["ContactID"]);
    //}
    if (ChooseStatus == 4)
    {
        $("#ConvertUserID").val(result["EmployeeID"]);
    }
    if (ChooseStatus == 5)
    {
        $("#AssignedToUserName").val(result["EmployeeName"]);
        $("#AssignedToUserID").val(result["EmployeeID"]);
    }
};



function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}

function GetAccountID() {
    var S = [];
    S.push($("#S1").val());
    S.push($("#S2").val());
    S.push($("#S3").val());
    ASOFT.helper.postTypeJson('/CRM/CRMF1011/GetAccountID', S, function (result) {
        $("#AccountID").val(result.AccountID);
    });
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && (action == 1 || action == 2)) {
        $("#RelatedToTypeID").val(3);
        GetAccountID();
        if (action == 1)
        {
            $("#AssignedToUserName").val(ASOFTEnvironment.UserName);
            $("#AssignedToUserID").val(ASOFTEnvironment.UserID);
            $("#BirthDate").data("kendoDatePicker").value(new Date());
        }
    }
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
    if (result.Message == "00ML000053") {
        GetAccountID();
    }
}

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "S1" && key != "S2" && key != "S3") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                $("#" + key).val('');
            }
        }
    })
}

function GetVarchar() {
    return dataVarchar;
}

function SetVarchar(dtVarchar) {
    dataVarchar = dtVarchar;
    if (dtVarchar != null) {
        for (var k = 1; k <= 20; k++) {
            var stringV = k < 10 ? "Varchar0" : "Varchar";
            $("#" + stringV + k).val(dtVarchar[stringV + k] != undefined ? dtVarchar[stringV + k] : "");
        }
    }
}

function GetVarCharFirst() {
    ASOFT.helper.postTypeJson("/CRM/CRMF1011/GetVarchar?APK=" + $("#APK").val(), {}, function (result) {
        dataVarchar = result;
        if (result != null) {
            for (var k = 1; k <= 20; k++) {
                var stringV = k < 10 ? "Varchar0" : "Varchar";
                $("#" + stringV + k).val(result[stringV + k]);
            }
        }
    });
}


function btnChooseVarchar_Click() {
    urlChooseVarchar = "/CRM/CRMF1011/CRMF1013?DivisionID=" + $("#DivisionID").val() + "&T=C__";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVarchar, {});
}