var id = $("#sysScreenID").val();
var FromInventType;
var ToInventType;
var FromInvent;
var ToInvent;
var Currency;
var Emp01;
var Emp02;
var Emp03;
var Emp04;
var Emp05;

var FromInventTypeName;
var ToInventTypeName;
var FromInventName;
var ToInventName;
var CurrencyName;
var Emp01Name;
var Emp02Name;
var Emp03Name;
var Emp04Name;
var Emp05Name;

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
    $("#OORfilter").append($("#EmployeeID"));   
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
   
    $("#TableOO1").append($(".CurrencyID_BI"));
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

    var cboCurrencyID = $("#CurrencyID_BI").data("kendoComboBox");
    for (var i = 0; i < cboCurrencyID.dataSource._data.length; i++) {
        if (cboCurrencyID.dataSource._data[i].CurrencyID == 'VND') {
            cboCurrencyID.select(i)
            Currency = cboCurrencyID.value();
            cboCurrencyID.input[0].value = cboCurrencyID.text().split(' [^-^] ')[0];
            CurrencyName = cboCurrencyID.input[0].value;
        }
    }
    cboCurrencyID.bind('change', cbo_change);
    cboCurrencyID.bind('open', combobox_openclose);
    cboCurrencyID.bind('close', combobox_openclose);

    var cboFromInventoryID = $("#FromInventoryID").data("kendoComboBox");
    OpenComboDynamic(cboFromInventoryID)
    cboFromInventoryID.bind('change', cboFromInventoryID_change)
    cboFromInventoryID.bind('open', combobox_openclose);
    cboFromInventoryID.bind('close', combobox_openclose);
    FromInvent = cboFromInventoryID.value();
    if (cboFromInventoryID.text().split(' [^-^] ').length > 1) {
        cboFromInventoryID.input[0].value = cboFromInventoryID.text().split(' [^-^] ')[0];
        FromInventName = cboFromInventoryID.input[0].value;
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
        ToInventName = cboToInventoryID.input[0].value;
    }

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

    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            var cboEmployeeID01 = $("#EmployeeID01").data("kendoComboBox");
            cboEmployeeID01.select();
            Emp01 = cboEmployeeID01.value();            
            cboEmployeeID01.input[0].value = cboEmployeeID01.text().split(' [^-^] ')[0];
            Emp01Name = cboEmployeeID01.input[0].value;
            cboEmployeeID01.bind('change', cbo_change);
            cboEmployeeID01.bind('open', combobox_openclose);
            cboEmployeeID01.bind('close', combobox_openclose);

            var cboEmployeeID02 = $("#EmployeeID02").data("kendoComboBox");
            cboEmployeeID02.select();
            Emp02 = cboEmployeeID02.value();
            cboEmployeeID02.input[0].value = cboEmployeeID02.text().split(' [^-^] ')[0];
            Emp02Name = cboEmployeeID02.input[0].value;
            cboEmployeeID02.bind('change', cbo_change);
            cboEmployeeID02.bind('open', combobox_openclose);
            cboEmployeeID02.bind('close', combobox_openclose);

            var cboEmployeeID03 = $("#EmployeeID03").data("kendoComboBox");
            cboEmployeeID03.select();
            Emp03 = cboEmployeeID03.value();
            cboEmployeeID03.input[0].value = cboEmployeeID03.text().split(' [^-^] ')[0];
            Emp03Name = cboEmployeeID03.input[0].value;
            cboEmployeeID03.bind('change', cbo_change);
            cboEmployeeID03.bind('open', combobox_openclose);
            cboEmployeeID03.bind('close', combobox_openclose);

            var cboEmployeeID04 = $("#EmployeeID04").data("kendoComboBox");
            cboEmployeeID04.select();
            Emp04 = cboEmployeeID04.value();
            cboEmployeeID04.input[0].value = cboEmployeeID04.text().split(' [^-^] ')[0];
            Emp04Name = cboEmployeeID04.input[0].value;
            cboEmployeeID04.bind('change', cbo_change);
            cboEmployeeID04.bind('open', combobox_openclose);
            cboEmployeeID04.bind('close', combobox_openclose);

            var cboEmployeeID05 = $("#EmployeeID05").data("kendoComboBox");
            cboEmployeeID05.select();
            Emp05 = cboEmployeeID05.value();
            cboEmployeeID05.input[0].value = cboEmployeeID05.text().split(' [^-^] ')[0];
            Emp05Name = cboEmployeeID05.input[0].value;
            cboEmployeeID05.bind('change', cbo_change);
            cboEmployeeID05.bind('open', combobox_openclose);
            cboEmployeeID05.bind('close', combobox_openclose);
        }
    });
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
    list.push(AddList("ScreenID", "BF3004"));
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
        if (e.sender.element.context.name == "EmployeeID01") {
            if (cbo.text() == cbo.value()) {
                cbo.value(Emp01);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = Emp01Name;
                }
                return;
            }
            else {
                Emp01 = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    Emp01Name = cbo.input[0].value;
                }
            }
        }
        else if (e.sender.element.context.name == "EmployeeID02") {
            if (cbo.text() == cbo.value()) {
                cbo.value(Emp02);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                }
                else {
                    cbo.input[0].value = Emp02Name;
                }
                return;
            }
            else {
                Emp02 = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    Emp02Name = cbo.input[0].value;
                }
            }
        }
        else if (e.sender.element.context.name == "EmployeeID03") {
            if (cbo.text() == cbo.value()) {
                cbo.value(Emp03);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = Emp03Name;
                }
                return;
            }
            else {
                Emp03 = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    Emp03Name = cbo.input[0].value;
                }
            }
        }
        else if (e.sender.element.context.name == "EmployeeID04") {
            if (cbo.text() == cbo.value()) {
                cbo.value(Emp04);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = Emp04Name;
                }
                return;
            }
            else {
                Emp04 = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    Emp04Name = cbo.input[0].value;
                }
            }
        }
        else if (e.sender.element.context.name == "EmployeeID05") {
            if (cbo.text() == cbo.value()) {
                cbo.value(Emp05);
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                } else {
                    cbo.input[0].value = Emp05Name;
                }
                return;
            }
            else {
                Emp05 = cbo.value();
                if (cbo.text().split(' [^-^] ').length > 1) {
                    cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                    Emp05Name = cbo.input[0].value;
                }
            }
        }
        else if (e.sender.element.context.name == "CurrencyID_BI") {
                    if (cbo.text() == cbo.value()) {
                        cbo.value(Currency);
                        if (cbo.text().split(' [^-^] ').length > 1) {
                            cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                        } else {
                            cbo.input[0].value = CurrencyName;
                        }
                        return;
                    }
                    else {
                        Currency = cbo.value();
                        if (cbo.text().split(' [^-^] ').length > 1) {
                            cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
                            CurrencyName = cbo.input[0].value;
                        }
                    }
            }
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

function cboFromInventoryID_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");

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
    }
}

function cboToInventoryID_change(e) {
    if (e) {
        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");

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
