
$(document).ready(function () {
    CSMF1081.changecbbProductType();
    CSMF1081.disabledcontrol();
});

var CSMF1081 = new function () {
    this.changecbbProductType = function () {
        $("#ProductType").unbind("change");
        $("#ProductType").bind("change", function () {
            var data = {
                ProductType: $("#ProductType").val(),
                FormID: "CSMF1081",
                Model:"",
            };
            $.ajax({
                url: '/CSM/CSMF1081/getdatacombobox',
                async: false,
                data: data,
                success: function (result) {
                    var a = JSON.parse(result);
                    var FirmID = a[0]["FirmID"];
                    var FirmName = a[0]["FirmName"];
                    //$("#FirmID").kendoComboBox({
                    //    dataSource: [
                    //                { FirmID: FirmID, FirmName: FirmName }
                    //    ],
                    //    dataTextField: "FirmName",
                    //    dataValueField: "FirmID"
                    //});
                    //$("#FirmID").val(FirmID);
                    var combobox = $("#FirmID").data("kendoComboBox");
                    var data = combobox.dataSource._data;
                    data = [];
                    data.push({ FirmID: FirmID, FirmName: FirmName });
                    combobox.setDataSource(data);
                    combobox.select(0);
                }
            });
        });
    }
    this.disabledcontrol = function () {
        if ($("#isUpdate").val() == "True") {
            $("#IsCommon").attr("disabled", "disabled");
        }
    }
}
