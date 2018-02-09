var pScreenID = null;
var pVoucherID = null;
var pDisburseVoucherNo=null
var pOperator = 0;
var currentChoose = null;
var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
var divG01 = "<div id='G01' style='padding-bottom: 10px;'></div>"
var divG02 = "<div id='G02'></div>"
var Group01 = "<fieldset id='Group01'><legend></legend></fieldset>";
var Group02 = "<fieldset id='Group02'><legend></legend><div class='container_12'><div class='asf-filter-main'><div class='grid_6'><table class='asf-table-view' id='group01table'><tbody></tbody></table></div><div class='grid_6 line_left'><table class='asf-table-view' id='group02table'><tbody></tbody></table></div></div></div></fieldset>";

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
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&ScreenID=LMF2024&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchDisburseVoucherNo";
}

var templateDescription = "<div class=\"asf-form-container\" style=\" margin-left: 1%;margin-right: 1%;\"><table class=\"asf-table-view\" id=\"ContentAll\"></table></div>";
var templateCurrentExchangeRate = "<div id=\"CurrentExchangeRate\"></div>"
$(document).ready(function () {
    $("#RelatedToTypeID").val(6);
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();

    $(".container_12").after(Group01);
    $(".container_12").after(divG02);
    $(".container_12").after(divG01);

    $('#Group01').prepend(templateDescription);
    $('#ContentAll').append($(".Description"));
    $(".Description .asf-td-caption").attr('style', 'width: 14% !important')
    $(".Description .asf-td-field").attr('style', 'padding-right: 2%')
    $("#Group01").prepend($(".container_12"));

    $("tr.ExchangeRate").css('display', 'none')
    $($('#CurrencyID').parent()).append(templateCurrentExchangeRate)
    $('div#CurrentExchangeRate').append($('#CurrencyID').css('width', '47%'))
    $('div#CurrentExchangeRate').append("<span style=\"padding-left:3px ;padding-right:3px\"> </span>")
    $('div#CurrentExchangeRate').append($($('#ExchangeRate').parent().parent()).css('width', '48%'))

    $("#Group01").after(Group02);

    if ($('#isUpdate').val() != "True") {
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        $("#group01table").prepend($("tr.Attach"));

        if ($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2022') {
            pScreenID = $("#ScreenID").val();
            pDisburseVoucherNo = $("#DisburseVoucherNo").val();
            var url = "/LM/LMF2023/LoadDataDisburseVoucher";
            var data = {
                DivisionID: $("#EnvironmentDivisionID").val(),
                TxtSearch: $("#DisburseVoucherNo").val()
            };
            ASOFT.helper.postTypeJson(url, data, function (data1) {
                $('#DisburseVoucherID').val(data1[0].Column01);
                $('#DisburseVoucherNo').val(data1[0].Column02);
                $('#CreditVoucherNo').val(data1[0].Column04);
                $('#FromToDate').val(data1[0].Column05);
                $('#CurrencyID').val(data1[0].Column07);
                var pExchangeRateLength = data1[0].Column14;
                var pOperator = data1[0].Column13;

                var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
                dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataExchangeRate.value(data1[0].Column08);

                var dataDisburseOriginalAmount = $('#DisburseOriginalAmount').data("kendoNumericTextBox");
                dataDisburseOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataDisburseOriginalAmount.value(data1[0].Column09);

                var dataDisburseConvertedAmount = $('#DisburseConvertedAmount').data("kendoNumericTextBox");
                dataDisburseConvertedAmount.value(parseFloat(data1[0].Column10));

                var dataPaymentOriginalAmount = $('#PaymentOriginalAmount').data("kendoNumericTextBox");
                dataPaymentOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

                if (dataPaymentOriginalAmount && dataPaymentOriginalAmount.value()) {
                    CalPaymentConvertedAmount(dataPaymentOriginalAmount.value(), dataExchangeRate.value());
                }
            });
        } else {
            $("#DisburseVoucherNo").parent().after(btnDisburseVoucherNo);
        }
    }
   
    $("#group01table").prepend($("tr.PaymentType"));
    $("#group01table").prepend($("tr.PaymentName"));
    $("#group01table").prepend($("tr.PaymentDate"));

    $("#group02table").prepend($("tr.CostTypeID"));
    $("#group02table").prepend($("tr.PaymentAccountID"));
    $("#group02table").prepend($("tr.PaymentConvertedAmount"));
    $("#group02table").prepend($("tr.PaymentOriginalAmount"));

    $('div#G01').append($("#Group01"))
    $('div#G02').append($("#Group02"))

    $('#DisburseVoucherNo').attr('readonly', 'readonly')
    $('#CreditVoucherNo').attr('readonly', 'readonly')
    $('#FromToDate').attr('readonly', 'readonly')
    $('#CurrencyID').attr('readonly', 'readonly')
    $('#ExchangeRate').attr('readonly', 'readonly')
    $('#DisburseOriginalAmount').attr('readonly', 'readonly')
    $('#DisburseConvertedAmount').attr('readonly', 'readonly')


    

    formatForNumericTextBox("DisburseConvertedAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change);

    formatForNumericTextBox("PaymentConvertedAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change);

    $('#PaymentOriginalAmount').attr('onchange', 'PaymentOriginalAmount_Change()')
})

k_NumericTextBox_ConvertAmount_Change = function (e) {
    var sender = e.sender;
    //e.preventDefault();
    (sender.value() == null || sender.value() == "") ? sender.value(0) : sender.value();
}

formatForNumericTextBox = function (id, stringFormat, min, max, objDefault, changeFunction) {
    var kendoNumTxtBx = "kendoNumericTextBox",
        k_NumericTextBox = $("#" + id).data(kendoNumTxtBx);

    if (typeof k_NumericTextBox !== "undefined") {
        stringFormat !== null ? (k_NumericTextBox.setOptions({ format: stringFormat, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals }), k_NumericTextBox.value(k_NumericTextBox.value())) : false;

        k_NumericTextBox.min(min);

        k_NumericTextBox.max(max);

        if (objDefault !== null && objDefault.isDefault) {
            k_NumericTextBox.value() === null || k_NumericTextBox.value() == "" ? k_NumericTextBox.value(objDefault.Value) : false;
        }

        typeof changeFunction === "function" ? k_NumericTextBox.bind("change", changeFunction) : false;
    }

    return false;
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

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
    "SearchDisburseVoucherNo": function (result) {
        $('#DisburseVoucherID').val(result.Column01);
        $('#DisburseVoucherNo').val(result.Column02);
        $('#CreditVoucherNo').val(result.Column04);
        $('#FromToDate').val(result.Column05);
        $('#CurrencyID').val(result.Column07);
        var pExchangeRateLength = result.Column14;
        var pOperator = result.Column13;

        var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
        dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataExchangeRate.value(result.Column08);

        var dataDisburseOriginalAmount = $('#DisburseOriginalAmount').data("kendoNumericTextBox");
        dataDisburseOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataDisburseOriginalAmount.value(result.Column09);

        var dataDisburseConvertedAmount = $('#DisburseConvertedAmount').data("kendoNumericTextBox");
        dataDisburseConvertedAmount.value(parseFloat(result.Column10));

        var dataPaymentOriginalAmount = $('#PaymentOriginalAmount').data("kendoNumericTextBox");
        dataPaymentOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

        if (dataPaymentOriginalAmount && dataPaymentOriginalAmount.value()) {
            CalPaymentConvertedAmount(dataPaymentOriginalAmount.value(), dataExchangeRate.value());
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

function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var check = false;
    if (ASOFT.form.checkDateInPeriod('LMF2024', ASOFTEnvironment.BeginDate, ASOFTEnvironment.EndDate, ['PaymentDate'])) {
        check= true;
    }

    if (!check && $('#PaymentType').val() == 0) {
        var url = "/LM/LMF2023/CheckPaymentOriginalAmount";
        var data = {
            DivisionID: $("#EnvironmentDivisionID").val(),
            DisburseVoucherID: $("#DisburseVoucherID").val(),
            TransactionID: $("#TransactionID").val(),
            PaymentOriginalAmount: $("#PaymentOriginalAmount").val()
        };
        ASOFT.helper.postTypeJson(url, data, function (data) {
            if (data[0].Status==1) {
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage(data[0].Message)], null);
                check = true;
            } 
        });
    }

    return check;
}

function PaymentOriginalAmount_Change() {
    var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
    var dataPaymentOriginalAmount = $('#PaymentOriginalAmount').data("kendoNumericTextBox");
    CalPaymentConvertedAmount(dataPaymentOriginalAmount.value(), dataExchangeRate.value());
}

function CalPaymentConvertedAmount(PaymentOriginalAmount, ExchangeRate) {
    var totalPaymentConvertedAmount = parseFloat("0");
    if (pOperator == '0') {
        totalPaymentConvertedAmount = PaymentOriginalAmount * ExchangeRate;
    } else {
        totalPaymentConvertedAmount = PaymentOriginalAmount / ExchangeRate;
    }

    var dataPaymentConvertedAmount = $('#PaymentConvertedAmount').data("kendoNumericTextBox");
    dataPaymentConvertedAmount.value(totalPaymentConvertedAmount);
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && action == 1) {
        $('#RelatedToTypeID').val(6);
        $('#DivisionID').val($("#EnvironmentDivisionID").val());

        if (pScreenID == 'LMF2002') {
            $("#ScreenID").val(pScreenID);
            var url = "/LM/LMF2023/LoadDataDisburseVoucher";
            var data = {
                DivisionID: $("#EnvironmentDivisionID").val(),
                TxtSearch: pDisburseVoucherNo
            };
            ASOFT.helper.postTypeJson(url, data, function (data1) {
                $('#DisburseVoucherID').val(data1[0].Column01);
                $('#DisburseVoucherNo').val(data1[0].Column02);
                $('#CreditVoucherNo').val(data1[0].Column04);
                $('#FromToDate').val(data1[0].Column05);
                $('#CurrencyID').val(data1[0].Column07);
                var pExchangeRateLength = data1[0].Column14;
                var pOperator = data1[0].Column13;

                var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
                dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataExchangeRate.value(data1[0].Column08);

                var dataDisburseOriginalAmount = $('#DisburseOriginalAmount').data("kendoNumericTextBox");
                dataDisburseOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataDisburseOriginalAmount.value(data1[0].Column09);

                var dataDisburseConvertedAmount = $('#DisburseConvertedAmount').data("kendoNumericTextBox");
                dataDisburseConvertedAmount.value(parseFloat(data1[0].Column10));

                var dataPaymentOriginalAmount = $('#PaymentOriginalAmount').data("kendoNumericTextBox");
                dataPaymentOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })

                if (dataPaymentOriginalAmount && dataPaymentOriginalAmount.value()) {
                    CalPaymentConvertedAmount(dataPaymentOriginalAmount.value(), dataExchangeRate.value());
                }
            });
        }
    }
};