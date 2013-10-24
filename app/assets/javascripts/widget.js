function redirectToAskWidget(window) {
  window.location = "/ask_widget"
}

function delayedRedirect(window) {
  window.setTimeout('redirectToAskWidget', 3000);
}
