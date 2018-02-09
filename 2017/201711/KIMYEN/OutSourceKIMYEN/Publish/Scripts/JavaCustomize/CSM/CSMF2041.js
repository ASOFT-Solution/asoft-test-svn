$(document).ready(function () {
    CSMF2041.LayoutControl();
    CSMF2041.AddEvent();
});

var CSMF2041 = new function () {

    this.btnBarcode = '<a class="asf-i-find-barcode-32 k-button-icontext k-button" id="btnFindBarCode" style="z-index:10001; position: absolute; top:0px;right: 0px; height: 25px; min-width: 50px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text"></span></a>';

    /**  
    * Load Grid
    *
    * [Kim Vu] create new [25/01/2018]
    **/
    this.LoadGrid = function (e) {
        var grid = $("#GridEditCSMFT2031").data('kendoGrid');
        var rowCount = grid.dataSource.data().length;
        if (rowCount >= 50) {
            ASOFT.dialog.showMessage('CSFML000006');
            return;
        }
        var url = "/CSM/CSMF2040/GetDataDispatchID";
        var data = {
            dispatchID: $("#DispatchID").val()
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.length > 0) {
                result.forEach(function (row) {
                    if (!CSMF2041.CheckContain(grid, row)) {
                        grid.dataSource._data.push(row);
                    }
                });
            }
        });
        setTimeout(function () {
            $("#DispatchID").focus();
        }, 100);
        grid.refresh();
    }

    /**  
    * Check contain APK
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.CheckContain = function (grid, dataRow) {
        var check = false;
        grid.dataSource._data.forEach(function (currentRow) {
            if (currentRow.APK == dataRow.APK)
                check = true;
        });
        return check;
    }

    /**  
    * Add Event control
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.AddEvent = function () {
        $("#btnEmployeeName").bind('click', CSMF2041.btnEmployeeName_click);
        $("#btnDeleteEmployeeName").bind('click', CSMF2041.btnDeleteEmployeeName_click);
        $("#DispatchID").bind('keydown', CSMF2041.txtDispatchID_keypress);
        $("#btnFindBarCode").bind('click', CSMF2041.LoadGrid);
        $("#SaveNew").unbind('click');
        $("#SaveNew").bind('click', CSMF2041.Save);
        $("#Close").unbind('click');
        $("#Close").bind('click', CSMF2041.Close);        
    }

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.LayoutControl = function () {
        $(".DispatchID").css("position", "relative");
        $(".DispatchID .asf-filter-input").append(this.btnBarcode);
        $(".DispatchID .asf-filter-input .asf-textbox").css('border', "1px solid #aaa");
        var grid = $("#GridEditCSMFT2031").data('kendoGrid');
        if (grid) {
            grid.hideColumn(CSMF2041.GetColIndex(grid, "Model1"));
            grid.hideColumn(CSMF2041.GetColIndex(grid, "SymptomCode"));
        }
        $("#GridEditCSMFT2031 table").css('width', '100%');
        $("#SaveClose").css('display', 'none');
        // Clear grid
        setTimeout(function () {
            grid.dataSource.data([]);
        }, 200);
        value = ASOFT.helper.getLanguageString("CSMF2031.DispatchID_M", "CSMF2031", "CSM");
        $($(".DispatchID").children()[0]).find('label').html(value);
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

    /**  
    * btn employee click
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.btnEmployeeName_click = function (e) {
        var urlpopup = "/PopupSelectData/Index/CSM/CSMF2034?ScreenID=CSMF2041";
        ASOFT.asoftPopup.showIframe(urlpopup, {});
    }

    /**  
    * delete employee
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.btnDeleteEmployeeName_click = function (e) {
        $("#EmployeeID").val('');
        $("#EmployeeName").val('');
    }

    /**  
    * Key press dispatchID
    *
    * [Kim Vu] Create New [25/01/2018]
    **/
    this.txtDispatchID_keypress = function (e) {
        if (e.keyCode == 13) {
            CSMF2041.LoadGrid();
        }
    }

    /**  
    * Save Data
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.Save = function (e) {
        // Kiem tra nhap lieu
        if (!CSMF2041.TestInput())
            return;
        var urlSave = "/CSM/CSMF2040/DoExecuteData";
        var dataGrid = [];
        var grid = $("#GridEditCSMFT2031").data('kendoGrid');
        grid.dataSource.data().forEach(function (row) {
            dataGrid.push(row.APK);
        });
        var dataSave = {
            employeeID: $("#EmployeeID").val(),
            APKList: dataGrid
        };
        ASOFT.helper.postTypeJson(urlSave, dataSave, function (result) {
            if (result) {
                ASOFT.dialog.showMessage('00ML000015');
                grid.dataSource.data([]);
            } else {
                ASOFT.dialog.showMessage('00ML000062');
            }
        });
    }

    /**  
    * Check Input
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.TestInput = function () {
        ASOFT.form.clearMessageBox();

        if ($("#EmployeeID").val() == "" ||
            $("#EmployeeID").val() == "undefined" ||
            $("#EmployeeID").val() == null
            ) {
            CSMF2041.inputError("EmployeeName");
            var msg = ASOFT.helper.getMessage("00ML000039");
            ASOFT.form.displayError("#CSMF2041", kendo.format(msg, ASOFT.helper.getLanguageString("CSMF2041.EmployeeName", "CSMF2041", "CSM")));
            return false;
        }

        var grid = $("#GridEditCSMFT2031").data('kendoGrid');
        if (grid &&
            grid.dataSource._data.length == 0) {
            var msg = ASOFT.helper.getMessage("00ML000061");
            ASOFT.form.displayError("#CSMF2041", msg);
            return false;
        }

        return true;
    }

    /**  
    * Add class error
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.inputError = function (pVariable) {
        var element = $('#' + pVariable);
        var fromWidget = element.closest(".k-widget");
        var widgetElement = element.closest("[data-" + kendo.ns + "role]");
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
            fromWidget.addClass('asf-focus-input-error');
            var input = fromWidget.find(">:first-child").find(">:first-child");
            if (input) {
                $(input).addClass('asf-focus-combobox-input-error');
            }
        } else {
            element.addClass('asf-focus-input-error');
        }
    }

    /**  
    * Close form
    *
    * [Kim Vu] Create New [26/01/2018]
    **/
    this.Close = function (e) {
        if (isDataChanged()) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CSMF2041.Save,
                function () {
                    parent.popupClose();
                });
        }
        else {
            parent.popupClose();
        }
    }
}

/**  
* Callback function
*
* [Kim Vu] Create New [25/01/2018]
**/
function receiveResult(result) {
    $("#EmployeeID").val(result.EmployeeID);
    $("#EmployeeName").val(result.EmployeeName);
};