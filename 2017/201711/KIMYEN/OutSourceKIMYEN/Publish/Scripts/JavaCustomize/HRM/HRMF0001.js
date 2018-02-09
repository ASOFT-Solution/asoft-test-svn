(function () {

    var closeButton = $("#Close").data("kendoButton") || $("#Close");

    closeButton.bind("click",
        function() {
            parent.ASOFT.asoftPopup.hideIframe();
        });

}())