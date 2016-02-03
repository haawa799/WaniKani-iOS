
$('#user-response').keydown( function(e) {
                            var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
                            
                            if (key == 13)
                            {
                            setTimeout(checkScore, 0);
                            setTimeout(checkAnswer, 0);
                            }
                            });


$('#answer-form button').on('click', function(e){
                            if (e.originalEvent !== undefined && e.originalEvent.screenX && e.originalEvent.screenY)
                            {
                            if($('#user-response').val())
                            {
                            setTimeout(checkScore, 0);
                            setTimeout(checkAnswer, 0);
                            }
                            }
                            });

var score = 0;

function checkScore()
{
  var value = document.getElementById('completed-count').textContent;
  var q = parseInt(value);
  if (q < score) {
    score += q;
  } else {
    score = q;
  }
}

function getScore() {
  return score;
}

var character = "";

function checkCharacter()
{
  var value = document.getElementById("character").getElementsByTagName("span")[0].innerHTML;
  character = value;
}

function getCharacter() {
  checkCharacter();
  return character;
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

//loginIfNeeded('usr','pswrd');