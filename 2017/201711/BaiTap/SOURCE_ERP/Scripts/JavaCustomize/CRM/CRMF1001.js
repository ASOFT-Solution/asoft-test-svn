var isUpdate = null;
var isAdd = false;

$(document).ready(function () {
    noClear = "ContactID";
    isUpdate = $("#isUpdate").val();
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];

    if (isUpdate == "False" || $("#RelColumn").length > 0 || para == "isAdd=1") {
        //$("#IsCommon").attr("checked", "checked");
        $("#RelatedToTypeID").val(2);
        $("#AccountName").attr("Disabled", true);
        $("#IsAccountID").attr("checked", false);
        $("#AccountName").css("width", "200px");
        GetContactID();
        //var url = "/Partial/AccountID/CRM/" + $("#sysScreenID").val();
        //ASOFT.partialView.Load(url, ".IsAccountID", 0);
        if ($("#isUpdate").val() == "True") {
            $("#isUpdate").val("False")
            $("#Save").unbind();
            $("#Save").kendoButton({
                "click": SaveCustom_Click,
            });
            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": popupClose_Click,
            });
            $("#ContactID").removeAttr('readonly');
            isAdd = true;
        }
    }
    
    $(".IsAccountID").hide();

    if ($('meta[name=customerIndex]').attr('content') != 51)
    {
        $("#ContactName").attr("readonly", "");
    }


    //$("#IsAccountID").click(function () {
    //    if ($(this).is(':checked')) {
    //        $("#AccountID").attr("Disabled", false);
    //        $("#btnAddAccount").data("kendoButton").enable(true);
    //        $("#btnDeleteAccount").data("kendoButton").enable(true);
    //        $("#btnChooseAccount").data("kendoButton").enable(true);
    //    }
    //    else {
    //        $("#AccountID").attr("Disabled", true);
    //        $("#btnAddAccount").data("kendoButton").enable(false);
    //        $("#btnDeleteAccount").data("kendoButton").enable(false);
    //        $("#btnChooseAccount").data("kendoButton").enable(false);
    //    }
    //})
    $("#LastName").focusout(function () {
        var last = $("#LastName").val() + " ";
        var first = $("#FirstName").val();
        $("#ContactName").val(last + first);
    })

    $("#FirstName").focusout(function () {
        var last = $("#LastName").val() + " ";
        var first = $("#FirstName").val();
        $("#ContactName").val(last + first);
    })

    $("#Address").focusout(function () {
        $("#HomeAddress").val($("#Address").val());
    })

    $(".BusinessEmail").before($(".Messenger"));
})

function SaveCustom_Click() {
    var url = "/GridCommon/Insert/CRM/CRMF1001";
    action = 2;
    save(url);
}

function GetContactID(t) {
    var url = '/CRM/CRMF1001/GetContactID';
    if(t)
    {
        url = '/CRM/CRMF1001/GetContactID?Update=' + $("#ContactID").val()
    }

    ASOFT.helper.postTypeJson(url, {}, function (result) {
        $("#ContactID").val(result.ContactID);
    });
}

function btnAddAccount_Click() {
    urlojb = "/PopupLayout/Index/CRM/CRMF2005";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlojb, {});
}

function btnChooseAccount_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
}

function btnDeleteAccount_Click() {
    $("#AccountID").val("");
    $("#AccountName").val("");
}


function receiveResult(result) {
    $("#AccountID").removeAttr("disabled");
    $("#AccountID").val(result["AccountID"]);
    $("#AccountName").val(result["AccountName"]);
}


function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#RelatedToTypeID").val(2);
        $("#AccountName").val("");
        $("#IsAccountID").attr("checked", false);
        $("#AccountID").attr("Disabled", true);
        $("#Prefix").data("kendoComboBox").text('');
        $("#BusinessDistrictID").data("kendoComboBox").value('');
        $("#BusinessCityID").data("kendoComboBox").value('');
        $("#BusinessCountryID").data("kendoComboBox").value('');
        $("#HomeDistrictID").data("kendoComboBox").value('');
        $("#HomeCityID").data("kendoComboBox").value('');
        $("#HomeCountryID").data("kendoComboBox").value('');
        $("#BirthDate").data("kendoDatePicker").value(new Date());
        GetContactID();
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

    if (result.Status == 0 && action == 2) {
        if (isAdd) {
            if (typeof parent.QuickAddCommon === "function") {
                parent.QuickAddCommon($("#ContactID").val());
            }
            parent.popupClose();
        }
        $("#RelatedToTypeID").val(2);
        GetContactID();
    }

    if (result.Message == "00ML000053") {
        GetContactID(true);
    }
}

$(document).ready(function () {
    var OrtherInfo = "<fieldset id='GroupOrtherInfo'><legend><label>" + "Thông tin khác" + "</label></legend></fieldset>";
    $("#Tabs-2 .container_12").after(OrtherInfo);
    $("#GroupOrtherInfo").append($("#Tabs-2 .container_12"));

    var Group = "<div class='container_12'><div class='grid_6'><fieldset id='left2'><table class='asf-table-view'></table><legend><label>" + "Cơ quan" + "</label></legend></fieldset></div><div class='grid_6 line_left'><fieldset id='right2'><table class='asf-table-view'></table><legend><label>" + "Nhà riêng" + "</label></legend></fieldset></div></div>";

    $("#GroupOrtherInfo").before(Group);

    MoveElement("BusinessWardID", "left2 .asf-table-view");
    MoveElement("BusinessDistrictID", "left2 .asf-table-view");
    MoveElement("BusinessCityID", "left2 .asf-table-view");
    MoveElement("BusinessPostalCodeID", "left2 .asf-table-view");
    MoveElement("BusinessCountryID", "left2 .asf-table-view");
    MoveElement("BusinessAddress", "left2 .asf-table-view");

    MoveElement("HomeWardID", "right2 .asf-table-view");
    MoveElement("HomeDistrictID", "right2 .asf-table-view");
    MoveElement("HomeCityID", "right2 .asf-table-view");
    MoveElement("HomePostalCodeID", "right2 .asf-table-view");
    MoveElement("HomeCountryID", "right2 .asf-table-view");
    MoveElement("HomeAddress", "right2 .asf-table-view"); //BirthDate//PlaceOfBirth

    $("#GroupOrtherInfo .container_12 .grid_6").not(".line_left").find(".asf-table-view").prepend($(".PlaceOfBirth"));
    $("#GroupOrtherInfo .container_12 .grid_6").not(".line_left").find(".asf-table-view").prepend($(".BirthDate")); 
})

function MoveElement(ClassMove, IDAppend) {
    $("#" + IDAppend).prepend($("." + ClassMove));
}