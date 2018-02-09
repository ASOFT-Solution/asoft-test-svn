var divG01 = "<div id='G01' style='padding-bottom: 10px;'></div>"
var divG02 = "<div id='G02'></div>"
var Group01 = "<fieldset id='Group01'><legend></legend></fieldset>";
var Group02 = "<fieldset id='Group02'><legend></legend><div class='container_12'><div class='asf-filter-main'><div class='grid_6'><table class='asf-table-view' id='group01table'><tbody></tbody></table></div><div class='grid_6 line_left'><table class='asf-table-view' id='group02table'><tbody></tbody></table></div></div></div></fieldset>";
var templateRate = "<div id=\"Rate\"></div>"
var templateCurrentExchangeRate = "<div id=\"CurrentExchangeRate\"></div>"
var dataScreen = [];
var pScreenID = null;
var pVoucherID = null;
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

var btnCreditVoucherNo = '<a id="btnCreditVoucherNo" style="z-index:100001; position: absolute; right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchCreditVoucherNo_Click()">...</a>';


function btnSearchCreditVoucherNo_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var voucherDate = $("#VoucherDate").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&VoucherDate=", voucherDate, "&ScreenID=LMF2021&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchCreditVoucherNo";
}

var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
var pOperator = 0;
var currentChoose = null;

var btnPaymentPlan = "<td style='float:left'><a class='k-button k-button-icontext asf-button' id='PaymentPlan' style='' data-role='button' role='button' aria-disabled='false' tabindex='0' onclick='btnPaymentPlan_Click()'><span class='asf-button-text'>Tính lịch trả nợ</span></a></td>";
 
function btnPaymentPlan_Click() {
    var Url = "/LM/LMF2020/PaymentPlan";
    var data = {
        DivisionID: $("#EnvironmentDivisionID").val(),
        VoucherID: $("#VoucherID").val()
    };

    ASOFT.helper.postTypeJson(Url, data, function (result) {
        if (result) {
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000009')], null);
        }
    });
}

$(document).ready(function () {
    $("#RelatedToTypeID").val(5);
    var templeteButton = new templateAsoftButton(),
       form = $("#sysScreenID"),
       parentSysScreenID = parent.$("#sysScreenID").val();

    $(".container_12").after(Group01);
    $(".container_12").after(divG02);
    $(".container_12").after(divG01);
    
    $("#Group01").prepend($(".container_12"));
    $("#Group01").after(Group02);
    $("#group01table").prepend($("tr.AfterRatePercent"));
    $("#group01table").prepend($("tr.BeforeRatePercent"));
    $("#group01table").prepend($("tr.OriginalCostTypeID"));
    $("#group01table").prepend($("tr.OriginalAccountID"));
    $("#group01table").prepend($("tr.OriginalMethod"));
    
    $("#group02table").prepend($("tr.RateBy"));
    $("#group02table").prepend($("tr.RatePercent"));
    $("#group02table").prepend($("tr.RateCostTypeID"));
    $("#group02table").prepend($("tr.RateAccountID"));
    $("#group02table").prepend($("tr.RateMethod"));
    
    $("tr.RateBy").css('display', 'none')
    $($('.RatePercent').children()[1]).append(templateRate)
    $('div#Rate').append($($('#RatePercent').parent().parent()).css('width', '48%'))
    $('div#Rate').append("<span style=\"padding-left:3px ;padding-right:3px\"> </span>")
    $('div#Rate').append($($('#RateBy').parent()).css('width', '48%'))

    $("tr.ExchangeRate").css('display', 'none')
    $($('#CurrencyID').parent()).append(templateCurrentExchangeRate)
    $('div#CurrentExchangeRate').append($('#CurrencyID').css('width', '48%'))
    $('div#CurrentExchangeRate').append("<span style=\"padding-left:3px ;padding-right:3px\"> </span>")
    $('div#CurrentExchangeRate').append($($('#ExchangeRate').parent().parent()).css('width', '48%'))
    

    $('div#G01').append($("#Group01"))
    $('div#G02').append($("#Group02"))


    $("#CreditVoucherNo").parent().after(btnCreditVoucherNo);
    $('.CreditConvertedAmount').before($('.CreditOriginalAmount'))

    $('#ExchangeRate').attr('onchange', 'OriginalAmountOrExchangeRate_Change()')
    $('#OriginalAmount').attr('onchange', 'OriginalAmountOrExchangeRate_Change()')

    $('#NumOfMonths').attr('onchange', 'NumOfMonths_Change()')

    $('#CreditVoucherNo').attr('readonly', 'readonly')
    $('#CreditOriginalAmount').attr('readonly', 'readonly')
    $('#CreditConvertedAmount').attr('readonly', 'readonly')
    $('#AdvanceOAmount').attr('readonly', 'readonly')
    $('#AdvanceCAmount').attr('readonly', 'readonly')
    $('#CurrencyID').attr('readonly', 'readonly')

    

    var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");
    dpkVoucherDate.bind('change', dpkVoucherDate_Change);

    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    dpkFromDate.bind('change', dpkFromDate_Change);

    if ($('#isUpdate').val() != "True") {
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));
        dpkVoucherDate.value(new Date());
        dpkFromDate.value(new Date())
        $("#OriginalMethod").data("kendoComboBox").select(0);
        $("#RateMethod").data("kendoComboBox").select(1);
        $("#RateBy").data("kendoComboBox").select(0);

        $('#VoucherID').val(guid());
        pVoucherID = $('#VoucherID').val();

        if ($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2002') {
            pScreenID = $("#ScreenID").val();
            $("#btnCreditVoucherNo").css('display', 'none')
            var url = "/LM/LMF2020/LoadDataCreditVoucher";
            var data = {
                DivisionID: $("#EnvironmentDivisionID").val(),
                TxtSearch: $("#CreditVoucherNo").val()
            };
            ASOFT.helper.postTypeJson(url, data, function (data1) {
                dataScreen = data1;
                $('#CreditVoucherID').val(data1[0].Column01);
                $('#CreditVoucherNo').val(data1[0].Column02);
                $('#BankID').val(data1[0].Column14);
                $('#BankName').val(data1[0].Column04);
                $('#BankAccountID').data('kendoComboBox').trigger('open');
                $('#BankAccountID').data('kendoComboBox').value(dataScreen.Column05);
                $('#CurrencyID').val(data1[0].Column08);

                var pExchangeRateLength = data1[0].Column13;
                var pOperator = data1[0].Column12;

                var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
                dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataExchangeRate.value(data1[0].Column09);

                var dataCreditOriginalAmount = $('#CreditOriginalAmount').data("kendoNumericTextBox");
                dataCreditOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataCreditOriginalAmount.value(data1[0].Column10);

                var dataCreditConvertedAmount = $('#CreditConvertedAmount').data("kendoNumericTextBox");
                dataCreditConvertedAmount.setOptions({ format: ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals })
                dataCreditConvertedAmount.value(data1[0].Column11);

                var dataAdvanceOAmount = $('#AdvanceOAmount').data("kendoNumericTextBox");
                //dataAdvanceOAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                var dataAdvanceCAmount = $('#AdvanceCAmount').data("kendoNumericTextBox");
                //dataAdvanceCAmount.setOptions({ format: ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals })

                //var url2 = "/LM/LMF2023/GetFormDataLMT2011";
                //var data2 = {
                //    DivisionID: $('#EnvironmentDivisionID').val(),
                //    CreditVoucherID: $('#CreditVoucherID').val()
                //};
                //ASOFT.helper.postTypeJson(url2, data2, function (data3) {
                //    if (data3.length > 0) {
                //        dataAdvanceOAmount.value(data3[0].OriginalAmount);
                //        dataAdvanceCAmount.value(data3[0].ConvertedAmount);
                //    } else {
                //        dataAdvanceOAmount.value(0);
                //        dataAdvanceCAmount.value(0);
                //    }
                //});

                var dataOriginalAmount = $('#OriginalAmount').data("kendoNumericTextBox");
                dataOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataOriginalAmount.value(dataCreditOriginalAmount.value() - dataAdvanceOAmount.value())

                var dataConvertedAmount = $('#ConvertedAmount').data("kendoNumericTextBox");
                dataConvertedAmount.value(pOperator == "0" ? dataOriginalAmount.value() * dataExchangeRate.value() : dataOriginalAmount.value() / dataExchangeRate.value());

            });
        }
    } else {
        pVoucherID = $('#VoucherID').val();
    }

    var cboVoucherTypeID = $('#VoucherTypeID').data('kendoComboBox');
    cboVoucherTypeID.bind('change', cboVoucherTypeID_Change);
    
    formatForNumericTextBox("OriginalAmount", ASOFTEnvironment.NumberFormat.KendoExchangeRateDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change, ASOFTEnvironment.NumberFormat.ExchangeRateDecimals);

    formatForNumericTextBox("ConvertedAmount", ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, null, null, { isDefault: true, Value: 0 }, k_NumericTextBox_ConvertAmount_Change, ASOFTEnvironment.NumberFormat.ConvertedDecimals);

    //$('div.asf-form-button tr').prepend(btnPaymentPlan);
    //$('#PaymentPlan').attr('style',"  pointer-events: none; opacity: 0.4;");    
    $('.AdvanceOAmount').css('display', 'none');
    $('.AdvanceCAmount').css('display', 'none');
})

k_NumericTextBox_ConvertAmount_Change = function (e) {
    var sender = e.sender;
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

function cboVoucherTypeID_Change(e) {
    var dataItem = e.sender.dataItem();
    if (dataItem) {
        var VoucherTypeID = dataItem.VoucherTypeID;
        var url = "/LM/LMF1011/GetVoucherNoText";
        var data = {
            VoucherTypeID: VoucherTypeID,
            TableID: "LMT2021"
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

function dpkVoucherDate_Change(e) {
    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    dpkFromDate.value(e.sender ? e.sender.value() : e.value());
    if ($("#NumOfMonths").val()) {
        NumOfMonths_Change();
    }
}

function dpkFromDate_Change(e) {
    NumOfMonths_Change();
}

function NumOfMonths_Change() {
    var dpkFromDate = $("#FromDate").data("kendoDatePicker");
    var dpkToDate = $("#ToDate").data("kendoDatePicker");

    var result = new Date(dpkFromDate.value()),
      expectedMonth = ((new Date(dpkFromDate.value()).getMonth() + parseInt($('#NumOfMonths').val())) % 12 + 12) % 12;
    result.setMonth(result.getMonth() + parseInt($('#NumOfMonths').val()));
    if (result.getMonth() !== expectedMonth) {
        result.setDate(0);
    }
    dpkToDate.value(result);
   
}

function OriginalAmountOrExchangeRate_Change() {
    var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
    var dataOriginalAmount = $('#OriginalAmount').data("kendoNumericTextBox");
    CalConvertedAmount(dataOriginalAmount, dataExchangeRate)
}

function CalConvertedAmount(dataOriginalAmount, dataExchangeRate) {
    var dataConvertedAmount = $('#ConvertedAmount').data("kendoNumericTextBox");

    var totalConvertedAmount = parseFloat("0");
    if (pOperator == '0') {
        totalConvertedAmount = dataOriginalAmount.value() * dataExchangeRate.value();
    } else {
        totalConvertedAmount = dataOriginalAmount.value() / dataExchangeRate.value();
    }
    dataConvertedAmount.value(totalConvertedAmount);
}



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
        $('#BankID').val(result.Column14);
        $('#BankName').val(result.Column04);
        $('#BankAccountID').data('kendoComboBox').trigger('open');
        $('#BankAccountID').data('kendoComboBox').value(result.Column05);        
        $('#CurrencyID').val(result.Column08);
       
        var pExchangeRateLength = result.Column13;
        var pOperator = result.Column12;

        var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
        dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataExchangeRate.value(result.Column09);

        var dataCreditOriginalAmount = $('#CreditOriginalAmount').data("kendoNumericTextBox");
        dataCreditOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataCreditOriginalAmount.value(result.Column10);

        var dataCreditConvertedAmount = $('#CreditConvertedAmount').data("kendoNumericTextBox");
        dataCreditConvertedAmount.setOptions({ format: ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals })
        dataCreditConvertedAmount.value(result.Column11);

        var dataAdvanceOAmount = $('#AdvanceOAmount').data("kendoNumericTextBox");
        //dataAdvanceOAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        var dataAdvanceCAmount = $('#AdvanceCAmount').data("kendoNumericTextBox");
        //dataAdvanceCAmount.setOptions({ format: ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals })

        //var url = "/LM/LMF2023/GetFormDataLMT2011";
        //var data = {
        //    DivisionID: $('#EnvironmentDivisionID').val(),
        //    CreditVoucherID: $('#CreditVoucherID').val()
        //};
        //ASOFT.helper.postTypeJson(url, data, function (data1) {
        //    if (data1.length > 0) {
        //        dataAdvanceOAmount.value(data1[0].OriginalAmount);
        //        dataAdvanceCAmount.value(data1[0].ConvertedAmount);
        //    } else {
        //        dataAdvanceOAmount.value(0);
        //        dataAdvanceCAmount.value(0);
        //    }
        //});

        var dataOriginalAmount = $('#OriginalAmount').data("kendoNumericTextBox");
        dataOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataOriginalAmount.value(dataCreditOriginalAmount.value() - dataAdvanceOAmount.value())

        var dataConvertedAmount = $('#ConvertedAmount').data("kendoNumericTextBox");
        dataConvertedAmount.value(pOperator == "0" ? dataOriginalAmount.value() * dataExchangeRate.value() : dataOriginalAmount.value() / dataExchangeRate.value());

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

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
};

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && action == 1) {
        $('#RelatedToTypeID').val(5);
        $('#DivisionID').val($("#EnvironmentDivisionID").val());
        //$('#VoucherID').val(guid());
        $('#PaymentPlan').attr('style', "");
    }
    if (result.Status == 0 && action == 2) {
        $('#PaymentPlan').attr('style', "");
        var VoucherTypeID = $('#VoucherTypeID').val();
        var url = "/LM/LMF1011/GetVoucherNoText";
        var data = {
            VoucherTypeID: VoucherTypeID,
            TableID: "LMT2021"
        };
        ASOFT.helper.postTypeJson(url, data, function (data) {
            if (data.NewKey) {
                $("#VoucherNo").val(data.NewKey);
            } else {
                $("#VoucherNo").val("");
            }
        });
    }

    if (result.Status == 0 && action != 3) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('LMFML000029'),
            function () {
                var Url = "/LM/LMF2020/PaymentPlan";
                var data = {
                    DivisionID: $("#EnvironmentDivisionID").val(),
                    VoucherID: pVoucherID
                };

                ASOFT.helper.postTypeJson(Url, data, function (result) {
                    if (!result) {
                        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('LMFML000009')], null);
                    } else {
                        $('#VoucherID').val(guid());
                        pVoucherID = $('#VoucherID').val();
                    }
                });
            },
            function () {
                $('#VoucherID').val(guid());
                pVoucherID = $('#VoucherID').val();
            });

        if (pScreenID == 'LMF2002' && action == 1) {
            $("#ScreenID").val(pScreenID);
            var url = "/LM/LMF2020/LoadDataCreditVoucher";
            var data = {
                DivisionID: $("#EnvironmentDivisionID").val(),
                TxtSearch: $("#CreditVoucherNo").val()
            };
            ASOFT.helper.postTypeJson(url, data, function (data1) {
                dataScreen = data1;
                $('#CreditVoucherID').val(data1[0].Column01);
                $('#CreditVoucherNo').val(data1[0].Column02);
                $('#BankID').val(data1[0].Column14);
                $('#BankName').val(data1[0].Column04);
                $('#BankAccountID').data('kendoComboBox').trigger('open');
                $('#BankAccountID').data('kendoComboBox').value(dataScreen.Column05);
                $('#CurrencyID').val(data1[0].Column08);

                var pExchangeRateLength = data1[0].Column13;
                var pOperator = data1[0].Column12;

                var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
                dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataExchangeRate.value(data1[0].Column09);

                var dataCreditOriginalAmount = $('#CreditOriginalAmount').data("kendoNumericTextBox");
                dataCreditOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataCreditOriginalAmount.value(data1[0].Column10);

                var dataCreditConvertedAmount = $('#CreditConvertedAmount').data("kendoNumericTextBox");
                dataCreditConvertedAmount.setOptions({ format: ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals })
                dataCreditConvertedAmount.value(data1[0].Column11);

                var dataAdvanceOAmount = $('#AdvanceOAmount').data("kendoNumericTextBox");
                //dataAdvanceOAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                var dataAdvanceCAmount = $('#AdvanceCAmount').data("kendoNumericTextBox");
                //dataAdvanceCAmount.setOptions({ format: ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString, decimals: ASOFTEnvironment.NumberFormat.ConvertedDecimals })

                //var url2 = "/LM/LMF2023/GetFormDataLMT2011";
                //var data2 = {
                //    DivisionID: $('#EnvironmentDivisionID').val(),
                //    CreditVoucherID: $('#CreditVoucherID').val()
                //};
                //ASOFT.helper.postTypeJson(url2, data2, function (data3) {
                //    if (data3.length > 0) {
                //        dataAdvanceOAmount.value(data3[0].OriginalAmount);
                //        dataAdvanceCAmount.value(data3[0].ConvertedAmount);
                //    } else {
                //        dataAdvanceOAmount.value(0);
                //        dataAdvanceCAmount.value(0);
                //    }
                //});

                var dataOriginalAmount = $('#OriginalAmount').data("kendoNumericTextBox");
                dataOriginalAmount.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
                dataOriginalAmount.value(dataCreditOriginalAmount.value() - dataAdvanceOAmount.value())

                var dataConvertedAmount = $('#ConvertedAmount').data("kendoNumericTextBox");
                dataConvertedAmount.value(pOperator == "0" ? dataOriginalAmount.value() * dataExchangeRate.value() : dataOriginalAmount.value() / dataExchangeRate.value());

            });
        }
    }
   
};

function onAfterSave() {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('LMFML000029'),
            function () {
                var Url = "/LM/LMF2020/PaymentPlan";
                var data = {
                    DivisionID: $("#EnvironmentDivisionID").val(),
                    VoucherID: pVoucherID
                };

                ASOFT.helper.postTypeJson(Url, data, function (result) {
                    if (result) {
                         ASOFT.dialog.showMessage('LMFML000009');
                    } else {
                        window.parent.location.reload();
                    }
                });
            },
            function () {
                window.parent.location.reload();
            });
}
function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
      s4() + '-' + s4() + s4() + s4();
}

function okFunction() {
    window.parent.location.reload();
}