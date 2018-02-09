/**
 * Lê Thành Luân create
 */
"use strict";

// Create a AsoftButton
class Button {
    constructor(buttonName, buttonID, buttonClass, clickEvent = null) {
        this.buttonName = buttonName;
        this.buttonID = buttonID;
        this.clickEvent = clickEvent;
        this.buttonClass = buttonClass;
    }

    createButton() {
        const newButton = document.createElement("button");
        newButton.className = this.buttonClass;
        newButton.id = this.buttonID;
        newButton.name = this.buttonName;

        const span = document.createElement("span");
        span.innerText = "...";
        span.className = "asf-button-text";
        newButton.appendChild(span);

        if (this.clickEvent && typeof this.clickEvent === "function") {
            newButton.onclick = this.clickEvent;
        }

        const result = {};
        result.getHtmlButton = function () { return newButton };

        return result;
    }

    static asoftButton(buttonName, buttonID, buttonClass, clickEvent = null) {
        return new AsoftButton(buttonName, buttonID, buttonClass, clickEvent);
    }
}


class AsoftButton extends Button {
    constructor(buttonName, buttonID, buttonClass, clickEvent = null) {
        super(buttonName, buttonID, buttonClass, clickEvent);
    }

    createDeleteButton() {
        const newAsoftButton = document.createElement("button");
        newAsoftButton.id = this.buttonID;
        newAsoftButton.className = "k-sprite asf-icon asf-icon-32 asf-i-delete-32";
        const span = document.createElement("span");
        span.className = "asf-button-text";

        newAsoftButton.appendChild(span);
        
        if (this.clickEvent && typeof this.clickEvent === "function") {
            newAsoftButton.onclick = this.clickEvent;
        }

        const result = {};
        result.getHtmlButton = function () { return newAsoftButton };

        return result;
    }
}

// Export ra để cho file khác sử dụng 
define(function () {
    return {
        Button
    }
});