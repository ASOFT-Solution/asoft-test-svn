var id = $("#sysScreenID").val();
var FromInventType;
var ToInventType;
var Invent01;
var Invent02;
var Invent03;
var Invent04;
var Invent05;

var FromInventTypeName;
var ToInventTypeName;
var Invent01Name;
var Invent02Name;
var Invent03Name;
var Invent04Name;
var Invent05Name;
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
    $("#OORfilter").append($("#FromToI03ID"));
    $("#OORfilter").append($("#InventoryID"));
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
   
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

    var cboFromI03ID = $("#FromI03ID").data("kendoComboBox");
    cboFromI03ID.select(0);
    cboFromI03ID.input[0].value = cboFromI03ID.text().split(' [^-^] ')[1];
    cboFromI03ID.bind('change', combobox_change);
    cboFromI03ID.bind('open', combobox_openclose);
    cboFromI03ID.bind('close', combobox_openclose);

    var cboToI03ID = $("#ToI03ID").data("kendoComboBox");
    cboToI03ID.select(cboToI03ID.dataSource._data.length - 1);
    cboToI03ID.input[0].value = cboToI03ID.text().split(' [^-^] ')[1];
    cboToI03ID.bind('change', combobox_change);
    cboToI03ID.bind('open', combobox_openclose);
    cboToI03ID.bind('close', combobox_openclose);

    //var cboInventoryID01 = $("#InventoryID01").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID01)
    //cboInventoryID01.select(0);
    //Invent01 = cboInventoryID01.value();
    //cboInventoryID01.input[0].value = cboInventoryID01.text().split(' [^-^] ')[0];
    //Invent01Name = cboInventoryID01.input[0].value;
    //cboInventoryID01.bind('change', cbo_change);
    //cboInventoryID01.bind('open', combobox_openclose);
    //cboInventoryID01.bind('close', combobox_openclose);

    //var cboInventoryID02 = $("#InventoryID02").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID02)
    //cboInventoryID02.select(0);
    //Invent02 = cboInventoryID02.value();
    //cboInventoryID02.input[0].value = cboInventoryID02.text().split(' [^-^] ')[0];
    //Invent02Name = cboInventoryID02.input[0].value;
    //cboInventoryID02.bind('change', cbo_change);
    //cboInventoryID02.bind('open', combobox_openclose);
    //cboInventoryID02.bind('close', combobox_openclose);

    //var cboInventoryID03 = $("#InventoryID03").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID03)
    //cboInventoryID03.select(0);
    //Invent03 = cboInventoryID03.value();
    //cboInventoryID03.input[0].value = cboInventoryID03.text().split(' [^-^] ')[0];
    //Invent03Name = cboInventoryID03.input[0].value;
    //cboInventoryID03.bind('change', cbo_change);
    //cboInventoryID03.bind('open', combobox_openclose);
    //cboInventoryID03.bind('close', combobox_openclose);

    //var cboInventoryID04 = $("#InventoryID04").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID04)
    //cboInventoryID04.select(0);
    //Invent04 = cboInventoryID04.value();
    //cboInventoryID04.input[0].value = cboInventoryID04.text().split(' [^-^] ')[0];
    //Invent04Name = cboInventoryID04.input[0].value;
    //cboInventoryID04.bind('change', cbo_change);
    //cboInventoryID04.bind('open', combobox_openclose);
    //cboInventoryID04.bind('close', combobox_openclose);

    //var cboInventoryID05 = $("#InventoryID05").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID05)
    //cboInventoryID05.select(0);
    //Invent05 = cboInventoryID05.value();
    //cboInventoryID05.input[0].value = cboInventoryID05.text().split(' [^-^] ')[0];
    //Invent05Name = cboInventoryID05.input[0].value;
    //cboInventoryID05.bind('change', cbo_change);
    //cboInventoryID05.bind('open', combobox_openclose);
    //cboInventoryID05.bind('close', combobox_openclose);

    //$("#btnExport").css('display', 'none');
    $("#btnPrintBD").css('display', 'none');

    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $("#btnPrint").unbind();
    $("#btnPrint").kendoButton({
        "click": print_Click
    });

    $("#btnExport").unbind();
    $("#btnExport").kendoButton({
        "click": export_Click
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
    list.push(AddList("ScreenID", "BF3005"));
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

//function cbo_change(e) {
//    if (e) {
//        var cbo = $("#" + e.sender.element.context.name).data("kendoComboBox");
//        if (!cbo.text()) {
//            cbo.value("");
//            return;
//        }
//        if (cbo.dataSource._data.length > 0) {
//            if (e.sender.element.context.name == "InventoryID01") {
//                if (cbo.text() == cbo.value()) {
//                    cbo.value(Invent01);
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                    } else {
//                        cbo.input[0].value = Invent01Name;
//                    }
//                    return;
//                }
//                else {
//                    Invent01 = cbo.value();
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                        Invent01Name = cbo.input[0].value;
//                    }
//                }
//            }
//            else if (e.sender.element.context.name == "InventoryID02") {
//                if (cbo.text() == cbo.value()) {
//                    cbo.value(Invent02);
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                    } else {
//                        cbo.input[0].value = Invent02Name;
//                    }
//                    return;
//                }
//                else {
//                    Invent02 = cbo.value();
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                        Invent02Name = cbo.input[0].value;
//                    }
//                }
//            }
//            else if (e.sender.element.context.name == "InventoryID03") {
//                if (cbo.text() == cbo.value()) {
//                    cbo.value(Invent03);
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                    } else {
//                        cbo.input[0].value = Invent03Name;
//                    }
//                    return;
//                }
//                else {
//                    Invent03 = cbo.value();
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                        Invent03Name = cbo.input[0].value;
//                    }
//                }
//            }
//            else if (e.sender.element.context.name == "InventoryID04") {
//                if (cbo.text() == cbo.value()) {
//                    cbo.value(Invent04);
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                    } else {
//                        cbo.input[0].value = Invent04Name;
//                    }
//                    return;
//                }
//                else {
//                    Invent04 = cbo.value();
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                        Invent04Name = cbo.input[0].value;
//                    }
//                }
//            }
//            else if (e.sender.element.context.name == "InventoryID05") {
//                if (cbo.text() == cbo.value()) {
//                    cbo.value(Invent05);
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                    } else {
//                        cbo.input[0].value = Invent05Name;
//                    }
//                    return;
//                }
//                else {
//                    Invent05 = cbo.value();
//                    if (cbo.text().split(' [^-^] ').length > 1) {
//                        cbo.input[0].value = cbo.text().split(' [^-^] ')[0];
//                        Invent05Name = cbo.input[0].value;
//                    }
//                }
//            }
//        } 
//    }
//}

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

        //if (e.sender.element.context.name == "FromInventoryTypeID") {
        //    var cbo1 = $("#ToInventoryTypeID").data("kendoComboBox");
        //    if (cbo.selectedIndex > cbo1.selectedIndex) {
        //        var cboInventoryID01 = $("#InventoryID01").data("kendoComboBox");
        //        var cboInventoryID02 = $("#InventoryID02").data("kendoComboBox");
        //        var cboInventoryID03 = $("#InventoryID03").data("kendoComboBox");
        //        var cboInventoryID04 = $("#InventoryID04").data("kendoComboBox");
        //        var cboInventoryID05 = $("#InventoryID05").data("kendoComboBox");
        //        cboInventoryID01.setDataSource([]);
        //        cboInventoryID01.value("");
        //        cboInventoryID01.refresh();

        //        cboInventoryID02.setDataSource([]);
        //        cboInventoryID02.value("");
        //        cboInventoryID02.refresh();

        //        cboInventoryID03.setDataSource([]);
        //        cboInventoryID03.value("");
        //        cboInventoryID03.refresh();

        //        cboInventoryID04.setDataSource([]);
        //        cboInventoryID04.value("");
        //        cboInventoryID04.refresh();

        //        cboInventoryID05.setDataSource([]);
        //        cboInventoryID05.value("");
        //        cboInventoryID05.refresh();

        //        return;
        //    }
        //} else {
        //    var cbo1 = $("#FromInventoryTypeID").data("kendoComboBox");
        //    if (cbo.selectedIndex < cbo1.selectedIndex) {
        //        var cboInventoryID01 = $("#InventoryID01").data("kendoComboBox");
        //        var cboInventoryID02 = $("#InventoryID02").data("kendoComboBox");
        //        var cboInventoryID03 = $("#InventoryID03").data("kendoComboBox");
        //        var cboInventoryID04 = $("#InventoryID04").data("kendoComboBox");
        //        var cboInventoryID05 = $("#InventoryID05").data("kendoComboBox");
        //        cboInventoryID01.setDataSource([]);
        //        cboInventoryID01.value("");
        //        cboInventoryID01.refresh();

        //        cboInventoryID02.setDataSource([]);
        //        cboInventoryID02.value("");
        //        cboInventoryID02.refresh();

        //        cboInventoryID03.setDataSource([]);
        //        cboInventoryID03.value("");
        //        cboInventoryID03.refresh();

        //        cboInventoryID04.setDataSource([]);
        //        cboInventoryID04.value("");
        //        cboInventoryID04.refresh();

        //        cboInventoryID05.setDataSource([]);
        //        cboInventoryID05.value("");
        //        cboInventoryID05.refresh();
        //        return;
        //    }
        //}
    }

    //var cboInventoryID01 = $("#InventoryID01").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID01)
    //if (cboInventoryID01.text().split(' [^-^] ').length > 1) {
    //    cboInventoryID01.input[0].value = cboInventoryID01.text().split(' [^-^] ')[0];
    //    Invent01Name = cboInventoryID01.input[0].value;
    //}

    //var cboInventoryID02 = $("#InventoryID02").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID02)
    //if (cboInventoryID02.text().split(' [^-^] ').length > 1) {
    //    cboInventoryID02.input[0].value = cboInventoryID02.text().split(' [^-^] ')[0];
    //    Invent02Name = cboInventoryID02.input[0].value;
    //}

    //var cboInventoryID03 = $("#InventoryID03").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID03)
    //if (cboInventoryID03.text().split(' [^-^] ').length > 1) {
    //    cboInventoryID03.input[0].value = cboInventoryID03.text().split(' [^-^] ')[0];
    //    Invent03Name = cboInventoryID03.input[0].value;
    //}

    //var cboInventoryID04 = $("#InventoryID04").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID04)
    //if (cboInventoryID04.text().split(' [^-^] ').length > 1) {
    //    cboInventoryID04.input[0].value = cboInventoryID04.text().split(' [^-^] ')[0];
    //    Invent04Name = cboInventoryID04.input[0].value;
    //}

    //var cboInventoryID05 = $("#InventoryID05").data("kendoComboBox");
    //OpenComboDynamic(cboInventoryID05)
    //if (cboInventoryID05.text().split(' [^-^] ').length > 1) {
    //    cboInventoryID05.input[0].value = cboInventoryID05.text().split(' [^-^] ')[0];
    //    Invent05Name = cboInventoryID05.input[0].value;
    //}
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
    var urlChoose = "/PopupSelectData/Index/SO/SOF2014?FromInventoryTypeID=" + $("#FromInventoryTypeID").val() + "&ToInventoryTypeID=" + $("#ToInventoryTypeID").val() + "&isReport=1&FromI03ID=" + $("#FromI03ID").val() + "&ToI03ID=" + $("#ToI03ID").val();
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnToInventoryID_Click(type) {
    indextypeID = "ToInventoryID0" + type;
    indextypeName = "ToInventoryName0" + type;
    var urlChoose = "/PopupSelectData/Index/SO/SOF2014?FromInventoryTypeID=" + $("#FromInventoryTypeID").val() + "&ToInventoryTypeID=" + $("#ToInventoryTypeID").val() + "&isReport=1&FromI03ID=" + $("#FromI03ID").val() + "&ToI03ID=" + $("#ToI03ID").val();
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    $("#" + indextypeID).val(result.InventoryID);
    $("#" + indextypeName).val(result.InventoryName);
}