var currentChoose = null;
var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
var pOperator = 0;
var pAdjustTypeID = null;
var pScreenID = null;
var pCreditVoucherID = null;
var pCreditVoucherNo = null;
var pDisburseVoucherID = null;
var pDisburseVoucherNo = null;
var pVoucherDate = null;
var pCurrencyID = null;
var pExchangeRate = null;
var pBankAccountID = null;
var pPunishRate = null;
var pBeforeOriginalAmount = null;
var pAdjustRate = null;
var pRateBy = null;
var pAdjustFromDate = null;

var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};

var templateAsoftButton = function () {
    this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
        return kendo.format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
            buttonClass,
            buttonID,
            spanClass,
            buttonCaption,
            onclickFunction);
    };

    this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
        return kendo.format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
            buttonID,
            onclickFunction);
    };

    return this;
};

setButtonDeleteDisableWhenObjectChange = function ($Object, $ButtonDelete, buttonEventClick) {

    if (typeof $Object !== "undefined" && typeof $ButtonDelete !== "undefined") {
        if (typeof $Object.val === "function" && typeof $Object.val() !== "undefined") {
            $Object.val() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
        if (typeof $Object.value === "function" && $Object.value() !== "undefined") {
            $Object.value() == ""
            ? $ButtonDelete.unbind("click").children().addClass("disabledButton")
            : $ButtonDelete.bind("click", typeof buttonEventClick === "function" ? buttonEventClick : false).children().removeClass("disabledButton");
        }
    }
    return false;
}

var btnDisburseVoucherNo = '<a id="btSearchFromEmployee" style="z-index:100001; position: absolute; right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchDisburseVoucherNo_Click()">...</a>';

function btnSearchDisburseVoucherNo_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var creditVoucherID = $("#CreditVoucherID").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&CreditVoucherID=", creditVoucherID, "&ScreenID=LMF2041_2&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchDisburseVoucherNo";
}


var btnCreditVoucherNo = '<a id="btSearchFromEmployee" style="z-index:100001; position: absolute; right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchCreditVoucherNo_Click()">...</a>';

function btnSearchCreditVoucherNo_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&ScreenID=LMF2041_1&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchCreditVoucherNo";
}
var templateDescription = "<div class=\"asf-form-container\" style=\" margin-left: 1%;margin-right: 1%;\"><table class=\"asf-table-view\" id=\"ContentAll\"></table></div>";
var templateCurrentExchangeRate = "<div id=\"CurrentExchangeRate\"></div>"



function getResultAfterDelete(result, apkDelete) {

    var $resultAfterDelete = $.map(result, (function (obj) {

        if (obj.APK != apkDelete)
            return obj;
    }));

    return $resultAfterDelete.length > 0 ? $resultAfterDelete : "";
}

function deleteFile(jqueryObjectClick) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll"),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#Attach"),

        $result = JSON.parse($attach.val()),

        $resultAfterDelete = getResultAfterDelete($result, $apkDelete);

    $attach.val(JSON.stringify($resultAfterDelete));

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}

function btnUpload_click(e) {

    var urlPopup3 = "/AttachFile?Type=2";

    ASOFT.asoftPopup.showIframe(urlPopup3, {});

    currentChoose = "Attach";
}

function btnDeleteUpload_click(e) {

    $(".templeteAll").remove();

    $("#Attach").val("").trigger("change");
}

var ListChoose = {
    "Attach": function (result) {

        var $templeteParent = $(".templeteAll"),

            templeteAll = result.map(function (obj) {

                var objFileName = obj.AttachName,

                    objFileID = obj.APK;

                return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplate;
            }),

            parentAttach = $("#Attach").parent(),

            templeteAll = templeteAll.join(""),

            $attach = $("#Attach");

        $templeteParent.remove();

        templeteParent = "<div class='templeteAll'>{0}</div>";

        parentAttach.append(kendo.format(templeteParent, templeteAll));

        var objFileID = result.map(function (obj) {
            return obj.AttachID;
        });

        $attach.val(objFileID.join(',')).trigger("change");

        $(".x-close").unbind("click").bind("click", function () {
            deleteFile($(this));
        });
    },
    "SearchCreditVoucherNo": function (result) {
        $('#CreditVoucherID').val(result.Column01);
        $('#CreditVoucherNo').val(result.Column02);
    },
    "SearchDisburseVoucherNo": function (result) {
        $('#DisburseVoucherID').val(result.Column01);
        $('#DisburseVoucherNo').val(result.Column02);
        $('#DisFromToDate').val(result.Column05);
        $('#CurrencyID').val(result.Column07);
        $('#BankAccountID').val(result.Column06);

        var dataPunishRate = $('#PunishRate').data("kendoNumericTextBox");
        dataPunishRate.value(result.Column11);

        pExchangeRateLength = result.Column14;
        pOperator = result.Column13;
        var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
        dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataExchangeRate.value(result.Column08);

        var dataBeforeOriginalAmount = $('#BeforeOriginalAmount').data("kendoNumericTextBox");
        dataBeforeOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

        if (dataBeforeOriginalAmount && dataBeforeOriginalAmount.value()) {
            CalBeforeConvertedAmount(dataBeforeOriginalAmount, dataExchangeRate);
        }

    }
};

function ExchangeRateDecimalLength(targetLength) {
    var output = '';
    while (output.length < targetLength) {
        output = '0' + output;
    }
    if (targetLength != 0) {
        output = '.' + output;
    }
    return output;
}

function cboAdjustTypeID_Change(e) {
    var value = e.sender ? e.sender.value() : e.value();;
    if (value == 0) {

        $(".PunishRate").css('display', 'none');
        $(".BeforeOriginalAmount").css('display', 'none');
        $(".BeforeConvertedAmount").css('display', 'none');
        $('#PunishRate').removeAttr('data-val-required');
        $('#BeforeOriginalAmount').removeAttr('data-val-required');
        $('#BeforeConvertedAmount').removeAttr('data-val-required');

        $(".AdjustRate").css('display', '');
        $('#AdjustRate').attr('data-val-required', true);
        $('#RateBy').attr('data-val-required', true);
    } else {

        $(".AdjustRate").css('display', 'none');
        $('#AdjustRate').removeAttr('data-val-required');
        $('#RateBy').removeAttr('data-val-required');

        $(".PunishRate").css('display', '');
        $(".BeforeOriginalAmount").css('display', '');
        $(".BeforeConvertedAmount").css('display', '');

        $('#PunishRate').attr('data-val-required', true);
        $('#BeforeOriginalAmount').attr('data-val-required', true);
        $('#BeforeConvertedAmount').attr('data-val-required', true);
    }
}

function cboVoucherTypeID_Change(e) {
    var dataItem = e.sender.dataItem();
    if (dataItem) {
        var VoucherTypeID = dataItem.VoucherTypeID;
        var url = "/LM/LMF1011/GetVoucherNoText";
        var data = {
            VoucherTypeID: VoucherTypeID,
            TableID: "LMT2041"
        };
        ASOFT.helper.postTypeJson(url, data, function (data) {
            if (data.NewKey) {
                $("#VoucherNo").val(data.NewKey);
            } else {
                $("#VoucherNo").val("");
            }
        });
    }
    else {
        $("#VoucherNo").val("");
    }
};

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

var templateCurrentExchangeRate = "<div id=\"CurrentExchangeRate\"></div>"
var templateAdjustRateBy = "<div id=\"AdjustRateBy\"></div>"
var templateDescription = "<div class=\"asf-form-container\"><table class=\"asf-table-view\" id=\"ContentAll\"></table></div>";
var templateFromToDate = "<div id=\"FromToDate\"></div>"

$(document).ready(function () {
    $("#RelatedToTypeID").val(8);
    var templeteButton = new templateAsoftButton(),
     form = $("#sysScreenID"),
     parentSysScreenID = parent.$("#sysScreenID").val();

    //$('.AdjustToDate').css('display', 'none')
    //$($('.AdjustFromDate').children()[1]).append(templateFromToDate)
    //$('div#FromToDate').append($($('#AdjustFromDate').parent().parent()).css('width', '46%'))
    //$('div#FromToDate').append("<span style=\"padding-left:3px ;padding-right:3px\">---</span>")
    //$('div#FromToDate').append($($('#AdjustToDate').parent().parent()).css('width', '47%'))

    $("tr.ExchangeRate").css('display', 'none')
    $($('#CurrencyID').parent()).append(templateCurrentExchangeRate)
    $('div#CurrentExchangeRate').append($('#CurrencyID').css('width', '48%'))
    $('div#CurrentExchangeRate').append("<span style=\"padding-left:3px ;padding-right:3px\"> </span>")
    $('div#CurrentExchangeRate').append($($('#ExchangeRate').parent().parent()).css('width', '48%'))

    $("tr.RateBy").css('display', 'none')
    $('#AdjustRate').parent().parent().parent().append(templateAdjustRateBy)
    $('div#AdjustRateBy').append($('#AdjustRate').parent().parent().css('width', '48%'))
    $('div#AdjustRateBy').append("<span style=\"padding-left:3px ;padding-right:3px\"> </span>")
    $('div#AdjustRateBy').append($($('#RateBy').parent()).css('width', '48%'))

    $('#BankAccountID').attr('readonly', 'readonly')
    $('#CurrencyID').attr('readonly', 'readonly')
    $('#DisburseVoucherNo').attr('readonly', 'readonly')
    $('#CreditVoucherNo').attr('readonly', 'readonly')

    var cboAdjustTypeID = $("#AdjustTypeID").data("kendoComboBox");
    if ($('#isUpdate').val() != "True") {
        cboAdjustTypeID.select(0);        
    }
    cboAdjustTypeID_Change(cboAdjustTypeID);
    cboAdjustTypeID.bind('change', cboAdjustTypeID_Change);

    var cboVoucherTypeID = $('#VoucherTypeID').data('kendoComboBox');
    cboVoucherTypeID.bind('change', cboVoucherTypeID_Change);

    formatForNumericTextBox("BeforeOriginalAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change, ASOFTEnvironment.NumberFormat.ExchangeRateDecimals);

    formatForNumericTextBox("BeforeConvertedAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change, ASOFTEnvironment.NumberFormat.ConvertedDecimals);

    $('div.asf-form-container .container_12').after(templateDescription);
    $('#ContentAll').append($(".Description"));
    $(".Description .asf-td-caption").attr('style', 'width: 15% !important; padding-left: 9px;')
    $(".Description .asf-td-field").attr('style', 'padding-right: 1%')

    var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");

    if ($('#isUpdate').val() != "True") {
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        dpkVoucherDate.value(new Date());

        $("#DisburseVoucherNo").parent().after(btnDisburseVoucherNo);
        $("#CreditVoucherNo").parent().after(btnCreditVoucherNo);

        //if ($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2002') {
        //    pScreenID = $("#ScreenID").val();
        //    pCreditVoucherID = $('#CreditVoucherID').val();
        //    pCreditVoucherNo = $('#CreditVoucherNo').val();
        //} else {
        //    pScreenID = $("#ScreenID").val();
        //    pCreditVoucherID = $('#CreditVoucherID').val();
        //    pCreditVoucherNo = $('#CreditVoucherNo').val();
        //    pDisburseVoucherID = $('#DisburseVoucherID').val();
        //    pDisburseVoucherNo = $('#DisburseVoucherNo').val();
        //    pVoucherDate = $('#VoucherDate').val();
        //    pCurrencyID = $('#CurrencyID').val();
        //    pExchangeRate = $('#ExchangeRate').val();
        //    pBeforeOriginalAmount = $('#BeforeOriginalAmount').val();
        //}
    } else {
        $('#AdjustFromDate').prop('readonly', true);
    }

    $('#ExchangeRate').attr('onchange', 'BeforeOriginalAmount_Change()')
    $('#BeforeOriginalAmount').attr('onchange', 'BeforeOriginalAmount_Change()')
})

function BeforeOriginalAmount_Change() {
    var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
    var dataBeforeOriginalAmount = $('#BeforeOriginalAmount').data("kendoNumericTextBox");
    CalBeforeConvertedAmount(dataBeforeOriginalAmount, dataExchangeRate);
}

function CalBeforeConvertedAmount(BeforeOriginalAmount, ExchangeRate) {
    var totalBeforeConvertedAmount = parseFloat("0");
    if (pOperator == '0') {
        totalBeforeConvertedAmount = BeforeOriginalAmount.value() * ExchangeRate.value();
    } else {
        totalBeforeConvertedAmount = BeforeOriginalAmount.value() / ExchangeRate.value();
    }

    var dataBeforeConvertedAmount = $('#BeforeConvertedAmount').data("kendoNumericTextBox");
    dataBeforeConvertedAmount.value(totalBeforeConvertedAmount);
}

k_NumericTextBox_ConvertAmount_Change = function (e) {
    var sender = e.sender;
    //e.preventDefault();
    (sender.value() == null || sender.value() == "") ? sender.value(0) : sender.value();
}

formatForNumericTextBox = function (id, stringFormat, min, max, objDefault, changeFunction, fdecimals) {
    var kendoNumTxtBx = "kendoNumericTextBox",
        k_NumericTextBox = $("#" + id).data(kendoNumTxtBx);

    if (typeof k_NumericTextBox !== "undefined") {
        stringFormat !== null ? (k_NumericTextBox.setOptions({ format: stringFormat, decimals: fdecimals }), k_NumericTextBox.value(k_NumericTextBox.value())) : false;

        k_NumericTextBox.min(min);

        k_NumericTextBox.max(max);

        if (objDefault !== null && objDefault.isDefault) {
            k_NumericTextBox.value() === null || k_NumericTextBox.value() == "" ? k_NumericTextBox.value(objDefault.Value) : false;
        }

        typeof changeFunction === "function" ? k_NumericTextBox.bind("change", changeFunction) : false;
    }

    return false;
}


function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var check = false;
    //if ($('#isUpdate').val() == "True") {
    //    if (ASOFT.form.checkDateInPeriod('LMF1011', ASOFTEnvironment.BeginDate, ASOFTEnvironment.EndDate, ['VoucherDate'])) {
    //        check = true;
    //    }
    //}

    if (!check) {
        var url = "/LM/LMF2040/CheckDate";
        var data = {
            AdjustFromDate: $("#AdjustFromDate").val(),
            DisburseVoucherID: $("#DisburseVoucherID").val()
        };
        ASOFT.helper.postTypeJson(url, data, function (data) {
            if (data) {
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage("LMFML000011")], null);
                check = true;
            }
        });
    }

    pScreenID = $("#ScreenID").val();
    pCreditVoucherID = $('#CreditVoucherID').val();
    pCreditVoucherNo = $('#CreditVoucherNo').val();
    pDisburseVoucherID = $('#DisburseVoucherID').val();
    pDisburseVoucherNo = $('#DisburseVoucherNo').val();
    pVoucherDate = $('#VoucherDate').val();
    pCurrencyID = $('#CurrencyID').val();
    pExchangeRate = $('#ExchangeRate').val();
    pBeforeOriginalAmount = $('#BeforeOriginalAmount').val();
    pPunishRate = $('#PunishRate').val();
    pBankAccountID = $('#BankAccountID').val();
    pAdjustTypeID = $("#AdjustTypeID").val();
    pAdjustFromDate = $('#AdjustFromDate').val();
    pAdjustRate = $('#AdjustRate').val();
    pRateBy = $('#AdjustRateBy').val();

    return check;
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        if (action == 1) {
            $('#RelatedToTypeID').val(8);
            $('#DivisionID').val($("#EnvironmentDivisionID").val());
        }

        if (action == 2) {
            var VoucherTypeID = $('#VoucherTypeID').val();
            var url = "/LM/LMF1011/GetVoucherNoText";
            var data = {
                VoucherTypeID: VoucherTypeID,
                TableID: "LMT2041"
            };
            ASOFT.helper.postTypeJson(url, data, function (data) {
                if (data.NewKey) {
                    $("#VoucherNo").val(data.NewKey);
                } else {
                    $("#VoucherNo").val("");
                }
            });
        }
        if (action != 3) {
            if (pAdjustTypeID == '1') {
                var urlLink = "/PopupLayout/Index/LM/LMF2031?&ScreenID=LMF2041&VoucherID=" + pCreditVoucherID + "&VoucherNo=" + pCreditVoucherNo + "&VoucherDate=" + pVoucherDate + "&DisburseVoucherID=" + pDisburseVoucherID + "&DisburseVoucherNo=" + pDisburseVoucherNo + "&CurrencyID=" + pCurrencyID + "&ExchangeRate=" + pExchangeRate + "&BeforeOriginalAmount=" + pBeforeOriginalAmount + "&PunishRate=" + pPunishRate + "&BankAccountID=" + pBankAccountID;
                ASOFT.asoftPopup.showIframe(urlLink, {});
            } else {
                calUpdateLMP2042();
            }

            if (action == 1) {
                if (pScreenID == 'LMF2002') {
                    $("#ScreenID").val(pScreenID);
                    $('#CreditVoucherID').val(pCreditVoucherID);
                    $('#CreditVoucherNo').val(pCreditVoucherNo);
                } else if (pScreenID == 'LMF2041') {
                    $("#ScreenID").val(pScreenID);
                    $('#CreditVoucherID').val(pCreditVoucherID);
                    $('#CreditVoucherNo').val(pCreditVoucherNo);
                    $("#DisburseVoucherID").val(pDisburseVoucherID);
                    $('#DisburseVoucherNo').val(pDisburseVoucherNo);
                    $('#VoucherDate').val(pVoucherDate);
                    $("#CurrencyID").val(pCurrencyID);
                    $('#ExchangeRate').val(pExchangeRate);
                    $('#BeforeOriginalAmount').val(pBeforeOriginalAmount);
                }
            }
        }
    }
};

function onAfterSave() {
    if (pAdjustTypeID == '1') {
        var urlLink = "/PopupLayout/Index/LM/LMF2031?&ScreenID=LMF2041&VoucherID=" + pCreditVoucherID + "&VoucherNo=" + pCreditVoucherNo + "&VoucherDate=" + pVoucherDate + "&DisburseVoucherID=" + pDisburseVoucherID + "&DisburseVoucherNo=" + pDisburseVoucherNo + "&CurrencyID=" + pCurrencyID + "&ExchangeRate=" + pExchangeRate + "&BeforeOriginalAmount=" + pBeforeOriginalAmount + "&PunishRate=" + pPunishRate + "&BankAccountID=" + pBankAccountID;
        ASOFT.asoftPopup.showIframe(urlLink, {});
    } else {
        calUpdateLMP2042();
    }
}

function okFunction() {
    window.parent.location.reload();
}

function calUpdateLMP2042() {
    var url1 = "/LM/LMF2040/UpdateLMP2042";
    var data1 = {
        DivisionID: $("#EnvironmentDivisionID").val(),
        DisburseVoucherID: pDisburseVoucherID,
        DateFromDate: pAdjustFromDate,
        AdjustTypeID: pAdjustTypeID,
        BeforeOriginalAmount: pBeforeOriginalAmount,
        AdjustRate: pAdjustTypeID == 1 ? pPunishRate : pAdjustRate,
        RateBy: pRateBy,
        ExchangeRate: pExchangeRate
    };
    ASOFT.helper.postTypeJson(url1, data1, function (result) {
        //alert(result);
    });
}