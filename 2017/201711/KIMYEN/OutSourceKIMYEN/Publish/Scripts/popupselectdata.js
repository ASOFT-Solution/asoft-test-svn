var typeSelected = null;
var GridKendo = null;
var isQuickAddCommon = false;
var GridKendoChild = null;
var typeFields = {};

$(document).ready(function () {
    GridKendo = $("#Grid" + $("#sysTable" + $("#sysScreenID").val()).val()).data('kendoGrid');
    GridKendoChild = $("#Grid" + $("#tableNameChild").val()).data('kendoGrid');
    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);
    });

    $("#btnSearchObject").click(function () {
        GridKendo.dataSource.page(1);
    });

    $("#btnSearchObject").keyup(function (e) {
        if (e.keyCode == 13) {
            $("#btnSearchObject").trigger('click');
        }
    })

    typeSelected = $("#type" + $("#sysScreenID").val()).val();


    GridKendo.bind('dataBound', function () {
        if (typeSelected == "1") {
            if (GridKendo.dataSource.data().length == 1) {
                $(GridKendo.tbody.find('input[type="checkbox"]')[0]).trigger("click");
            }
        }
        else {
            $($('input[name=radio-check]')[0]).trigger('click');
        }

        if (!GridKendoChild) {
            if (isQuickAddCommon && GridKendo.dataSource.data().length == 1) {
                $("#btnChoose").trigger('click');
            }
            else {
                isQuickAddCommon = false;
            }
        }
        else {
            GridKendoChild.dataSource.page(1);
            if (typeSelected == 1) {
                GridKendo.thead.find('#chkAll').bind("click", function () {
                    GridKendoChild.dataSource.page(1);
                })
                GridKendo.tbody.find('.asoftcheckbox').bind("click", function () {
                    GridKendoChild.dataSource.page(1);
                })
            }
            else {
                $("input[name='radio-check']").click(function () {
                    GridKendoChild.dataSource.page(1);
                })
            }
        }
    });
})




$(document).keyup(function (e) {
    if (e.keyCode == 120) {
        $("#btnSearchObject").trigger("click");
    }
});

function ReadChild() {
    var datamaster = [];
    if ($("#type" + $("#sysScreenID").val()).val() == 1) {
        var GridParent = $("#Grid" + $("#sysTable" + $("#sysScreenID").val()).val()).data('kendoGrid');
        var dataJSON = {};
        GridParent.tbody.find('.asoftcheckbox:checked').closest('tr')
           .each(function () {
               if (typeof GridParent.dataItem(this) !== 'undefined') {
                   var itemData = GridParent.dataItem(this);
                   $.each(itemData, function (key, value) {
                       var type = $("#" + key + "_TypeFields").val();
                       if (type) {
                           if (type == 13 && value != "" && value != null) {
                               var strParse = "yyyy-MM-dd HH:mm:ss";
                               value = kendo.toString(kendo.parseDate(value), strParse);
                           }
                           if (type == 9 && value != "" && value != null) {
                               var strParse = "yyyy-MM-dd";
                               value = kendo.toString(kendo.parseDate(value), strParse);
                           }

                           if (key in dataJSON) {
                               dataJSON[key] += "," + value;
                           }
                           else {
                               dataJSON[key] = value;
                           }

                           if (!((key + "_Type_Fields") in dataJSON)) {
                               dataJSON[key + "_Type_Fields"] = 4;
                           }
                       }
                   })

               }
           });
        datamaster.push(dataJSON);
    }
    else {
        var checkedRadio = $('input[name=radio-check]:checked');
        if (checkedRadio.length > 0) {
            var ListColumn = $("#ListColumn").val();
            ListColumn = ListColumn.split(',');
            var item = {};
            for (i = 0; i < ListColumn.length - 1; i++) {
                var type = $("#" + ListColumn[i] + "_TypeFields").val();
                var dtRadio = checkedRadio.attr("radio_" + ListColumn[i]);
                if (type == 13 && dtRadio != "" && dtRadio != null)
                {
                    var strParse = "yyyy-MM-dd HH:mm:ss";
                    dtRadio = kendo.toString(kendo.parseDate(dtRadio), strParse);
                }
                if (type == 9 && dtRadio != "" && dtRadio != null) {
                    var strParse = "yyyy-MM-dd";
                    dtRadio = kendo.toString(kendo.parseDate(dtRadio), strParse);
                }

                item[ListColumn[i]] = dtRadio;
            }
            datamaster.push(item);
        }
    }

    var returnList = {};
    returnList["args"] = datamaster;
    returnList["table"] = $("#tableNameChild").val();
    returnList["id"] = $("#sysScreenID").val();
    returnList["module"] = $("#Module" + $("#sysScreenID").val()).val();

    return returnList;
}

function ReadTK() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    var Lvalue = Array();
    var Lkey = Array();
    $.each(datamaster, function (key, value) {
        Lkey.push(key);
        Lvalue.push(value);
    });
    datamaster["args.key"] = Lkey;
    datamaster["args.value"] = Lvalue;

    var systemInfo = Array();
    systemInfo.push($("#sysScreenID").val());
    systemInfo.push($("#Module" + $("#sysScreenID").val()).val());
    systemInfo.push($("#sysTable" + $("#sysScreenID").val()).val());
    datamaster["args.systemInfo"] = systemInfo;
    return datamaster;
}

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function btnCancle_Click() {
    ASOFT.asoftPopup.closeOnly();
}

function returnGridDetail()
{
    if ($("#typeChild").val() == 1) {
        var records = ASOFT.asoftGrid.selectedRecords(GridKendoChild);
        if (records.length > 0)
            return records;
        return null;
    }
    else {
        var checkedRadio = GridKendoChild.tbody.find('input[name=radio-check]:checked');
        if (checkedRadio.length == 0) {
            console.log('NO MEMEBER CHOOSEN');
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));//ASOFT.helper.getMessage("00ML000066"));
            return null;
        } else {
            var item = GridKendoChild.dataItem(checkedRadio.closest('tr'));
            return item;
        }
    }
}

function btnChoose_Click(e) {

    if (typeSelected == "2") {
        var checkedRadio = $('input[name=radio-check]:checked');
        if (checkedRadio.length == 0) {
            console.log('NO MEMEBER CHOOSEN');
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));//ASOFT.helper.getMessage("00ML000066"));
        } else {
            var ListColumn = $("#ListColumn").val();
            ListColumn = ListColumn.split(',');
            var item = {};
            for (i = 0; i < ListColumn.length - 1; i++) {
                item[ListColumn[i]] = checkedRadio.attr("radio_" + ListColumn[i]);
            }
            var item2 = GridKendo.dataItem(checkedRadio.closest('tr'));

            if (GridKendoChild) {
                var dataGirdDT = returnGridDetail();
                if (dataGirdDT) {
                    if (typeof parent.receiveResultVersion2 === "function")
                        window.parent.receiveResultVersion2(item2, dataGirdDT);
                    else if (typeof parent.receiveResult === "function")
                        window.parent.receiveResult(item, dataGirdDT);
                    
                }
                else {
                    return false;
                }
            }
            else {
                if (typeof parent.receiveResultVersion2 === "function")
                    window.parent.receiveResultVersion2(item2);
                else if (typeof parent.receiveResult === "function")
                    window.parent.receiveResult(item);
                
            }
            ASOFT.asoftPopup.closeOnly();
        }
    }
    else {
        var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
        
        if (records.length == 0)
            return false;

        if (GridKendoChild) {
            var dataGirdDT = returnGridDetail();
            if (dataGirdDT) {
                if (typeof parent.receiveResult === "function")
                    window.parent.receiveResult(records, dataGirdDT);
            }
            else {
                return false;
            }
        }
        else {
            if (typeof parent.receiveResult === "function")
                window.parent.receiveResult(records);
        }
        ASOFT.asoftPopup.closeOnly();
    }
}

function parseDate(dataTime, typeCL) {
    //var rtur = kendo.toString(kendo.parseDate(data), "dd/MM/yyyy");
    //if (rtur != null)
    //    return rtur;
    if (dataTime) {
        var data = dataTime.split(" ")[0];
        var day = data.split('/')[0];
        var month = data.split('/')[1];
        var year = data.split('/')[2];
        var date = year + '-' + month + '-' + day;
        if (typeCL == 13) {
            date += " " + dataTime.split(" ")[1];
            return kendo.toString(kendo.parseDate(date), "dd/MM/yyyy HH:mm:ss");
        }
        else {
            return kendo.toString(kendo.parseDate(date), "dd/MM/yyyy");
        }
    }
    else {
        return kendo.toString('');
    }
}

//function parseDate(data, typeCL) {
//    if (data != "" && data != null && Date.parse(data) != NaN) {
//        if (typeof (data) == "string") {
//            if (data.indexOf("Date") != -1) {
//                var strParse = typeCL == 13 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
//                var str = kendo.toString(kendo.parseDate(data), strParse);
//                return str;
//            }
//            else
//                return data;
//        }
//        else {
//            var strParse = typeCL == 13 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
//            var str = kendo.toString(kendo.parseDate(data), strParse);
//            return str;
//        }
//    }
//    return "";
//}

function QuickAddCommon(txtSearch) {
    $("#TxtSearch").val(txtSearch);
    $("#btnSearchObject").trigger('click');
    isQuickAddCommon = true;
}

function zenValue(data, key) {
    if (data[key] != null && data[key] != "")
        return data[key];
    return '';
}



function parseDateVersion2(data, cl, typeCL) {
    if (data[cl] != "" && data[cl] != null && Date.parse(data[cl]) != NaN) {
        var strParse = typeCL == 13 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
        if (typeof (data[cl]) == "string") {
            if (data[cl].indexOf("Date") != -1) {
                var str = kendo.toString(kendo.parseDate(data[cl]), strParse);
                data[cl] = str;
                return str;
            }
            else
                return data[cl];
        }
        else {
            var str = kendo.toString(kendo.parseDate(data[cl]), strParse);
            data[cl] = str;
            return str;
        }
    }
    return "";
}

function GroupChoose_Click(e, nameGroup) {
    var listGroup = $("tr[class='k-grouping-row']");
    var groupChoose = e.closest('tr');
    var indexGroup = -1;
    listGroup.each(function (index, element) {
        if (element === groupChoose) {
            indexGroup = index;
        }
    })

    if (indexGroup == -1)
        return;

    var dataSourceGrid = GridKendo.dataSource._data[indexGroup];
    var rows = dataSourceGrid.items;
    for (var i = 0; i < rows.length; i++) {
        $($("tr[data-uid='" + rows[i].uid + "']").find("input[type='checkbox']")).prop("checked", $(e).is(":checked"))
    }
}