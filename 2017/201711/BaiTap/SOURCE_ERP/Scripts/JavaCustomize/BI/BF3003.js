var id = $("#sysScreenID").val();
var FromInventType;
var ToInventType;
var FromInvent;
var ToInvent;
var WareHouse;

var FromInventTypeName;
var ToInventTypeName;
var FromInventName;
var ToInventName;
var WareHouseName;
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
    $("#OORfilter").append($("#FromToInventoryID"));
    $("#OORfilter").append(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
   
    
    $("#TableOO1").append($(".WareHouseID"));
    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $("#ToPeriodFilter").data("kendoComboBox").select(0);
    var combo = $("#FromPeriodFilter").data("kendoComboBox");
    combo.select(combo.dataSource._data.length - 1);

    var cboFromInventoryTypeID = $("#FromInventoryTypeID").data("kendoComboBox");
    cboFromInventoryTypeID.select(0);
    FromInventType = cboFromInventoryTypeID.value();
    cboFromInventoryTypeID.input[0].value = cboFromInventoryTypeID.text().split(' [^-^] ')[0];
    FromInventTypeName = cboFromInventoryTypeID.input[0].value;
    cboFromInventoryTypeID.bind('change', combobox_change);
    cboFromInventoryTypeID.bind('open', combobox_openclose);
    cboFromInventoryTypeID.bind('close', combobox_openclose);

    var cboToInventoryTypeID = $("#ToInventoryTypeID").data("kendoComboBox");
    cboToInventoryTypeID.select(cboToInventoryTypeID.dataSource._data.length - 1);
    ToInventType = cboToInventoryTypeID.value();
    cboToInventoryTypeID.input[0].value = cboToInventoryTypeID.text().split(' [^-^] ')[0];
    ToInventTypeName = cboToInventoryTypeID.input[0].value;
    cboToInventoryTypeID.bind('change', combobox_change);
    cboToInventoryTypeID.bind('open', combobox_openclose);
    cboToInventoryTypeID.bind('close', combobox_openclose);

    var cboWareHouseID = $("#WareHouseID").data("kendoComboBox");
    cboWareHouseID.select(0);
    WareHouse = cboWareHouseID.value();
    cboWareHouseID.input[0].value = cboWareHouseID.text().split(' [^-^] ')[0];
    WareHouseName = cboWareHouseID.input[0].value;
    cboWareHouseID.bind('change', cboWareHouseID_change);
    cboWareHouseID.bind('open', combobox_openclose);
    cboWareHouseID.bind('close', combobox_openclose);

    var cboFromInventoryID = $("#FromInventoryID").data("kendoComboBox");
    OpenComboDynamic(cboFromInventoryID)
    cboFromInventoryID.bind('change', cboFromInventoryID_change)
    cboFromInventoryID.bind('open', combobox_openclose);
    cboFromInventoryID.bind('close', combobox_openclose);
    FromInvent = cboFromInventoryID.value();
    if (cboFromInventoryID.text().split(' [^-^] ').length > 1) {                
        cboFromInventoryID.input[0].value = cboFromInventoryID.text().split(' [^-^] ')[0];
        FromInventoryName = cboFromInventoryID.input[0].value;
    }

    var cboToInventoryID = $("#ToInventoryID").data("kendoComboBox");
    OpenComboDynamic(cboToInventoryID)
    cboToInventoryID.select(cboToInventoryID.dataSource._data.length - 1);
    ToInvent = cboToInventoryID.value();
    cboToInventoryID.bind('change', cboToInventoryID_change)
    cboToInventoryID.bind('open', combobox_openclose);
    cboToInventoryID.bind('close', combobox_openclose);
    if (cboToInventoryID.text().split(' [^-^] ').length > 1) {
        cboToInventoryID.input[0].value = cboToInventoryID.text().split(' [^-^] ')[0];
        ToInventoryName = cboToInventoryID.input[0].value;
    }


    $("#btnPrint").unbind();
    $("#btnPrint").kendoButton({
        "click": print_Click
    });

    $("#btnExport").unbind();
    $("#btnExport").kendoButton({
        "click": export_Click
    });

    $("#btnPrintBD").unbind();
    $("#btnPrintBD").kendoButton({
        "click": printBD_Click
    });
    
})

function print_Click() {
    isPrint = true;

    if ($('#ReportIDHide').val() == 'BFR3003' && $('#Mode')) {
        $('#Mode').val(1);
    }

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

    if ($('#ReportIDHide').val() == 'BFR3003' && $('#Mode')) {
        $('#Mode').val(1);
    }

    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);
    var data = getData();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, data, ExportSuccess);
}

function printBD_Click() {
    isPrint = true;

    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);

    if ($('#ReportIDHide').val() == 'BFR3003' && $('#Mode')) {
        $('#Mode').val(0);
    }

    var data = getData();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, data, ExportSuccess);
}

function OpenComboDynamic(combo) {
    if (combo.sender != null) {
        SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData");
    } else {
        SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData");
    }
}

function SendFromCombo(combo, url) {
    var datamaster = ASOFT.helper.dataFormToJSON(id);
    var list = new Array();
    list.push(AddList("sysComboBoxID", combo.element.attr("syscomboboxid")));
    list.push(AddList("ScreenID", "BF3003"));
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
    } else {
        combo.select(0);        
    }
};

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function cboFromInventoryID_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (cbo.dataSource._data.length > 0) {
            if (cbo.text() == cbo.value()) {
                cbo.value(FromInvent);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = FromInventName;
                }
                return;
            }
            else {
                FromInvent = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    FromInventName = cbo.input[0].value;
                }
            }
        } else {
            cbo.value("");
        }
    }
}

function cboToInventoryID_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (cbo.dataSource._data.length > 0) {
            if (cbo.text() == cbo.value()) {
                cbo.value(ToInvent);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = ToInventName;
                }
                return;
            }
            else {
                ToInvent = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    ToInventName = cbo.input[0].value;
                }
            }
        } else {
            cbo.value("");
        }
    }
}

function combobox_openclose(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (cbo.text().split(' [^-^] ').length > 1) {
            cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
        }

    }
}

function cboWareHouseID_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
        if (cbo.dataSource._data.length > 0) {
            if (cbo.text() == cbo.value()) {
                cbo.value(WareHouse);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = WareHouseName;
                }
                return;
            }
            else {
                WareHouse = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    WareHouseName = cbo.input[0].value;
                }
            }
        } else {
            cbo.value("");
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
                cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
            } else {
                if (e.sender.element.context.name == "FromInventoryTypeID") {
                    cbo.input[0].value =FromInventTypeName;
                } else {
                    cbo.input[0].value = ToInventTypeName;
                }                
            }
            return;
        }
        else {
            if (e.sender.element.context.name == "FromInventoryTypeID") {
                FromInventType=cbo.value();
            } else {
                ToInventType=cbo.value();
            }

            if (cbo.text().split(' [^-^] ').length > 1) {
                cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                if (e.sender.element.context.name == "FromInventoryTypeID") {
                    FromInventTypeName = cbo.input[0].value;
                } else {
                    ToInventTypeName = cbo.input[0].value;
                }
            }
        }

        if (e.sender.element.context.name == "FromInventoryTypeID") {
            var cbo1 = $("#ToInventoryTypeID").data("kendoComboBox");
            if (cbo.selectedIndex > cbo1.selectedIndex) {
                var cboFromInventoryID = $("#FromInventoryID").data("kendoComboBox");
                var cboToInventoryID = $("#ToInventoryID").data("kendoComboBox");
                cboFromInventoryID.setDataSource([]);
                cboFromInventoryID.value("");
                cboFromInventoryID.refresh();

                cboToInventoryID.setDataSource([]);
                cboToInventoryID.value("");

                return;
            }
        } else {
            var cbo1 = $("#FromInventoryTypeID").data("kendoComboBox");
            if (cbo.selectedIndex < cbo1.selectedIndex) {
                var cboFromInventoryID = $("#FromInventoryID").data("kendoComboBox");
                var cboToInventoryID = $("#ToInventoryID").data("kendoComboBox");
                cboFromInventoryID.setDataSource([]);
                cboFromInventoryID.value("");
                cboFromInventoryID.refresh();

                cboToInventoryID.setDataSource([]);
                cboToInventoryID.value("");
                cboToInventoryID.refresh();
                return;
            }
        }
    }
 
    var cboFromInventoryID = $("#FromInventoryID").data("kendoComboBox");
    OpenComboDynamic(cboFromInventoryID)

    if (cboFromInventoryID.text().split(' [^-^] ').length > 1) {
        cboFromInventoryID.input[0].value = cboFromInventoryID.text().split(' [^-^] ')[0];
        FromInventoryName = cboFromInventoryID.input[0].value;
    }

    var cboToInventoryID = $("#ToInventoryID").data("kendoComboBox");
    OpenComboDynamic(cboToInventoryID)
    cboToInventoryID.select(cboToInventoryID.dataSource._data.length - 1);
    if (cboToInventoryID.text().split(' [^-^] ').length > 1) {
        cboToInventoryID.input[0].value = cboToInventoryID.text().split(' [^-^] ')[0];
        ToInventoryName = cboToInventoryID.input[0].value;
    }
}

function CustomerCheck(data) {
    var Check = false;
    ASOFT.form.clearMessageBox($('#sysScreenID').val())
    if ($('#FromPeriodFilter').val() == '' && $('#ToPeriodFilter').val() == '') {
        ASOFT.form.displayMessageBox('#FormReportFilter', [ASOFT.helper.getMessage('BIFML000001')], null);
        Check = true;
    }
    return Check;
}


