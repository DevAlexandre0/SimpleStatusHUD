$(function () {
    window.addEventListener("message", function (event) {
        if (typeof event.data.display !== "undefined") {
            event.data.display ? $(".ui").fadeIn() : $(".ui").fadeOut();
        }

        if (!event.data.pauseMenu && $(".ui").is(":visible")) {
            const stats = ["health", "armour", "stamina", "food", "water", "stress"];
            stats.forEach((stat) => {
                const value = Math.round(event.data[stat] || 0);
                $(`#${stat}-percent`).html(`${value}%`);
                $(`#${stat}-level`).css("width", `${value}%`);
            });
        }
    });
});
