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

var score;

function checkScore()
{
  score = document.getElementById('completed-count').textContent;
}

function getScore() {
  return score;
}