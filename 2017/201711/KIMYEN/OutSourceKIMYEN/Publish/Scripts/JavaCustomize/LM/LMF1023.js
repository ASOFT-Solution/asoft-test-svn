var GridLMT1020 = null;
var GridEditLMT1020 = null;
var rowNumber = 0;

$(document).ready(function () {
    LMF1023.LMF1023_Load();
    GridLMT1020 = $("#GridLMT1020").data('kendoGrid');
    $("#btnChoose").unbind('click');
    $("#btnChoose").bind('click', LMF1023.btnChoose_Click);

    GridLMT1020.bind('dataBound', function () {
        $("#GridLMT1020 tbody input[type='checkbox']").prop('checked', false);
    });
})

var LMF1023 = new function () {

    /**  
    * form load
    *
    * [Kim Vu] Create New [07/12/2017]
    **/
    this.LMF1023_Load = function (e) {
        // url Action
        var url = "/Partial/GetGridEditLMT1020";
        // [2] Render iframe
        ASOFT.helper.postTypeJson(url, {},
            function (result) {
                $(".container_12.asf-form-button").after(result);
                $("#GridEditLMT1020 .k-grid-content").css('height', '250px');
                $("#GridEditLMT1020 .k-grid-content").css('overflow-y', 'scroll !important');
                $(".k-pager-wrap.k-grid-pager.k-widget").append($("#btnChoose"));
                $($("#btnCancel").parent().parent().parent()).css('display', 'none');
                $("#GridEditLMT1020").attr("AddNewRowDisabled", "false");

                // add event grid
                setTimeout(function () {
                    var grid = $("#GridEditLMT1020").data('kendoGrid');
                    $(grid.tbody).on('change', 'td', LMF1023.Grid_Change);
                }, 200);
            });

        url = "/LM/LMF1023/GetFilterMaster";
        ASOFT.helper.postTypeJson(url, {},
            function (result) {
                $("#FormFilter .container_12.asf-quick-search-container").before(result);
                $("#FormFilter .container_12.asf-quick-search-container").css('display', 'none');
                ip = $(":input[type='text']");
                $(ip).each(function () {
                    $(this).attr("name", this.id);
                });
            });
    }

    /**  
    * Grid change
    *
    * [Kim Vu] Create new [11/12/2017]
    **/
    this.Grid_Change = function (e) {
        var grid = $("#GridEditLMT1020").data('kendoGrid');
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;
        if (column == 'EvaluationValue' || column == 'LoanLimitRate') {
            selectitem[column] = e.target.value;
            LMF1023.CalculatorAmount(selectitem);
            grid.refresh();
        }
    }

    /**  
    * Calculator Amount
    *
    * [Kim Vu] Create new [11/12/2017]
    **/
    this.CalculatorAmount = function (dataRow) {
        dataRow.LoanLimitAmount = (dataRow.LoanLimitRate * dataRow.EvaluationValue) / 100;
    }

    /**  
    * Filter Click
    * 
    * [Kim Vu] Create New [08/12/2017]
    **/
    this.BtnFilter_Click = function (e) {
        GridLMT1020.dataSource.page(1);
        $("#GridEditLMT1020").data('kendoGrid').dataSource.data([]);
    }

    /**  
    * Clear Filter Click
    * 
    * [Kim Vu] Create New [08/12/2017]
    **/
    this.BtnClearFilter = function (e) {
        $("#SourceID").val('');
        $("#InheritID").val('');
    }

    /**  
    * Choose Click
    * 
    * [Kim Vu] Create New [08/12/2017]
    **/
    this.btnChoose_Click = function (e) {
        rowNumber = 0;
        if ($("#GridEditLMT1020 #chkAll").prop('checked')) {
            $("#GridEditLMT1020 #chkAll").trigger('click');
        }
        var data = [];
        var dataGridLMT1020 = ASOFT.asoftGrid.selectedRecords(GridLMT1020);
        if (dataGridLMT1020) {
            dataGridLMT1020.forEach(function (row) {
                data.push({
                    SourceID: row.SourceID,
                    SourceName: row.SourceName,
                    InheritID: row.InheritID,
                    AssetID: row.AssetID,
                    AssetName: row.AssetName,
                    AccountingValue: row.AccountingValue,
                    LoanLimitRate: 0,
                    EvaluationValue: 0,
                    Note: row.Note
                });
            });
        }
        $("#GridEditLMT1020").data('kendoGrid').dataSource.data(data);
        $("#GridEditLMT1020 #chkAll").trigger('click');
    }

    /**  
    * Save Data
    *
    * [Kim Vu] Create New [11/12/2017]
    **/
    this.Save_Click = function (e) {
        if (!LMF1023.TestInput())
            return;

        var url = "/LM/LMF1023/Confirm";
        var data = LMF1023.GetDataInGrid();
        ASOFT.helper.postTypeJson(url, { data: data },
           function (result) {
               if (result.success) {
                   //Close popup
                   //btnCancle_Click();
                   // Clear control after save
                   $('#GridEditLMT1020').data('kendoGrid').dataSource.data([]);
                   $('#GridLMT1020').data('kendoGrid').dataSource.data([]);

               } else {
                   ASOFT.dialog.messageDialog(kendo.format(ASOFT.helper.getMessage(result.messageID), result.data.join()));
                   var grid = $('#GridEditLMT1020').data('kendoGrid');
                   var grid_tr = $('#GridEditLMT1020 .k-grid-content tr');
                   var dataGrid = grid.dataSource._data;
                   for (var i = 0; i < dataGrid.length; i++) {
                       var item = grid.dataSource._data[i];
                       if (LMF1023.CheckContainValueInArray(result.data, item.AssetID)) {
                           $($(grid_tr[i]).children()[LMF1023.GetColIndex(grid, "AssetID")]).addClass('asf-focus-input-error');
                       }
                   }
               }
           });
    }

    /**  
    * Check contain in array
    *
    * [Kim Vu] Create New [11/12/2017]
    **/
    this.CheckContainValueInArray = function (array, value) {
        for (var i = 0; i < array.length; i++) {
            if (value == array[i]) {
                return true;
            }
        }
        return false;
    }

    /**  
    * Get Data Grid
    *
    * [Kim Vu] Create New [11/12/2017]
    **/
    this.GetDataInGrid = function () {
        //var data = [];
        var grid = $("#GridEditLMT1020").data('kendoGrid');
        //var i = 0;
        //grid.dataSource._data.forEach(function (row) {
        //    if ($(grid.tbody.find('tr')[i]).find("input[type='checkbox']").prop('checked')) {
        //        data.push(row);
        //    }
        //});
        //return data;
        var records = ASOFT.asoftGrid.selectedRecords(grid);
        if (records.length > 0)
            return records;
        return null;
    }

    /**  
    * Test Input data
    *
    * [Kim Vu] Create new [11/12/2017]
    **/
    this.TestInput = function () {
        var check = true;
        var grid = $('#GridEditLMT1020').data('kendoGrid');
        var grid_tr = $('#GridEditLMT1020 .k-grid-content tr');
        var assetID = [];
        var dataGrid = grid.dataSource._data;
        var checkrequireAssetName = true;
        var checkrequireAssetID = true;
        var checkrequireValidDate = true;
        for (var i = 0; i < dataGrid.length; i++) {
            var item = grid.dataSource._data[i];
            for (var j = i + 1; j < dataGrid.length; j++) {
                var item1 = grid.dataSource._data[j];
                if (item.AssetID == item1.AssetID) {
                    $($(grid_tr[i]).children()[LMF1023.GetColIndex(grid, "AssetID")]).addClass('asf-focus-input-error');
                    check = false;
                    assetID.push(item.AssetID);
                }
            }

            if (item.AssetName == 'undefined' || item.AssetName == null
                || item.AssetName == "") {
                checkrequireAssetName = false;
            }

            if (item.AssetID == 'undefined' || item.AssetID == null
                || item.AssetID == "") {
                checkrequireAssetID = false;
            }

            if (item.ValidDate == 'undefined' || item.ValidDate == null
                || item.ValidDate == "") {
                checkrequireValidDate = false;
            }
        }

        if (!checkrequireAssetID) {
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[LMF1023.GetColIndex(grid, "AssetID")]).attr("data-title")));
            return false;
        }
        if (!checkrequireAssetName) {
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[LMF1023.GetColIndex(grid, "AssetName")]).attr("data-title")));
            return false;
        }
        if (!checkrequireValidDate) {
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[LMF1023.GetColIndex(grid, "ValidDate")]).attr("data-title")));
            return false;
        }

        if (!check) {
            ASOFT.dialog.messageDialog(kendo.format(ASOFT.helper.getMessage("00ML000053"), assetID.join()));
            return false;
        }
        return true;
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

function Grid_Save() {
}

function ReadGridEdit() {
}

function renderNumber(data, tbRowNum) {
    return ++rowNumber;
}

function parseDateCustom(data) {
    var cl = "ValidDate";
    if (data[cl] != "" && data[cl] != null && Date.parse(data[cl]) != NaN) {
        var strParse = "dd/MM/yyyy";
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