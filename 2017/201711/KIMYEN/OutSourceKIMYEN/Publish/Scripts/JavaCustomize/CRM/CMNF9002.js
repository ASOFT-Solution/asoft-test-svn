//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/12/2015     Quang Hoàng       Tạo mới
//####################################################################

$(document).ready(function () {
    var GridPartialRoute = "/Partial/GridPartialRoute";
    ASOFT.partialView.Load(GridPartialRoute, ".asf-form-button", 1);
    var grid = $("#GridCT0143").data('kendoGrid');
    grid.bind('dataBound', function (e) {
        $("input[name='radio-check']").click(function () {
            refreshGrid();
        })
    })

    if (typeof parent.returnVATAccountName === "function") {
        $("#TxtSearch").val(parent.returnVATAccountName());
        var GridKendo = $('#GridCT0143').data('kendoGrid');
        GridKendo.dataSource.page(1);
    }
})

function refreshGrid()
{
    var grid = $("#GridPartialRoute").data('kendoGrid');
    grid.dataSource.page(1);
}

function sendData() {
    var data = {};
    data = readMaster();
    return data;
}


function readMaster() {
    var checkedRadio = $('input[name=radio-check]:checked');
    var ListColumn = $("#ListColumn").val();
    ListColumn = ListColumn.split(',');
    var result = [];
    var item = {};
    for (i = 0; i < ListColumn.length - 1; i++) {
        item[ListColumn[i]] = checkedRadio.attr("radio_" + ListColumn[i]);
    }
    result.push(item);
    

    return item;
}

