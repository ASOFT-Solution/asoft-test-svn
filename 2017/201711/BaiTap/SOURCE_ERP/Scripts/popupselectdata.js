var typeSelected = null;
var GridKendo = null;
var isQuickAddCommon = false;

$(document).ready(function () {
    GridKendo = $("#Grid" + $("#sysTable" + $("#sysScreenID").val()).val()).data('kendoGrid');
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
        $($('input[name=radio-check]')[0]).trigger('click');
        if (isQuickAddCommon && GridKendo.dataSource.data().length == 1) {
            $("#btnChoose").trigger('click');
        }
        else {
            isQuickAddCommon = false;
        }
    });
})


$(document).keyup(function (e) {
    if (e.keyCode == 120) {
        $("#btnSearchObject").trigger("click");
    }
});


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

            window.parent.receiveResult(item);
            ASOFT.asoftPopup.closeOnly();
        }
    }
    else {
        var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
        window.parent.receiveResult(records);
        ASOFT.asoftPopup.closeOnly();
    }
}

function parseDate(data) {
    //var rtur = kendo.toString(kendo.parseDate(data), "dd/MM/yyyy");
    //if (rtur != null)
    //    return rtur;
    if (data) {
        data = data.split(" ")[0];
        var day = data.split('/')[0];
        var month = data.split('/')[1];
        var year = data.split('/')[2];
        var date = year + '-' + month + '-' + day;
        return kendo.toString(kendo.parseDate(date), "dd/MM/yyyy");
    }
    else {
        return kendo.toString('');
    }
}

function QuickAddCommon(txtSearch) {
    $("#TxtSearch").val(txtSearch);
    $("#btnSearchObject").trigger('click');
    isQuickAddCommon = true;
}

function zenValue(data, key, dtType) {
    if (data[key] != null && data[key] != "")
        return data[key];
    return '';
}