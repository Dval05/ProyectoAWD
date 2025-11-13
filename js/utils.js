// js/utils.js
function goHTML(relativeHtmlPath) {
    var match = window.location.pathname.match(/^(\/[^\/]+\/html\/)/);
    var base = match ? match[1] : '/html/';
    window.location.href = base + relativeHtmlPath;
}
// asegurar que sea global para onclick HTML:
window.goHTML = goHTML;
