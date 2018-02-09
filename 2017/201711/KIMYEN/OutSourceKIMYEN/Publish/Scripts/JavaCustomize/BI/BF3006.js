var id = $("#sysScreenID").val();
var FromInventType;
var ToInventType;
var Ana02ID;
var Ana03ID;

var FromInventTypeName;
var ToInventTypeName;
var Ana02Name;
var Ana03Name;
var indextypeID = "";
var indextypeName = "";
$(document).ready(function () {
    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").append($("#FromToDate"));
    $("#OORfilter").append($("#FromToInventoryTypeID"));
    $("#OORfilter").append($("#InventoryID"));
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
   
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $("#ToPeriodFilter").data("kendoComboBox").select(0);
    var combo = $("#FromPeriodFilter").data("kendoComboBox");
    combo.select(combo.dataSource._data.length - 1);

    var cboFromInventoryTypeID = $("#FromInventoryTypeID").data("kendoComboBox");
    cboFromInventoryTypeID.select(0);
    FromInventType = cboFromInventoryTypeID.value();
    cboFromInventoryTypeID.input[0].value = cboFromInventoryTypeID.text().split(' [^-^] ')[1];
    FromInventTypeName = cboFromInventoryTypeID.input[0].value;
    cboFromInventoryTypeID.bind('change', combobox_change);
    cboFromInventoryTypeID.bind('open', combobox_openclose);
    cboFromInventoryTypeID.bind('close', combobox_openclose);

    var cboToInventoryTypeID = $("#ToInventoryTypeID").data("kendoComboBox");
    cboToInventoryTypeID.select(cboToInventoryTypeID.dataSource._data.length - 1);
    ToInventType = cboToInventoryTypeID.value();
    cboToInventoryTypeID.input[0].value = cboToInventoryTypeID.text().split(' [^-^] ')[1];
    ToInventTypeName = cboToInventoryTypeID.input[0].value;
    cboToInventoryTypeID.bind('change', combobox_change);
    cboToInventoryTypeID.bind('open', combobox_openclose);
    cboToInventoryTypeID.bind('close', combobox_openclose);

    

    var cboAna02ID = $("#Ana02ID").data("kendoComboBox");
    OpenComboDynamic(cboAna02ID)
    cboAna02ID.bind('change', cbo_change);
    cboAna02ID.bind('open', combobox_openclose);
    cboAna02ID.bind('close', combobox_openclose);

    var cboAna03ID = $("#Ana03ID").data("kendoComboBox");
    OpenComboDynamic(cboAna03ID)
    cboAna03ID.bind('change', cbo_change);
    cboAna03ID.bind('open', combobox_openclose);
    cboAna03ID.bind('close', combobox_openclose);

    //$("#btnExport").css('display', 'none');
    $("#btnPrintBD").css('display', 'none');

    $("#btnPrint").unbind();
    $("#btnPrint").kendoButton({
        "click": print_Click
    });

    $("#btnExport").unbind();
    $("#btnExport").kendoButton({
        "click": export_Click
    });

    $("#rdbAll").bind('change', radio_change_all);
    $("#rdbASM").bind('change', radio_change_asm);
    $("#rdbSUP").bind('change', radio_change_sup);
    $("#rdbAll").prop('checked', 'checked');
    $("#Ana02ID").data("kendoComboBox").enable(false);
    $("#Ana03ID").data("kendoComboBox").enable(false);
    $("#Ana02ID").data("kendoComboBox").bind('change', cbo_change);
    $("#Ana03ID").data("kendoComboBox").bind('change', cbo_change);
})

function print_Click() {
    isPrint = true;

    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);

    var data = getData();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, data, ExportSuccess);
}

function export_Click() {
    isPrint = false;

    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);
    var data = getData();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, data, ExportSuccess);
}

function OpenComboDynamic(combo) {
    //if (combo.sender != null) {
    //    SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData");
    //} else {
    //    SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData");
    //}
}

function SendFromCombo(combo, url) {
    var datamaster = ASOFT.helper.dataFormToJSON(id);
    var list = new Array();
    list.push(AddList("sysComboBoxID", combo.element.attr("syscomboboxid")));
    list.push(AddList("ScreenID", "BF3006"));
    list.push(AddList("Module", "BI"));
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            var item = new Object();
            list.push(AddList(key, value));
        }
    });

    ASOFT.helper.postTypeJsonComboBox(url, list, combo, onComboSuccess);
}

function onComboSuccess(result, combo) {
    combo.dataSource.data(result);

    if (result.length == 0) {
        combo.value("");
    }
    else {
        combo.select(0);
        if (combo.text().split(' [^-^] ').length > 1) {
            combo.input[0].value = combo.text().split(' [^-^] ')[1];
        }
    }
};

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function cbo_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (!cbo.text()) {
            cbo.value("");
            return;
        }
        if (cbo.dataSource._data.length > 0) {
            if (e.sender.element.context.name == "Ana02ID") {
                if (cbo.text() == cbo.value()) {
                    cbo.value(Ana02ID);
                    if (cbo.text().split(' [^-^] ').length > 1) {
                        cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
                    } else {
                        cbo.input[0].value = Ana02Name;
                    }
                    return;
                }
                else {
                    Ana02ID = cbo.value();
                    if (cbo.text().split(' [^-^] ').length > 1) {
                        cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
                        Ana02Name = cbo.input[0].value;
                    }
                }
            }
            else if (e.sender.element.context.name == "Ana03ID") {
                if (cbo.text() == cbo.value()) {
                    cbo.value(Ana03ID);
                    if (cbo.text().split(' [^-^] ').length > 1) {
                        cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
                    } else {
                        cbo.input[0].value = Ana03Name;
                    }
                    return;
                }
                else {
                    Ana03ID = cbo.value();
                    if (cbo.text().split(' [^-^] ').length > 1) {
                        cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
                        Ana03Name = cbo.input[0].value;
                    }
                }
            }
        }
        $("#AnaID").val(cbo.value());
    }
}

function combobox_openclose(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (cbo.text().split(' [^-^] ').length > 1) {
            cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
        }

    }
}

function combobox_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (cbo.text() == cbo.value()) {
            if (e.sender.element.context.name == "FromInventoryTypeID") {
                cbo.value(FromInventType);
            } else {
                cbo.value(ToInventType);
            }
            if (cbo.text().split(' [^-^] ').length > 1) {
                cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
            } else {
                if (e.sender.element.context.name == "FromInventoryTypeID") {
                    cbo.input[0].value = FromInventTypeName;
                } else {
                    cbo.input[0].value = ToInventTypeName;
                }
            }
            return;
        }
        else {
            if (e.sender.element.context.name == "FromInventoryTypeID") {
                FromInventType = cbo.value();
            } else {
                ToInventType = cbo.value();
            }

            if (cbo.text().split(' [^-^] ').length > 1) {
                cbo.input[0].value = cbo.text().split(' [^-^] ')[1];
                if (e.sender.element.context.name == "FromInventoryTypeID") {
                    FromInventTypeName = cbo.input[0].value;
                } else {
                    ToInventTypeName = cbo.input[0].value;
                }
            }
        }
      
    }
}

function CustomerCheck() {
    var Check = false;
    ASOFT.form.clearMessageBox($('#sysScreenID').val())
    if ($('#FromPeriodFilter').val() == '' && $('#ToPeriodFilter').val() == '') {
        ASOFT.form.displayMessageBox('#FormReportFilter', [ASOFT.helper.getMessage('BIFML000001')], null);
        Check = true;
    }
    return Check;
}


function btnDeleteFromInventoryID_Click(type) {
    $("#FromInventoryID0" + type).val('');
    $("#FromInventoryName0" + type).val('');
}

function btnDeleteToInventoryID_Click(type) {
    $("#ToInventoryID0" + type).val('');
    $("#ToInventoryName0" + type).val('');
}

function btnFromInventoryID_Click(type) {
    indextypeID = "FromInventoryID0" + type;
    indextypeName = "FromInventoryName0" + type;
    var urlChoose = "/PopupSelectData/Index/SO/SOF2014?FromInventoryTypeID=" + $("#FromInventoryTypeID").val() + "&ToInventoryTypeID=" + $("#ToInventoryTypeID").val() + "&isReport=1";
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnToInventoryID_Click(type) {
    indextypeID = "ToInventoryID0" + type;
    indextypeName = "ToInventoryName0" + type;
    var urlChoose = "/PopupSelectData/Index/SO/SOF2014?FromInventoryTypeID=" + $("#FromInventoryTypeID").val() + "&ToInventoryTypeID=" + $("#ToInventoryTypeID").val() + "&isReport=1";
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    $("#" + indextypeID).val(result.InventoryID);
    $("#" + indextypeName).val(result.InventoryName);
}

function radio_change_all(e) {
    var all = $("#rdbAll");
    var sub = $("#rdbSUP");
    var asm = $("#rdbASM");
    if (all.prop('checked')) {
        $("#Type").val('0');
        sub.attr('checked', false);
        asm.attr('checked', false);
        $("#AnaID").val('');
    }
    $("#Ana02ID").data("kendoComboBox").enable(sub.prop('checked'));
    $("#Ana03ID").data("kendoComboBox").enable(asm.prop('checked'));
}

function radio_change_sup(e) {
    var all = $("#rdbAll");
    var sub = $("#rdbSUP");
    var asm = $("#rdbASM");
    if (sub.prop('checked')) {
        $("#Type").val('1');
        asm.attr('checked', false);
        all.attr('checked', false);
        $("#AnaID").val($("#Ana02ID").data("kendoComboBox").value());
    }
    $("#Ana02ID").data("kendoComboBox").enable(sub.prop('checked'));
    $("#Ana03ID").data("kendoComboBox").enable(asm.prop('checked'));
}

function radio_change_asm(e) {
    var all = $("#rdbAll");
    var sub = $("#rdbSUP");
    var asm = $("#rdbASM");
    if (asm.prop('checked')) {
        $("#Type").val('2');
        sub.attr('checked', false);
        all.attr('checked', false);
        $("#AnaID").val($("#Ana03ID").data("kendoComboBox").value());
    }
    $("#Ana02ID").data("kendoComboBox").enable(sub.prop('checked'));
    $("#Ana03ID").data("kendoComboBox").enable(asm.prop('checked'));
}