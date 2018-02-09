//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/01/2017      Văn Tài          Tạo mới
//####################################################################

$(document).ready(function () {
    var grid = $('#GridAT1020').data('kendoGrid');

    grid.bind('dataBound', gridAT1020_ondataBound);
});

var AT1020_fistrefesh = true;
function gridAT1020_ondataBound() {

    var grid = $('#GridAT1020').data('kendoGrid');
    var data = grid.dataSource.data();
    for (var i = 0; i < data.length; i++) {

        var BeginDate = data[i].BeginDate;
        var EndDate = data[i].EndDate;

        var format_begindate = null;
        var format_endate = null;
        var fromdate_index = gridAT1020_getColIndex(grid, "BeginDate");
        var enddate_index = gridAT1020_getColIndex(grid, "EndDate");

        if (BeginDate) {
            format_begindate = BeginDate.split(" ")[0];
        }
        if (EndDate) {
            format_endate = EndDate.split(" ")[0];
        }

        var row = grid.table.find("tr[data-uid='" + data[i].uid + "']");

        if (format_begindate != null) {

            data[i].BeginDate = format_begindate;            
            if (row[0].cells[fromdate_index]) {
                row[0].cells[fromdate_index].innerHTML = format_begindate;
            }
        }
        if (format_endate != null) {
            data[i].EndDate = format_endate;
            if (row[0].cells[enddate_index]) {
                row[0].cells[enddate_index].innerHTML = format_endate;
            }
        }     
    }
}

function gridAT1020_getColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}