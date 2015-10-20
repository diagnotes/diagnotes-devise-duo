$(document).ready(function() {
  $('a#duo-request-sms-link').unbind('ajax:success');
  $('a#duo-request-sms-link').bind('ajax:success', function(evt, data, status, xhr) {
    alert(data.message);
  });
});

