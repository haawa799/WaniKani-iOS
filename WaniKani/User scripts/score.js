
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