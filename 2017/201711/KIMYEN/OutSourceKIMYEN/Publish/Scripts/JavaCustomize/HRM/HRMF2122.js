function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridHRMT2101') {
        gridDT.hideColumn(GetColIndex(gridDT, "APK"));
    }
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}