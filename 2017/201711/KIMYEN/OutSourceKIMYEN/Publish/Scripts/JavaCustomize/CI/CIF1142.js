// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #   [10/01/2018] Thanh Trong    Create New
// ##################################################################
$(document).ready(function () {
});

var CIF1142 = new function () {

    // #region -----Event------
    
    /**
    sự kiên change combobox loaad grid CIT1141
    */
    this.ChangeComboLevelID = function () {
       // $("#LevelID").data("kendoComboBox").bind("change", function (e) {
            var APKMaster = $("#LevelID").val();
            var data = {
                APKMaster: APKMaster,
            };
            $.ajax({
                url: '/CI/CIF1142/LoadGrid_CIT1141',
                async: false,
                data: data,
                success: function (result) {
                    var a = JSON.parse(result);
                    var grid = $("#GridCIT1141").data("kendoGrid");
                    var datasource = grid.dataSource;
                    grid.dataSource.data(a);
                    //for (i = 0; i < a.length; i++)
                    //{
                    //    datasource.insert({ LevelDetailID: a[i]["LevelDetailID"], LevelDetailName: a[i]["LevelDetailName"], Notes: a[i]["Notes"], IsUsed: a[i]["IsUsed"] });
                    //}
                }
            });
    }

    /**
    Get tên kho
    */
    this.GetWareHouse = new function (WareHouseName) {
        WareHouseID = $(".WareHouseID").text();
        WareHouseName = $(".WareHouseName").text();
        return WareHouseName;
    }
    

    this.DeleteViewNoDetail = new function (pk) {
        pk = pk + "," + $(".DivisionID").text() + "," + $(".WareHouseID").text();
        return pk;
    }

    /**
    partialview combobox cap quan ly
    */
    this.GetPartialViewLevelID = new function () {
        var WareHouseID = $(".WareHouseID").text();
        var data = {
            WareHouseID: WareHouseID,
        };
        $.ajax({
            url: '/CI/CIF1140/ComboBoxLevel',
            async: false,
            data: data,
            success: function (result) {
                $("#tb_CIT1141-1").prepend(result);
            }
        });
    }
    // #endregion ------
}


