// js/config.js
// Define la clave del token siempre de forma global
const TOKEN_KEY = "authToken";

function getBaseApiPath() {
    // Busca "/php" en el path actual y corta desde ahí (funciona en todas las páginas)
    var path = window.location.pathname;
    var idx = path.indexOf("/php");
    if(idx !== -1) {
        return path.substring(0, idx+4); // +4 para incluir '/php'
    }
    // Si no existe /php en la ruta, toma el primer segmento como root de proyecto
    var parts = path.split('/');
    // Use uppercase 'PHP' directory which matches the repository layout
    return '/' + (parts[1] || '') + '/PHP';
}

var API_BASE_URL = getBaseApiPath();
