var dataPeriod = null;
var divisionID = null;

$(document).ready(function () {
    
});

var closeBook = new function () {
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    }

    this.btnCloseBook_Click = function () {      

        var url = $("#UrlUpdateCloseBook").val();
        var data = ASOFT.helper.getFormData(null, "CloseBook");

        ASOFT.helper.postOpenCloseBook(url, data, closeBook.closeBookSuccess);
    }

    this.closeBookSuccess = function (result) {
        if (result.Status == 0) {
            if (result.Data) {
                window.parent.window.location.reload(true);
            }
            else {
                ASOFT.dialog.messageDialog(ASOFT.helper.getMessage("A00ML000010"));
                window.location.reload(true);
            }
        }
        else {
            if (result.Data) {
                result.Mesage = ASOFT.helper.getMessage("A00ML000009");
            }
            else {
                result.Mesage = ASOFT.helper.getMessage("A00ML000011");
            }
            ASOFT.helper.showErrorSever(result.Mesage);
        }        
    }
}


