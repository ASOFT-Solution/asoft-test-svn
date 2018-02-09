function onAfterInsertSuccess(result, action) {
    if (action == 4 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}

$(document).ready(function () {
    var GridPAT10002 = $("#GridEditPAT10002").data("kendoGrid");
    GridPAT10002.bind('dataBound', function (e) {
        var lengthGrid = GridPAT10002.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var item = GridPAT10002.dataSource.at(i);
            if (item.LastModifyDate != "" && item.LastModifyDate != null) {
                if (item.LastModifyDate.indexOf("Date") != -1) {
                    var str = kendo.toString(kendo.parseDate(item.LastModifyDate), "dd/MM/yyyy HH:mm:ss");
                    item.set("LastModifyDate", str);
                }
            }
            if (item.CreateDate != "" && item.CreateDate != null) {
                if (item.CreateDate.indexOf("Date") != -1) {
                    var str = kendo.toString(kendo.parseDate(item.CreateDate), "dd/MM/yyyy HH:mm:ss");
                    item.set("CreateDate", str);
                }
            }
        }
    });
})


function isInArray(value, array) {
    return array.indexOf(value) > -1;
}


function CustomerCheck() {
    var check = false;
    var message = [];
    $('#' + id + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#' + id + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');
    var grid = $("#GridEditPAT10002").data("kendoGrid");
    if (grid.dataSource.data().length != $("#LevelStandardNo").val()) {
        message.push(ASOFT.helper.getMessage('PAML000001'));
        $("#LevelStandardNo").addClass('asf-focus-input-error');
        check = true;
    }
    var inArray = [];
    for (i = 0 ; i < grid.dataSource.data().length; i++) {
        var itemGrid = grid.dataSource.at(i);
        var invalid = isInArray(parseInt(itemGrid.LevelStandardID), inArray);
        if (invalid) {
            var tr = grid.tbody.find('tr')[i];
            $($(tr).find('td')[1]).addClass('asf-focus-input-error');
            message.push(ASOFT.helper.getMessage('PAML000002').f($($(grid.thead).find('th')[1]).attr("data-title")));
            check = true;
            break;
        }
        inArray.push(parseInt(itemGrid.LevelStandardID));
    }

    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message.slice(0, 1));
    }
    return check;
}