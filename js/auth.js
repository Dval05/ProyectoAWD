function getToken() { return localStorage.getItem(TOKEN_KEY); }
function isLoggedIn() { return !!getToken(); }
function requireAuth() { if(!isLoggedIn()) window.location.href="login.html"; }
function logout() {
  localStorage.clear();
  window.location.href="login.html";
}
$(document).on('click', '#logoutBtn', logout);

// On page load try to populate any #userName elements from localStorage.
// This allows the topbar to show the logged-in user's name immediately after login.
$(document).ready(function() {
  try {
    var storedName = localStorage.getItem('userName');
    if (storedName && storedName.trim() !== '') {
      // If multiple pages include an element with id userName, update them.
      var el = document.getElementById('userName');
      if (el) el.textContent = storedName;
    }
  } catch (e) {
    // Ignore storage access errors (e.g., private mode) — leave default UI text
    console.warn('auth.js: could not read userName from localStorage', e);
  }
});
