
//function checkForKey() {
//	$.get('/account').done(function(data, textStatus, jqXHR) { 
//		var apiKey = findKey();
//		window.webkit.messageHandlers.notification.postMessage(apiKey)
//	});
//}

$.get('/account').done(function(data, textStatus, jqXHR) {
      var apiKey = findKeyInData(data);
      webkit.messageHandlers.apikey.postMessage(apiKey);
});

function findKeyInData(data)  {
	var apiKey = $(data).find('#api-button').parent().find('input').attr('value');
	if (apiKey == '') {
		apiKey = 'no';
	}
	return apiKey;
}

function findKey()  {
  var apiKey = $('#api-button').parent().find('input').attr('value');
  if (apiKey == '') {
    apiKey = 'no';
  }
  return apiKey;
}

function openSettings() {
	window.location.href = '/account';
}

function generateNewKey() {
	setTimeout(function() {
		$('#api-button').click();
	}, 1000);
}

//

function registerToGrabCredentials() {
  var submitButton = document.getElementsByClassName('button')[0];
  
  if(submitButton.type == 'submit') {
    
    submitButton.onclick = function(e) {
      
      var usr = document.getElementById('user_login').value;
      var psw = document.getElementById('user_password').value;
      var rememberMe = document.getElementById('user_remember_me');
      rememberMe.checked = true;
      
      window.webkit.messageHandlers.username.postMessage(usr)
      window.webkit.messageHandlers.password.postMessage(psw)
    };
  }
}

function loginIfNeeded(usr, psw) {
  var usrField = document.getElementById('user_login');
  var pswField = document.getElementById('user_password');
  var rememberMe = document.getElementById('user_remember_me');
  
  if (usrField != null, pswField != null, rememberMe != null) {
    rememberMe.checked = true;
    usrField.value = usr;
    pswField.value = psw;
    
    var submitButton = document.getElementsByClassName('button')[0];
    submitButton.click();
  }
}

registerToGrabCredentials();

