var LMF2031ActionSaveType=0;
var defaultViewModel = {};
var numchk=1;
var pScreenID = null;
var pCreditVoucherID = null;
var pCreditVoucherNo = null;
var rowNumber = 0;
var currentChoose = null;
var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
var pOperator = 0;
var GridLMP2031 = null;
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
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&CreditVoucherID=", creditVoucherID, "&ScreenID=LMF2031_2&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchDisburseVoucherNo";
}


var btnCreditVoucherNo = '<a id="btSearchFromEmployee" style="z-index:100001; position: absolute; right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchCreditVoucherNo_Click()">...</a>';

function btnSearchCreditVoucherNo_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&ScreenID=LMF2031_1&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchCreditVoucherNo";
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

        pExchangeRateLength = result.Column14;
        pOperator = result.Column13;

        //var dataExchangeRate = $('#ExchangeRate').data("kendoNumericTextBox");
        //dataExchangeRate.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        //dataExchangeRate.value(result.Column08);
        $('#ExchangeRate').val(result.Column08);
        var dataAfterRatePercent = $('#AfterRatePercent').data("kendoNumericTextBox");
        dataAfterRatePercent.setOptions({ format: kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength)), decimals: pExchangeRateLength })
        dataAfterRatePercent.value(result.Column12);

        ASOFTEnvironment.NumberFormat.ExchangeRateDecimals = pExchangeRateLength;
        ASOFTEnvironment.NumberFormat.ExchangeRateDecimalsFormatString = kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength));
        ASOFTEnvironment.NumberFormat.KendoExchangeRateDecimalsFormatString = kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength));

        GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
        rowNumber = 0;
        GridLMP2031.refresh();
    },
    "InheritPaymentPlan": function (result) {var p
        if (result.length > 0) {
            GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
            var pExchangeRate = $('#ExchangeRate').val();

            var arrayDataItem = [];
            for (var i = 0; i < result.length; i++) {
                let pActualConvertedAmount = pOperator == 0 ? parseFloat(result[i].Column06) * parseFloat($('#ExchangeRate').val()) : parseFloat(result[i].Column06) / parseFloat($('#ExchangeRate').val());
                var dataItem = {
                    PaymentPlanTransactionID: result[i].Column01,
                    PaymentDate: kendo.parseDate(result[i].Column02, "dd/MM/yyyy"),
                    PaymentName: result[i].Column03,
                    PaymentType: result[i].Column04,
                    PaymentTypeName: result[i].Column05,
                    ActualOriginalAmount: result[i].Column06,
                    ExchangeRate: pExchangeRate,
                    ActualConvertedAmount: pActualConvertedAmount,
                    PaymentAccountID: result[i].Column08,
                    CostTypeID: result[i].Column09,
                    CostTypeName: result[i].Column10,
                    ActualDate: kendo.parseDate(result[i].Column02, "dd/MM/yyyy"),
                    InheritVoucherID: result[i].Column01,
                    InheritTransactionID: result[i].Column01,
                    InheritTableName:$('#InheritTableName').val(),
                    IsPrePayment:$('#IsPrePayment').val()
                };
                arrayDataItem.push(dataItem);
            }
            GridLMP2031.dataSource.data(arrayDataItem);
            rowNumber = 0;
            GridLMP2031.refresh();
        }
    },
    "InheritTVoucher": function (result) {
        if (result.length > 0) {
            var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");
            dpkVoucherDate.value(result[0].dpkVoucherDate);

            if ($('#Description').val() == null || $('#Description').val() == '') {
                $('#Description').val(result[0].VDescription)
            }

            GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
            var dataSource = GridLMP2031.dataSource._data;
            var arrayDataItem = [];
            for (var i = 0; i < result.length; i++) {
                var dataItem = {
                    PaymentPlanTransactionID:'',
                    ExchangeRate: result[i].ExchangeRate,
                    PaymentDate: null,
                    PaymentName: result[i].TDescription,
                    PaymentType: null,
                    PaymentTypeName: null,
                    ActualDate: kendo.parseDate(result[i].VoucherDate, "dd/MM/yyyy"),
                    ActualOriginalAmount: result[i].OriginalAmount,
                    ActualConvertedAmount: result[i].ConvertedAmount,
                    PaymentAccountID: result[i].CreditAccountID,
                    CostTypeID: result[i].CostTypeID,
                    CostTypeName: result[i].CostTypeName,
                    InheritVoucherID: result[i].VoucherID,
                    InheritTransactionID: result[i].TransactionID,
                    InheritTableName:$('#InheritTableName').val(),
                    IsPrePayment:$('#IsPrePayment').val()
                };
                arrayDataItem.push(dataItem);
            }
            GridLMP2031.dataSource.data(arrayDataItem);
            rowNumber = 0;
            GridLMP2031.refresh();
        }
    },
    "SearchPaymentPlan": function (result) {
        GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
        var selectitem = GridLMP2031.dataItem(GridLMP2031.select());
        selectitem.set("PaymentPlanTransactionID", result.Column01);
        selectitem.set("PaymentDate", kendo.parseDate(result.Column02, "dd/MM/yyyy"));
        selectitem.set("PaymentName", !selectitem.PaymentName?result.Column03:selectitem.PaymentName);
        selectitem.set("PaymentAccountID", !selectitem.PaymentAccountID?result.Column06:selectitem.PaymentAccountID);
        selectitem.set("CostTypeID", !selectitem.CostTypeID?result.Column09:selectitem.CostTypeID);
        selectitem.set("CostTypeName",!selectitem.CostTypeName?(result.Column10 =='null'?'':result.Column10):selectitem.CostTypeName);
    }
};

function receiveResultLMF9000(results) {
    this[ListChoose["InheritTVoucher"](results)];
}

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

function cboVoucherTypeID_Change(e) {
    var dataItem = e.sender.dataItem();
    if (dataItem) {
        var VoucherTypeID = dataItem.VoucherTypeID;
        var url = "/LM/LMF1011/GetVoucherNoText";
        var data = {
            VoucherTypeID: VoucherTypeID,
            TableID: "LMT2031"
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

var btInheritPaymentPlan = '<a id="btInheritPaymentPlan" style=" right: 2px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchInheritPaymentPlan_Click()">...</a>';
var btInheritTVoucher = '<a id="btInheritTVoucher" style="right: 2px; height: 27px ; min-width: 27px; opacity: 0.5;pointer-events: none;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchInheritTVoucher_Click()">...</a>';


function btnSearchInheritPaymentPlan_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var disburseVoucherID = $("#DisburseVoucherID").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&DisburseVoucherID=", disburseVoucherID, "&ScreenID=LMF2031_3&Type=1"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "InheritPaymentPlan";
}

function btnSearchInheritTVoucher_Click() {
    var urlpopup = "/PopupSelectData/Index/LM/LMF9000?FormID=LMF2031&Type=1";
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "InheritTVoucher";
}

function btnSearchPaymentPlan_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var disburseVoucherID = $("#DisburseVoucherID").val();
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", divisionID, "&DisburseVoucherID=", disburseVoucherID, "&ScreenID=LMF2031_3&Type=2"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = "SearchPaymentPlan";
}

var Group02 = "<fieldset id='Group02' style='margin-bottom:10px'><legend>{0}</legend><div id='group01table'><div id='InheritPaymentPlan' style='width: 46%;float: left;'></div><div id='InheritTVoucher' ></div></div></fieldset>";

var templateCurrentExchangeRate = "<div id=\"CurrentExchangeRate\"></div>"
$(document).ready(function () {
    $("#RelatedToTypeID").val(7);
    var templeteButton = new templateAsoftButton(),
   form = $("#sysScreenID"),
   parentSysScreenID = parent.$("#sysScreenID").val();
    
    

    if ($('#isUpdate').val() != "True") {
        $("#Attach")
            .change(function () { setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click); })
            .parent()
            .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") + templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

        
        $('#SaveNew').unbind();
        $("#SaveNew").kendoButton({
            "click": CustomBtnSaveNew_Click,
        });
        $('#SaveCopy').unbind();
        $("#SaveCopy").kendoButton({
            "click": CustomBtnSaveCopy_Click,
        });
        $('#Close').unbind();
        $("#Close").kendoButton({
            "click": CustomBtnClose_Click,
        });

        $("#OptInherit[value='1']").prop('checked', true);
        $('#InheritTableName').val("LMF2022");
        $("#OptInherit[value='2']").attr('onclick', 'OptInherit_Change(this)')
        $("#OptInherit[value='1']").attr('onclick', 'OptInherit_Change(this)')

        if ($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2002') {
            var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");
            dpkVoucherDate.value(new Date());
            pScreenID = $("#ScreenID").val();
            pCreditVoucherID = $('#CreditVoucherID').val();
            pCreditVoucherNo = $('#CreditVoucherNo').val();
        }
        else if ($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2041'){
            pScreenID = $("#ScreenID").val();
            //var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");
            //dpkVoucherDate.value(window.parent.$('#VoucherDate').val());
            $('.AfterRatePercent').css('display','none');
        }else{
            var dpkVoucherDate = $("#VoucherDate").data("kendoDatePicker");
            dpkVoucherDate.value(new Date());
            $("#DisburseVoucherNo").parent().after(btnDisburseVoucherNo);
            $("#CreditVoucherNo").parent().after(btnCreditVoucherNo);
        }
    }
    else{
        $("#DisburseVoucherNo").parent().after(btnDisburseVoucherNo);
        $("#CreditVoucherNo").parent().after(btnCreditVoucherNo);

        $('.DisburseVoucherNo').before($('.CreditVoucherNo'))
        $('#Save').unbind();
        $("#Save").kendoButton({
            "click": CustomBtnSave_Click,
        });

        $('#Close').unbind();
        $("#Close").kendoButton({
            "click": CustomBtnClose_Click,
        });

        if($('#InheritTableName').val() == "LMT2022"){
            $("#OptInherit[value='1']").prop('checked', true);
        }else{
            $("#OptInherit[value='2']").prop('checked', true);
        }
    }

    $('#BankAccountID').attr('readonly', 'readonly')
    $('#CurrencyID').attr('readonly', 'readonly')
    $('#DisburseVoucherNo').attr('readonly', 'readonly')
    $('#CreditVoucherNo').attr('readonly', 'readonly')

    //$("tr.ExchangeRate").css('display', 'none')
    //$($('#CurrencyID').parent()).append(templateCurrentExchangeRate)
    //$('div#CurrentExchangeRate').append($('#CurrencyID').css('width', '48%'))
    //$('div#CurrentExchangeRate').append("<span style=\"padding-left:3px ;padding-right:3px\"> </span>")
    //$('div#CurrentExchangeRate').append($($('#ExchangeRate').parent().parent()).css('width', '48%'))

    $(".container_12").after(kendo.format(Group02,$('#GroupInherit').val()));
    $("#InheritPaymentPlan").prepend($("#OptInherit[value='1']").parent().parent());
    $("#InheritTVoucher").prepend($("#OptInherit[value='2']").parent().parent());

    $("#InheritPaymentPlan tr").append(btInheritPaymentPlan)
    $("#InheritTVoucher tr").append(btInheritTVoucher)
    LoadPartialFilter();
    
    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            defaultViewModel = ASOFT.helper.dataFormToJSON(id);
            GridLMP2031 = $("#GridPartialLMP2031").data("kendoGrid");

            if ($('#isUpdate').val() != "True") {
                if($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2041'){
                    $('#Group02').attr('style','margin-bottom:10px;opacity: 0.5;pointer-events: none;');
                }else{
                    GridLMP2031.dataSource.data([]);
                }
            }else{
                $('#Group02').attr('style','margin-bottom:10px;opacity: 0.5;pointer-events: none;')
            }
            GridLMP2031.unbind("dataBound");
            GridLMP2031.bind("dataBound", function (e) {
                rowNumber = 0;
            });
            $(GridLMP2031.tbody).on("change", "td", function (e) {
                var selectitem = GridLMP2031.dataItem(GridLMP2031.select());

                var column = e.target.id;
                if (column == 'ExchangeRate') {
                    selectitem.ExchangeRate = e.target.value;
                    selectitem.ActualConvertedAmount = pOperator == 0 ?selectitem.ActualOriginalAmount * e.target.value : selectitem.ActualOriginalAmount / e.target.value;
                    GridLMP2031.refresh();
                }
                if (column == 'ActualOriginalAmount') {
                    selectitem.ActualOriginalAmount = e.target.value;
                    selectitem.ActualConvertedAmount = pOperator == 0 ? e.target.value * selectitem.ExchangeRate : e.target.value /selectitem.ExchangeRate;
                    GridLMP2031.refresh();
                }
            });

            $(GridLMP2031.tbody).on("focusin", function (e) {
                if (GridLMP2031.dataSource._data[0].hasOwnProperty("")) {
                    GridLMP2031.closeCell();
                }
            });
            var columns = GridLMP2031.columns;
            var name = 'GridPartialLMP2031';
            $(GridLMP2031.tbody).off("keydown mouseleave", "td").on("keydown mouseleave", "td", function (e) {
                ASOFT.asoftGrid.currentRow = $(this).parent().index();
                ASOFT.asoftGrid.currentCell = $(this).index();

                var editor = columns[ASOFT.asoftGrid.currentCell].editor;
                var isDefaultLR = $(GridLMP2031.element).attr('isDefaultLR');
                if (editor != undefined) {
                    var elm = $(this);
                    if (e.shiftKey) {
                        switch (e.keyCode) {
                            case 13:
                                ASOFT.asoftGrid.previousCell(this, name, false);
                                e.preventDefault();
                                break;
                            case 9:
                                ASOFT.asoftGrid.previousCell(this, name, false);
                                e.preventDefault();
                                break;
                            default:
                                break;
                        }
                    } 
                    else if (e.ctrlKey) {
                        switch (e.keyCode) {
                            case 73:
                                ActualConvertedAmount();
                                break;
                            default:
                                break;
                        }
                    } 
                    else {
                        switch (e.keyCode) {
                            case 13:
                                ASOFT.asoftGrid.nextCell(this, name, false);
                                e.preventDefault();
                                break;
                            case 9:
                                ASOFT.asoftGrid.nextCell(this, name, false);
                                e.preventDefault();
                                break;
                            case 37: //left
                                if (!isDefaultLR) {
                                    ASOFT.asoftGrid.leftCell(this, name);
                                    e.preventDefault();
                                }
                                break;
                            case 39://right
                                if (!isDefaultLR) {
                                    ASOFT.asoftGrid.rightCell(this, name);
                                    e.preventDefault();
                                }
                                break;
                                //TODO : up & down
                                /*case 38:
                                    ASOFT.asoftGrid.upCell(this, name);
                                    e.preventDefault();
                                return false;
                                case 40:
                                    ASOFT.asoftGrid.downCell(this, name);
                                    e.preventDefault();
                                return false;*/
                            default:
                                break;
                        }
                    }
                }// end if

            });
        }
    });
 
    //var dataAfterRatePercent = $('#AfterRatePercent').data("kendoNumericTextBox");
    var cboVoucherTypeID = $('#VoucherTypeID').data('kendoComboBox');
    cboVoucherTypeID.bind('change', cboVoucherTypeID_Change);
})

function ActualConvertedAmount(){
    GridLMP2031 = $("#GridPartialLMP2031").data("kendoGrid");
    var dataSource = GridLMP2031.dataSource._data;
    var dataAfterRatePercent=$("#AfterRatePercent").data("kendoNumericTextBox");
    let dataTotalAfterActualOriginalAmount=parseFloat(0);
    for(var i = 0; i < dataSource.length; i++){
        if(dataSource[i].ActualDate > dataSource[i].PaymentDate){
            dataTotalAfterActualOriginalAmount=dataTotalAfterActualOriginalAmount+ ( dataSource[i].ActualOriginalAmount * dataAfterRatePercent.value() * (Math.floor((dataSource[0].ActualDate-dataSource[0].PaymentDate) / (1000 * 60 * 60 * 24))) / 30) / 100;
        }
    }
    let dataTotalAfterConvertedAmount = pOperator == 0 ? dataTotalAfterActualOriginalAmount * parseFloat($('#ExchangeRate').val()) : dataTotalAfterActualOriginalAmount / parseFloat($('#ExchangeRate').val());
    if(dataTotalAfterActualOriginalAmount > 0){
        var dataItem = {
            PaymentPlanTransactionID: '',
            PaymentDate: '',
            PaymentName: 'Phạt quá hạn',
            IsPrePayment: false,
            ActualDate: kendo.parseDate($('#VoucherDate').val(), "dd/MM/yyyy"),
            PaymentType: 3,
            PaymentTypeName: ASOFTEnvironment.Language == "vi-VN" ?'Phí phạt trễ hạn':'After duedate amount',//chưa lấy dc
            ActualOriginalAmount: dataTotalAfterActualOriginalAmount,
            ExchangeRate: parseFloat($('#ExchangeRate').val()),
            ActualConvertedAmount: dataTotalAfterConvertedAmount,
            PaymentAccountID: '',
            CostTypeID: '',
            CostTypeName: '',
            InheritVoucherID: '',
            InheritTransactionID: '',
            InheritTableName:''
        };
        GridLMP2031.dataSource.add(dataItem);
    }
}

function OptInherit_Change(item) {
   
    if(item.value==1){
        $('#btInheritPaymentPlan').css({'opacity': '','pointer-events': ''})
        $("#btInheritTVoucher").css({'opacity': 0.5,'pointer-events': 'none'})
        $('#InheritTableName').val("LMF2022");
        numchk=1;
    }else{
        $('#btInheritTVoucher').css({'opacity': '','pointer-events': ''})
        $("#btInheritPaymentPlan").css({'opacity': 0.5,'pointer-events': 'none'})
        $('#InheritTableName').val("AT9000")
        numchk=2;
    }

    if(numchk!=item.value){
        GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
        GridLMP2031.dataSource.data([]);
        rowNumber = 0;
        GridLMP2031.refresh();
    }
}

function LoadPartialFilter() {
    var pScreen=($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2041')?'LMF2041':'LMF2031';
    $.ajax({
        url: '/Partial/GridPartialLMP2031?screenID='+pScreen,
        type: "GET",
        async: false,
        success: function (result) {
            $(".asf-form-container fieldset").after(result);
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });

            BtnFilter_Click();
        }
    });
}

function BtnFilter_Click() {
    GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
    if(GridLMP2031){
        GridLMP2031.dataSource.page(1);
    }
    arrVoucherID = [];
}

function renderNumber(data) {
    return ++rowNumber;
}

function sendDataLMP2031() {
    var dataLoad = {
        VoucherID: $('#VoucherID').val(),
        IsViewDetail: 0,
        ScreenID:($("#ScreenID").val() && $("#ScreenID").val() == 'LMF2041')?'LMF2041':'LMF2031',
        VoucherDate: $('#VoucherDate').val(),
        DisburseVoucherID: $('#DisburseVoucherID').val(),
        BeforeOriginalAmount: $('#BeforeOriginalAmount').val(),
        PunishRate: $('#PunishRate').val(),
        ExchangeRate: $('#ExchangeRate').val()
    };
    return dataLoad;
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

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && action == 1) {
        $('#RelatedToTypeID').val(7);
        $('#DivisionID').val($("#EnvironmentDivisionID").val());
    }
};

var isEndRequest = false;
var countCombo = 0;
var comboNames = ['PaymentAccountID', 'CostTypeID', 'PaymentType']

//Combox loaded data
this.comboBox_RequestEnd = function (e) {
    countCombo++;
    if (countCombo == comboNames.length) {
        isEndRequest = true;
    }

    console.log('combo ' + $(this.element).attr('id') + 'end request');
}

function getData(container, options) {
    var a = container;
    var b = options;
}

function cboPaymentType_Change(e) {
    var data = e.sender.dataItem();
    GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
    var index = GridLMP2031.select().index();
    var dataSource = GridLMP2031.dataSource._data;

    dataSource[index].PaymentType = data.OrderNo;
    dataSource[index].PaymentTypeName = data.Description;
}

function cboPaymentAccountID_Change(e) {
    var data = e.sender.dataItem();
    GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
    var index = GridLMP2031.select().index();
    var dataSource = GridLMP2031.dataSource._data;

    dataSource[index].PaymentAccountID = data.AccountID;
}

function cboCostTypeID_Change(e) {
    var data = e.sender.dataItem();
    GridLMP2031 = $("#GridPartialLMP2031").data('kendoGrid');
    var index = GridLMP2031.select().index();
    var dataSource = GridLMP2031.dataSource._data;

    dataSource[index].CostTypeID = data.AnaID;
    dataSource[index].CostTypeName = data.AnaName;
}

function PaymentDate_ClientTemplate(PaymentDate) {
    var date = PaymentDate ? kendo.toString(PaymentDate, 'dd/MM/yyyy') : '';
    if( $("#OptInherit[value='2']").is(":checked")){// && date!=''
        let btnSearchPaymentPlan="<input type='button' value = '...' onclick='btnSearchPaymentPlan_Click(this)' style = 'float: right'>";
        return "<span>" + date + "</span>" + btnSearchPaymentPlan;
    }else{
        return "<span>" + date + "</span>";
    }
}

function CustomBtnSaveNew_Click(){
    LMF2031ActionSaveType = 1;
    SaveData('/LM/LMF2030/Insert');
}
function CustomBtnSaveCopy_Click(){
    LMF2031ActionSaveType = 2;
    SaveData('/LM/LMF2030/Insert')
}
function CustomBtnSave_Click(){
    LMF2031ActionSaveType = 3;
    SaveData('/LM/LMF2030/Update')
}

function SaveData(url){
    ASOFT.form.clearMessageBox();
    if (ASOFT.form.checkRequired('LMF2031')) {
        return;
    }

    if (ASOFT.form.checkDateInPeriod('LMF2031',  ASOFTEnvironment.BeginDate, ASOFTEnvironment.EndDate, ['VoucherDate'])) {
        return;
    }
    //kiểm tra thêm dữ liệu trên lưới địa chỉ mà không nhập dữ liệu
    var grid = $("#GridPartialLMP2031").data('kendoGrid');
    $("#GridPartialLMP2031").removeClass('asf-focus-input-error');
    ASOFT.asoftGrid.editGridRemmoveValidate(grid);

    var listRequired = ['PaymentDate','ExchangeRate','PaymentAccountID','CostTypeID','Notes'];

    if (ASOFT.asoftGrid.editGridValidateNoEdit(grid, listRequired)) {
        var msg = ASOFT.helper.getMessage("00ML000060");
        ASOFT.form.displayError("#LMF2031", msg);
        return
    }

    var dataSource = grid.dataSource._data;
    if(dataSource.length > 0){
        var isCheckA=false;
        var isCheckB=false;
        var msg=[];
        var indexPaymentDate=grid.columns.findIndex(x => x.field=="PaymentDate");
        var indexActualDate=grid.columns.findIndex(x => x.field=="ActualDate");
        for(var i = 0; i < dataSource.length; i++){
            //- Nếu Grid.PaymentType in (0,1) và Grid.PaymentPlanTransactionID = "" thì mới bắt buộc chọn cột Lịch thanh toán
            if((dataSource[i].PaymentType == '0'||dataSource[i].PaymentType == '1')&& (dataSource[i].PaymentPlanTransactionID==null||dataSource[i].PaymentPlanTransactionID=='')){
               
                if(!isCheckA){
                    msg.push(ASOFT.helper.getMessage("00ML000060"));
                }
                isCheckA=true;
                $($($('#GridPartialLMP2031 .k-grid-content tr')[i]).children()[indexPaymentDate]).addClass('asf-focus-input-error');
            }
            //- Nếu Grid.ActualDate < Grid.PaymentDate thì thông báo LMFML000022  và không cho lưu
            if(window.parent.$("#LMF2041").length==0){
                if( new Date(dataSource[i].ActualDate)<new Date(dataSource[i].PaymentDate)){
                
                    if(!isCheckB){
                        msg.push(ASOFT.helper.getMessage("LMFML000022"));
                    }
                    isCheckB=true;
                    $($($('#GridPartialLMP2031 .k-grid-content tr')[i]).children()[indexPaymentDate]).addClass('asf-focus-input-error');
                    $($($('#GridPartialLMP2031 .k-grid-content tr')[i]).children()[indexActualDate]).addClass('asf-focus-input-error');
                }
            }
        }
        if(msg.length>0){
            ASOFT.form.displayError("#LMF2031", msg);
            return;
        }
    }

    var dataIsCheck = [];
    for (var i=0;i<dataSource.length;i++){
        var index=null;
        if (dataIsCheck.some(function (item) {
            return item.PaymentPlanTransactionID === dataSource[i].PaymentPlanTransactionID
        })) {
            var index = dataIsCheck.map((o) => o.PaymentPlanTransactionID).indexOf(dataSource[i].PaymentPlanTransactionID);
            dataIsCheck[index].Quality = parseFloat(dataIsCheck[index].ActualOriginalAmount) + parseFloat(dataSource[i].ActualOriginalAmount);
        } else {
            var datalistCheck = {
                DisburseVoucherID:$('#DisburseVoucherID').val(),
                PaymentPlanTransactionID:dataSource[i].PaymentPlanTransactionID,
                ActualOriginalAmount:parseFloat(dataSource[i].ActualOriginalAmount)
            }
            dataIsCheck.push(datalistCheck);
        }
    }
  
    if(window.parent.$("#LMF2041").length==0){
        var Url = "/LM/LMF2030/CheckActualOriginalAmount";
        var data = dataIsCheck;
        var check=false;
        ASOFT.helper.postTypeJson(Url, data, function (result){
            if( result.isChecked){
                ASOFT.form.displayError("#LMF2031", [ASOFT.helper.getMessage("LMFML000022")]);
                check=result.isChecked;
            }
        });
    }

    if(check){
        return
    }
    if ($("#isUpdate").val() == "True") {
        for (i = 0; i < dataSource.length; i++) {
            if (dataSource[i].dirty)
                dataSource[i].IsUpdate = 1;
        }
    }


    var data = GetFormData();
    ASOFT.helper.postTypeJson(url, data, SaveSuccess);
}

function SaveSuccess(result){
    ASOFT.form.updateSaveStatus('LMF2031', result.Status, result.Data);
    ASOFT.helper.showErrorSeverOption(0, result, 'LMF2031', function () {
        // Chuyển hướng xử lý nghiệp vụ
        switch (LMF2031ActionSaveType) {
            case 1: // Trường hợp lưu & nhập tiếp
                if(pScreenID == 'LMF2041'){
                    window.parent.calUpdateLMP2042();
                    ASOFT.asoftPopup.hideIframe(true);
                }
                else{
                    window.location.reload(true);
                    window.parent.$('#GridLMT2031').data('kendoGrid').dataSource.page(1);
                }
                break;
            case 2: // Trường hợp lưu & sao chép
                if(pScreenID == 'LMF2041'){
                    window.parent.calUpdateLMP2042();
                    ASOFT.asoftPopup.hideIframe(true);
                }
                else{
                    var VoucherTypeID = $('#VoucherTypeID').val();
                    var url = "/LM/LMF1011/GetVoucherNoText";
                    var data = {
                        VoucherTypeID: VoucherTypeID,
                        TableID: "LMT2031"
                    };
                    ASOFT.helper.postTypeJson(url, data, function (data) {
                        if (data.NewKey) {
                            $("#VoucherNo").val(data.NewKey);
                        } else {
                            $("#VoucherNo").val("");
                        }
                    });
                    window.parent.$('#GridLMT2031').data('kendoGrid').dataSource.page(1);
                }
                break;
            case 3: // Trường hợp lưu và đóng
                window.parent.location.reload();
                break;
            default:
                break;
        }
    }, null, null, true);

    if (pScreenID == 'LMF2002' && LMF2031ActionSaveType == 1) {
        $("#ScreenID").val(pScreenID);
        $('#CreditVoucherID').val(pCreditVoucherID);
        $('#CreditVoucherNo').val(pCreditVoucherNo);
    }
}

function GetFormData(){
    var data = {};
    data = ASOFT.helper.dataFormToJSON('LMF2031', 'lstLMP2031', $('#GridPartialLMP2031').data('kendoGrid'));
   

    for(var i = 0; i < data.lstLMP2031.length; i++){
        data.lstLMP2031[i].VoucherTypeID =data.VoucherTypeID;
        data.lstLMP2031[i].VoucherNo  =data.VoucherNo ;
        data.lstLMP2031[i].VoucherDate  = kendo.parseDate(data.VoucherDate, "dd/MM/yyyy");
        data.lstLMP2031[i].Description =data.Description;
        data.lstLMP2031[i].CreditVoucherID  =data.CreditVoucherID;
        data.lstLMP2031[i].DisburseVoucherID =data.DisburseVoucherID;
        data.lstLMP2031[i].BankAccountID =data.BankAccountID;
        data.lstLMP2031[i].CurrencyID =data.CurrencyID;
        data.lstLMP2031[i].AfterRatePercent =data.AfterRatePercent;
        data.lstLMP2031[i].Orders =parseInt(i + 1);
    }
    if ($("#isUpdate").val() == "True") {
        data.lstMaster = getHistoryChange(defaultViewModel, data).join('<br/>')+'<br/>';
    }
   
    return data;
}

function getHistoryChange(defaultDt, data) {
    var returnDataChange = [];
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique" && key != "lstLMP2031") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                var change = null;
                defaultDt[key] = defaultDt[key] != undefined ? defaultDt[key] : "";
                if (value.toString() !== defaultDt[key].toString()) {
                    change = "- '" + id + "." + key + "." + module + "': " + defaultDt[key] + " -> " + value;
                    returnDataChange.push(change);
                }
            }
        }
    })
    return returnDataChange;
}

function CustomBtnClose_Click(){
    ASOFT.asoftPopup.hideIframe(true);
}

/**
 * set height scroll datetime Grid
 * @returns {} 
 */
function OpenFormatHeight(e) {
    $("#" + e.sender.dateView.options.id + "_timeview").css({ "overflow": "scroll", "height": "200px" })
}