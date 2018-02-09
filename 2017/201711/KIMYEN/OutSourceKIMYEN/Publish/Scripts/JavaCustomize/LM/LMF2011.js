var pScreenID = null;
var pExchangeRateDecimal = "#,0{0}";
var pExchangeRateLength = 0;
var dptFromDate, dptToDate, OriginalLimit = 0;
var pOperator = 0;
var dataScreen = null;
var firstLoad = true;
var templateAttachFile = function (textFileName, templateClass, textFileID) {
    this.getTemplate = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templateClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
};
var currentChoose = null;
var templateFromToDate = "<div id=\"FromToDate\"></div>";
var templateradio = "<div id=\"rdo\" style ='display: inline'></div>";
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
var CreditVoucherID = "";

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
    "1": function (result) {
        CreditVoucherID = result.Column01;
        $('#CreditVoucherID').val(result.Column01);
        $('#CreditVoucherNo').val(result.Column02);
        var dataGuaranteeValue = $('#GuaranteeValue').data("kendoNumericTextBox");
        $("#FromDateGuarantee").data("kendoDatePicker").value(kendo.parseDate(result.Column06));
        $("#ToDateGuarantee").data("kendoDatePicker").value(kendo.parseDate(result.Column07));
        dataGuaranteeValue.value(result.Column11);
        $("#BlockCAmount").data('kendoNumericTextBox').value(result.Column17);
        if ($("input[name='AdvanceTypeID']:checked").val() == 1) {
            // Xu li load du lieu grid
            LoadGridDetail();
        } else {
            $('#ConvertedAmount').data("kendoNumericTextBox").value(dataGuaranteeValue * $("#AdvancePercent").val() / 100);
            // Set value OriginalAmount = ConvertedAmount
            $("#OriginalAmount").data('kendoNumericTextBox').value($("#ConvertedAmount").data('kendoNumericTextBox').value());
        }
        AdvanceDateChange();
    }
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

        $result = $attach.val().split(','),

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

$(document)
    .ready(function () {
        $("#RelatedToTypeID").val(3);
        var templeteButton = new templateAsoftButton(),
            form = $("#sysScreenID"),
            parentSysScreenID = parent.$("#sysScreenID").val();
        if ($('#isUpdate').val() != "True") {
            $("#Attach")
                .change(function () {
                    setButtonDeleteDisableWhenObjectChange($(this), $("#btnDeleteUpload"), btnDeleteUpload_click);
                })
                .parent()
                .append(templeteButton.getAsoftButton("", "btnUpload", "", "...", "btnUpload_click()") +
                    templeteButton.getDeleteAsoftButton("btnDeleteUpload", ""));

            if (window.parent.id == 'LMF2002' || window.parent.id == 'LMF2052') {
                pScreenID = window.parent.id;
                $("#CreditVoucherNo").attr('style', 'width:100% !important;height:22px;');
                $("#btnCreditVoucherNo").css('display', 'none');
                $("#btnDeleteCreditVoucherNo").css('display', 'none');
                var url = "/LM/LMF2010/LoadDataCreditVoucher";
                var data = {
                    DivisionID: $("#EnvironmentDivisionID").val(),
                    TxtSearch: $("#CreditVoucherNo").val(),

                    advanceTypeID: $("input[name='AdvanceTypeID']:checked").val()
                };
                ASOFT.helper.postTypeJson(url,
                    data,
                    function (data1) {
                        dataScreen = data1[0];
                        dataScreen.AdvanceTypeID = $("input[name='AdvanceTypeID']:checked").val();
                        CreditVoucherID = dataScreen.Column01;
                        $('#CreditVoucherID').val(dataScreen.Column01);
                        $('#CreditVoucherNo').val(dataScreen.Column02);
                        var dataGuaranteeValue = $('#GuaranteeValue').data("kendoNumericTextBox");
                        //$('#FromDateGuarantee').val(dataScreen.Column06);
                        //$('#ToDateGuarantee').val(dataScreen.Column07);
                        $("#FromDateGuarantee").data("kendoDatePicker").value(kendo.parseDate(dataScreen.Column06));
                        $("#ToDateGuarantee").data("kendoDatePicker").value(kendo.parseDate(dataScreen.Column07));
                        dataGuaranteeValue.value(dataScreen.Column11);
                        $("#BlockCAmount").data('kendoNumericTextBox').value(dataScreen.Column17);
                        if ($("input[name='AdvanceTypeID']:checked").val() == 1) {
                            // Xu li load du lieu grid
                            setTimeout(
                                LoadGridDetail(),
                                200);
                            $('.advance0').addClass('asf-disabled-li');
                        } else {
                            $('#ConvertedAmount')
                                .data("kendoNumericTextBox")
                                .value(dataGuaranteeValue * $("#AdvancePercent").val() / 100);
                            // Set value OriginalAmount = ConvertedAmount
                            $("#OriginalAmount")
                                .data('kendoNumericTextBox')
                                .value($("#ConvertedAmount").data('kendoNumericTextBox').value());
                        }
                    });
            }
        }
        $('.ToDateGuarantee').css('display', 'none');
        $($('#FromDateGuarantee').parent().parent()).css('width', '46%');
        $($('#ToDateGuarantee').parent().parent()).css('width', '46%');
        $($('.FromDateGuarantee').children()[1]).append(templateFromToDate);
        $('div#FromToDate').append($($('#FromDateGuarantee').parent().parent()));
        $('div#FromToDate').append("<span style=\"padding-left:3px ;padding-right:3px\">---</span>");
        $('div#FromToDate').append($($('#ToDateGuarantee').parent().parent()));

        $($("#AdvanceTypeID[value=0]").parent().parent()).addClass('advance0');
        $($("input[name='AdvanceTypeID'][value=1]").parent().parent()).addClass('advance1');
        $($("input[name='AdvanceTypeID'][value=1]").parent().parent()).css('display', 'none');
        $($("input[name='AdvanceTypeID'][value=1]").parent().parent()).css('width', '46%');
        $($("#AdvanceTypeID[value=0]").parent().parent()).css('width', '46%');
        $($(".advance0")).append(templateradio);
        $('div#rdo').append($(".advance0").children()[1]);
        $('div#rdo').append("<span style=\"padding-left:10px ;padding-right:10px\"></span>");
        $('div#rdo').append($(".advance1").children()[1]);

        var dpkFromDate = $("#FromDateGuarantee").data("kendoDatePicker");
        if (dpkFromDate)
            dpkFromDate.bind('open', dpkDate_Open);
        var dpkToDate = $("#ToDateGuarantee").data("kendoDatePicker");
        if (dpkToDate)
            dpkToDate.bind('open', dpkDate_Open);

        $("#btnCreditVoucherNo").bind('click', btnCreditVoucherID_Click);
        $("#btnDeleteCreditVoucherNo").bind('click', btnDeleteCreditVoucherID_Click);
        $('.FromDateGuarantee').addClass('asf-disabled-li');
        $('.GuaranteeValue').addClass('asf-disabled-li');
        $('.BlockCAmount').addClass('asf-disabled-li');

        $($(".Description").parent().parent()).find('.asf-td-caption').css('width', '14%');
        if ($('#isUpdate').val() == "True") {
            $('.advance0').addClass('asf-disabled-li');
        }
        $($("#GridEditLMT2012").data('kendoGrid').tbody).on('change', 'td', Grid_Change);

        $("input[name='AdvanceTypeID']").bind('change', customControlLanguageOrShowHide);

        // Event change advandate
        $("#AdvanceDate").bind('change', AdvanceDateChange);

        customControlLanguageOrShowHide();
        firstLoad = false;
        $(".OriginalAmount").css('display', 'none');
    });

/**  
* Tính toán tiền lãi
*
* [Kim Vu] Create New [26/01/2018]
**/
function AdvanceDateChange(e) {
    if ($("input[name='AdvanceTypeID']:checked").val() == 1) {
        var grid = $("#GridEditLMT2012").data('kendoGrid');
        var toDate = $("#AdvanceDate").data("kendoDatePicker");
        var days = 0;
        if (toDate) {
            grid.dataSource.data().forEach(function (selectitem) {
                days = 0;
                if (selectitem.BlockDate) {
                    var date = selectitem.BlockDate.split('/');
                    var total = toDate.value() - kendo.parseDate(kendo.format('{0}/{1}/{2}', date[1], date[0], date[2]));
                    days = Math.floor(total / (1000 * 60 * 60 * 24)) + 1;
                }
                selectitem.InterestAmount = (selectitem.InterestRate * selectitem.EndInterestAmount * days) / 100 / 360;
                if (selectitem.InterestAmount < 0) selectitem.InterestAmount = 0;
            });
            grid.refresh();
        }
    }
};

/**  
* Grid change
*
* [Kim Vũ] Create New [03/01/2018]
**/
function Grid_Change(e) {
    var grid = $("#GridEditLMT2012").data('kendoGrid');
    var selectitem = grid.dataItem(grid.select());
    var column = e.target.id;
    if (column == 'cbbBankName') {
        var id = e.target.value;
        var combobox = $("#cbbBankName").data("kendoComboBox");
        if (combobox) {
            var data = combobox.dataItem();
            selectitem.BankID = data.BankID;
            selectitem.BankName = data.BankName;
        }
        grid.refresh();
    } else if ((column == 'InterestRate') &&
        $("input[name='AdvanceTypeID']:checked").val() == 1) {
        var toDate = $("#AdvanceDate").data("kendoDatePicker");
        var days = 0;
        selectitem.InterestRate = e.target.value;
        if (toDate) {
            if (selectitem.BlockDate) {
                var date = selectitem.BlockDate.split('/');
                var total = toDate.value() - kendo.parseDate(kendo.format('{0}/{1}/{2}', date[1], date[0], date[2]));
                days = Math.floor(total / (1000 * 60 * 60 * 24)) + 1;
            }
        }
        selectitem.InterestAmount = (selectitem.InterestRate * selectitem.EndInterestAmount * days) / 100 / 360;
        grid.refresh();
    }
}

function btnCreditVoucherID_Click() {
    currentChoose = "1";
    var urlpopup = ["/PopupSelectData/Index/LM/LMF4444", "?", "DivisionID=", $("#EnvironmentDivisionID").val(), "&ScreenID=LMF2011&Type=2", "&AdvanceTypeID=", $("input[name='AdvanceTypeID']:checked").val()].join("");
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlpopup, {});
}

function btnDeleteCreditVoucherID_Click() {
    $("#CreditVoucherID").val('');
    $('#CreditVoucherID').val('');
    $('#CreditVoucherNo').val('');
    $('#FromDateGuarantee').val('');
    $('#ToDateGuarantee').val('');
    $('#GuaranteeValue').val(0);
    $('#ConvertedAmount').val(0);
    // Set value OriginalAmount = ConvertedAmount
    $("#OriginalAmount").data('kendoNumericTextBox').value($("#ConvertedAmount").data('kendoNumericTextBox').value());
}

function dpkDate_Open(e) {
    var item = e.sender;
    if (item.element.context.id == 'FromDateGuarantee') {
        if ($("#ToDateGuarantee").val()) {
            var dpkToDate = changeDate($("#ToDateGuarantee").val());
            item.max(dpkToDate);
        } else {
            item.max(new Date(8640000000000000));
        }
    } else {
        if ($("#FromDateGuarantee").val()) {
            var dpkFromDate = changeDate($("#FromDateGuarantee").val());
            item.min(dpkFromDate);
        } else {
            item.min(new Date(1));
        }
    }
}

function changeDate(curDate) {
    var arr = curDate.split('/');
    return new Date(arr[2], arr[1] - 1, arr[0]);
}

function onAfterInsertSuccess(result, action) {
    // Set voucherID after insert
    //if (result.Status == 0)
    //$("#VoucherID").val(result.Data.RefKey);
    if (result.Status == 0 && (action == 1 || action == 2)) {
        // Execute update data
        var urlUpdateStatus = "/LM/LMF2010/DoExcuteData";
        ASOFT.helper.postTypeJson(urlUpdateStatus, { creditVoucherID: CreditVoucherID, status: $("input[name='AdvanceTypeID']:checked").val() }, null);

        $('#RelatedToTypeID').val(3);

        if (window.parent.id == 'LMF2052' || window.parent.id == 'LMF2002') {
            $("#ScreenID").val(window.parent.id);
            if ($("input[name='AdvanceTypeID']:checked").val() == 1) {
                if (window.parent.$('#GridLMT2011').data('kendoGrid') != null) {
                    var Grid = window.parent.$('#GridLMT2011').data('kendoGrid');
                    Grid.dataSource.page(1);
                }
                if (action == 1) {
                    CreditVoucherID = dataScreen.Column01;
                    $('#CreditVoucherID').val(dataScreen.Column01);
                    $('#CreditVoucherNo').val(dataScreen.Column02);
                    var dataGuaranteeValue = $('#GuaranteeValue').data("kendoNumericTextBox");
                    $("#FromDateGuarantee").data("kendoDatePicker").value(kendo.parseDate(dataScreen.Column06));
                    $("#ToDateGuarantee").data("kendoDatePicker").value(kendo.parseDate(dataScreen.Column07));
                    dataGuaranteeValue.value(dataScreen.Column11);
                    $("#BlockCAmount").data('kendoNumericTextBox').value(dataScreen.Column17);
                    // Xu li load du lieu grid
                    LoadGridDetail();
                }
            } else {
                ASOFT.helper.postTypeJson("/PartialView2/PartialPTLMF2002", { pk: dataScreen.Column01, DivisionID: $("#EnvironmentDivisionID").val() }, function (result) {
                    if (window.parent.id == 'LMF2052') {
                        window.parent.$('#LMF2052_SubTitle5 div.asf-master-content').html(result);
                    } else {
                        window.parent.$('#LMF2002_SubTitle4-1 div.asf-master-content').html(result);
                    }

                    if (window.parent.$('#IsCheck_PT').val() == 'True') {
                        window.parent.$('a#LockAdvanceAccount').parent().css('display', 'none');
                        window.parent.$('a#RelieveAdvanceAccount').parent().css('display', '');
                        parent.popupClose();
                    }
                });
            }
        }
        $('#DivisionID').val($("#EnvironmentDivisionID").val());
    }
};

/**  
* Load Grid Detail
*
* [Kim Vu] Create New [03/01/2017]
**/
function LoadGridDetail() {
    var url = "/LM/LMF2010/LoadDataGridLMT2012";
    var data = {
        CreditVoucherID: $("#CreditVoucherID").val(),
        VoucherID: $("#VoucherID").val(),
        advanceTypeID: $("input[name='AdvanceTypeID']:checked").val(),
        advanceDate: $("#AdvanceDate").val()
    };
    ASOFT.helper.postTypeJson(url, data, function (data1) {
        $("#GridEditLMT2012").data('kendoGrid').dataSource.data(data1);
    });
}

jQuery("#AdvancePercent").blur(function () {
    if ($("input[name='AdvanceTypeID']:checked").val() == 0) {
        $('#ConvertedAmount').data("kendoNumericTextBox").value($('#GuaranteeValue').val() * $("#AdvancePercent").val() / 100);
        // Set value OriginalAmount = ConvertedAmount
        $("#OriginalAmount").data('kendoNumericTextBox').value($("#ConvertedAmount").data('kendoNumericTextBox').value());
    }
});

/**  
* Customer Check
*
* [Kim Vu] Create new [03/01/2017]
**/
function CustomerCheck() {

    if ($("input[name='AdvanceTypeID']:checked").val() == 0) {
        var totalMaster = $("#ConvertedAmount").data('kendoNumericTextBox').value();

        var totalGrid = 0;
        $("#GridEditLMT2012").data('kendoGrid').dataSource._data.forEach(function (row) {
            totalGrid += row.EscrowAmount ? row.EscrowAmount : 0;
        });
        if (totalMaster < totalGrid) {
            $("#ConvertedAmount").addClass('asf-focus-input-error');
            ASOFT.form.displayError("#LMF2011", ASOFT.helper.getMessage('LMFML000025'));
        }

    }
    return false;
}

/**  
* Custom An hien/ Ngon ngu cho control
*
* [Kim Vu] Create new [04/01/2018]
**/
function customControlLanguageOrShowHide() {

    var gridDT = $("#GridEditLMT2012").data('kendoGrid');
    if ($("input[name='AdvanceTypeID']:checked").val() == 1) {

        gridDT.hideColumn(GetColIndex(gridDT, "EscrowAmount"));
        gridDT.hideColumn(GetColIndex(gridDT, "ToDate"));
        gridDT.hideColumn(GetColIndex(gridDT, "FromDate"));

        gridDT.showColumn(GetColIndex(gridDT, "ClearanceAmount"));
        gridDT.showColumn(GetColIndex(gridDT, "InterestAmount"));

        // Thay doi ngon ngu
        var value = ASOFT.helper.getLanguageString("LMF2011.ConvertedAmount_1", "LMF2011", "LM");
        $($(".ConvertedAmount").children()[0]).find('label').html(value);

        value = ASOFT.helper.getLanguageString("LMF2011.AdvanceDate_1", "LMF2011", "LM");
        $($(".AdvanceDate").children()[0]).find('label').html(value);

        $(".CostTypeID").css('display', '');
        $(".AssignObjectID").css('display', '');
        $(".AdvancePercent").css('display', 'none');
        $(".BlockCAmount").css('display', '');

    } else {
        // Thay doi ngon ngu
        var value = ASOFT.helper.getLanguageString("LMF2011.ConvertedAmount", "LMF2011", "LM");
        $($(".ConvertedAmount").children()[0]).find('label').html(value);

        value = ASOFT.helper.getLanguageString("LMF2011.AdvanceDate", "LMF2011", "LM");
        $($(".AdvanceDate").children()[0]).find('label').html(value);
        $(".BlockCAmount").css('display', 'none');
        $(".AdvancePercent").css('display', '');
        $(".CostTypeID").css('display', 'none');
        $(".AssignObjectID").css('display', 'none');
        gridDT.hideColumn(GetColIndex(gridDT, "ClearanceAmount"));
        gridDT.hideColumn(GetColIndex(gridDT, "InterestAmount"));

        gridDT.showColumn(GetColIndex(gridDT, "EscrowAmount"));
        gridDT.showColumn(GetColIndex(gridDT, "ToDate"));
        gridDT.showColumn(GetColIndex(gridDT, "FromDate"));
    }
    if (!firstLoad) {
        // Set hop dong ve rong
        $("#CreditVoucherNo").val('');
        $("#CreditVoucherID").val('');
        gridDT.dataSource.data([]);
        $("#CostTypeID").data('kendoComboBox').value('');
        $("#AssignObjectID").data('kendoComboBox').value('');
        $("#AdvanceDate").val('');
        $("#ConvertedAmount").data('kendoNumericTextBox').value(0);
        $("#BlockCAmount").data('kendoNumericTextBox').value(0);
        $("#AdvancePercent").data('kendoNumericTextBox').value(0);

    }
    gridDT.hideColumn(GetColIndex(gridDT, "BlockDate"));
    $("#GridEditLMT2012 table").css('width', '100%');
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}