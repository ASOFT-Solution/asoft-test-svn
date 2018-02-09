// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #   [10/01/2018] Thanh Trong    Create New
// ##################################################################
$(document).ready(function () {
    
});

var CIF1143 = new function () {

    // #region --Event--
    this.SetWareHouse = new function () {
        //window.parent.CIF1142.GetWareHouse();
        $("#WareHouseID").val($("#PKParent").val());
    }
    // #endregion ------

    this.SetValueLevelName = new function () {
        $("#LevelName").val($("#APKMaster").val());
    }

    this.DisableControl = new function ()
    {
        $("#WareHouseID").css("display", "block");
        //$(".APKMaster").css("display", "none");
    }
    this.CheckAddNew = new function ()
    {
        if ($("#isUpdate").val() == "False")
        {
            $("#LevelName").bind("change", function () {
                $("#APKMaster").val($("#LevelName").val());
            })
            var grid = $("#GridEditCIT1141_1").data("kendoGrid");
            //grid.dataSource.data([]);
        }
    }
}
