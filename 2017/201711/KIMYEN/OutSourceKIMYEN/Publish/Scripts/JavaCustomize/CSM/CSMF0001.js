// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    16/01/2018  Văn Tài         Create New
// ##################################################################

$(document).ready(function () {

    // #region --- First Processing ---

    $("#" + CSMF0001.FIELD_DIVISIONID).val($("#EnvironmentDivisionID").val());


    // #endregion --- First Processing ---

    CSMF0001.CheckExist();
    
    // #region  --- Last Processing ----

    CSMF0001.CatchEvents();

    // #endregion  --- Last Processing ----
});

/**
 * CSMF0001: Thiết lập hệ thống CSM (ERP-9.0)
 */
var CSMF0001 = new function () {

    // #region --- Constants ---

    this.FIELD_DIVISIONID = "DivisionID";

    // #endregion --- Constants ---

    // #region --- Public Methods ---

    /**
     * Kiểm tra tồn tại dữ liệu theo DivisionID 
     * @returns {} 
     * @since [Văn Tài] Created [16/01/2018]
     */
    this.CheckExist = function () {

        var data = {
            divisionID: $("#" + CSMF0001.FIELD_DIVISIONID).val()
        };

        $.ajax({
            url: "/CSM/CSMF0001/CheckExist",
            async: false,
            data: data,
            success: function (result) {
                if (result.IsExist === 1) {
                    $("#SaveClose").attr("style", "display: none !important;");
                    $("#BtnSave").attr("style", "display: block !important;");

                    $("#isUpdate").val("True");


                } else {
                    $("#SaveClose").attr("style", "display: block !important;");
                    $("#BtnSave").attr("style", "display: none !important;");

                    $("#isUpdate").val("False");

                    $("#SaveClose .asf-button-text")[0].outerText = $("#BtnSave .asf-button-text")[0].outerText;
                }

                $("#SaveNew").attr("style", "display: none !important;");
            }
        });
    };

    /**
     * Bắt các sự kiện
     * @since [Văn Tài] Created [16/01/2018]
     * @returns {} 
     */
    this.CatchEvents = function () {

        // Danh mục hãng
        $("#FirmAnalyst").data("kendoComboBox").bind("change", CSMF0001.FilterChanging);

        // Danh mục loại sản phẩm 
        $("#ProductTypeAnalyst").data("kendoComboBox").bind("change", CSMF0001.FilterChanging);

        // Danh mục model 
        $("#ModelAnalyst").data("kendoComboBox").bind("change", CSMF0001.FilterChanging);

        // Danh mục hình thức VC
        $("#TransportTypeAnalyst").data("kendoComboBox").bind("change", CSMF0001.FilterChanging);
    };

    // #region  --- Utilities ---

    /**
     * Lấy toàn bộ dữ liệu ComboBox được chọn
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetComboBoxValueItem = function (elementID) {
        try {
            var combo = $("#" + elementID).data("kendoComboBox");
            return combo.dataItem(combo.select());
        } catch (e) {
            console.log(e);
        }
    };

    /**
     * Set giá trị control ComboBox
     * @param {} elementID 
     * @param {} value: true | false
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetComboBoxValue = function (elementID, value) {
        $("#" + elementID).data("kendoComboBox").value(value);
    };

    // Kiểm tra không phải null hay undefined
    this.IsNotNullOrUndefined = function (checker) {
        return (typeof (checker) != 'undefined' && checker != null);
    };

    // #endregion --- Utilities ---

    // #endregion --- Public Methods ---

    // #region --- Event Handlers ---

    /**
     * Xử lý sự kiện thay đổi cho combo filter
     * @returns {} 
     */
    this.FilterChanging = function (e) {
        if (typeof (e) === 'undefined') return;

        var comboId = e.sender.element.context.id;

        var currentSelectedItem = CSMF0001.GetComboBoxValueItem(comboId);
        if (!CSMF0001.IsNotNullOrUndefined(currentSelectedItem)) return;

        var cb02SelectedItem = CSMF0001.GetComboBoxValueItem("FirmAnalyst");
        var cb03SelectedItem = CSMF0001.GetComboBoxValueItem("ProductTypeAnalyst");
        var cb04SelectedItem = CSMF0001.GetComboBoxValueItem("ModelAnalyst");
        var cb05SelectedItem = CSMF0001.GetComboBoxValueItem("TransportTypeAnalyst");

        var checkers = [];
        if (comboId != "FirmAnalyst" && CSMF0001.IsNotNullOrUndefined(cb02SelectedItem)) {
            checkers.push(cb02SelectedItem.TypeID);
        }
        if (comboId != "ProductTypeAnalyst" && CSMF0001.IsNotNullOrUndefined(cb03SelectedItem)) {
            checkers.push(cb03SelectedItem.TypeID);
        }
        if (comboId != "ModelAnalyst" && CSMF0001.IsNotNullOrUndefined(cb04SelectedItem)) {
            checkers.push(cb04SelectedItem.TypeID);
        }
        if (comboId != "TransportTypeAnalyst" && CSMF0001.IsNotNullOrUndefined(cb05SelectedItem)) {
            checkers.push(cb05SelectedItem.TypeID);
        }

        for (var i = 0; i < checkers.length; i++) {
            if (currentSelectedItem.TypeID == checkers[i]) {
                CSMF0001.SetComboBoxValue(comboId, "");
                break;
            }
        }
    };

    // #endregion --- Event Handlers ---

};

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        window.parent.popupClose();
    }
}
