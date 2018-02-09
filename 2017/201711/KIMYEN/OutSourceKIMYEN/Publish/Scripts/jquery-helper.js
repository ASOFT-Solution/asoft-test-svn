var JQUERY = [];

JQUERY.helper = new function () {
    this.checkNumberic = function (element) {
        var regex = new RegExp(/^[0-9]/);
        var mumberElement = $('#' + element);
        mumberElement.keypress(function (e) {
            var keyValue = String.fromCharCode(e.charCode);
            if (!regex.test(keyValue)) {
                if (e.preventDefault) e.preventDefault();
                return false;
            }
        });
    }
}