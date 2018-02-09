var advanceTypeID = $(".AdvanceTypeID").html();
$(document).ready(function () {
    LMF2012.LayoutControl();
})

var LMF2012 = new function () {

    /**  
    * Layout view 
    *
    * [Kim Vu] Create New [04/01/2018]
    **/
    this.LayoutControl = function () {
        $("#tb_LMT2012").after($("#LMF2012_SubParameter"));
        if (advanceTypeID == "1") {
            $(".AdvancePercent").parent().css('display', 'none');
            // Thay doi ngon ngu
            var value = ASOFT.helper.getLanguageString("LMF2011.ConvertedAmount_1", "LMF2011", "LM");
            $($(".ConvertedAmount").parent().children()[0]).html(value);
            value = ASOFT.helper.getLanguageString("LMF2011.AdvanceDate_1", "LMF2011", "LM");
            $($(".AdvanceDate").parent().children()[0]).html(value);

        } else {
            $(".CostTypeName").parent().css('display', 'none');
            $(".AssignObjectName").parent().css('display', 'none');
        }

        $('.ToDateGuarantee').parent().css('display', 'none');
        $('.FromDateGuarantee').append(' - ' + $('.ToDateGuarantee').text());
    }

    /**  
   * Get Index of columns
   *
   * [Kim Vu] Create New [04/12/2017]
   **/
    this.GetColIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName)
                return i;
        }
        return 0;
    }
}

/**  
* Show hide column 
*
* [Kim Vu] Create New [07/12/2017]
**/
function CustomizePanalSelect(tb, gridDT) {
    if (gridDT.element.context.id == 'GridLMT2012') {
        if (advanceTypeID == "1") {
            gridDT.hideColumn(LMF2012.GetColIndex(gridDT, "EscrowAmount"));
            gridDT.hideColumn(LMF2012.GetColIndex(gridDT, "ToDate"));
            gridDT.hideColumn(LMF2012.GetColIndex(gridDT, "FromDate"));
        } else {
            gridDT.hideColumn(LMF2012.GetColIndex(gridDT, "ClearanceAmount"));
            gridDT.hideColumn(LMF2012.GetColIndex(gridDT, "InterestAmount"));
        }
        $("#GridLMT2012 table").css('width', '');        
    }
}