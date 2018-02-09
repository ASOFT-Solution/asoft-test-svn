$(document).ready(function () {
    CSMF2034.LayoutControl();
});

var CSMF2034 = new function () {

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.LayoutControl = function () {
                
        var grid = $("#GridCSMFT2034").data('kendoGrid');
        // Dieu phoi QC
        if (grid) {            
            if (window.parent.$("#CSMF2041").length == 1) {
                grid.hideColumn(CSMF2034.GetColIndex(grid, "QuantityUnfinished"));
                grid.hideColumn(CSMF2034.GetColIndex(grid, "QuantityNotFix"));
                grid.hideColumn(CSMF2034.GetColIndex(grid, "QuantityWaiting"));
            } else {
                // Dieu phoi ky thuat
                grid.hideColumn(CSMF2034.GetColIndex(grid, "QuantityNotTest"));
            }            
            $("#GridCSMFT2034 table").css('width', '100%');
        }
    }

    /**  
    * Get col index
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.GetColIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName)
                return i;
        }
        return null;
    }
}