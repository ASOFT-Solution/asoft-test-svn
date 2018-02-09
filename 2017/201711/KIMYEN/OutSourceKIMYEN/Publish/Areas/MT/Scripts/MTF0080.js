//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/03/2013       Huy Cường      Tạo mới
//####################################################################

MTF0080 = new function () {
    this.isSearch = false;
    this.gridMaster = null;
    this.MTF0080Popup = null;


    this.sendFilter = function() {
        var data = ASOFT.helper.getFormData(null, "FormFilterMTF0080");
        var datamaster = { };
        $.each(data, function() {
            if (datamaster[this.name]) {
                if (!datamaster[this.name].push) {
                    datamaster[this.name] = [datamaster[this.name]];
                }
                datamaster[this.name].push(this.value || '');
            } else {
                datamaster[this.name] = this.value || '';
            }
        });
        datamaster['IsSearch'] = MTF0080.isSearch;
        return datamaster;
    };

    this.btnfilter_Click = function() {
        MTF0080.isSearch = true;
        if (MTF0080.gridMaster) {
            MTF0080.gridMaster.dataSource.page(1);
        }
    };

    this.showPopup = function(objectType) {

        var urlContent = "/MT/MTF0080";
        var data = {
            ObjectType: objectType
        };

        MTF0080.MTF0080Popup = ASOFT.asoftPopup.castName("MTF0080Popup");

        if (MTF0080.MTF0080Popup) {
            //Bắt sự kiện khi popup đã hiện lên tất cả nội dung
            MTF0080.MTF0080Popup.bind("refresh", function() {
                MTF0080.gridMaster = $("#MTF0080_GridMaster").data("kendoGrid");

                var firstTime = true;
                $(document).keyup(function (e) {
                    if (firstTime && e.which != 13) {
                        $("#SearchText").val(String.fromCharCode(e.which));
                        firstTime = false;
                    }
                    $("#SearchText").focus();
                });
                
                $("#SearchText").change(function () {
                    MTF0080.btnfilter_Click();
                }).click(function () {
                    this.select();
                });

            });
        }
        var popup = MTF0080.MTF0080Popup;
        ASOFT.asoftPopup.show(popup, urlContent, data);
    };
    
    this.btnCloseObjectClick = function () {
        $(document).unbind("keyup");
        MTF0080.MTF0080Popup.close();
    };

    this.btnOkObjectClick = function() {
        var itemObject = ASOFT.asoftGrid.selectedRecord(MTF0080.gridMaster);
        ASOFT.helper.setObjectData(itemObject);
        MTF0080.MTF0080Popup.close();
        executeFunctionByName(delegateFunction);
    };
}
