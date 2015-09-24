

$('#user-response').keydown( function(e) {
                            var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;

                            if (key == 13)
                            {
                            setTimeout(checkAnswer, 0);
                            }
                            });


$('#answer-form button').on('click', function(e){
                            if (e.originalEvent !== undefined && e.originalEvent.screenX && e.originalEvent.screenY)
                            {
                              if($('#user-response').val())
                              {
                                setTimeout(checkAnswer, 0);
                              }
                            }
                            });

function moveNext()
{
  $('#answer-form button').trigger('click');
}

var wki_exception_message_received = true;
var wki_exception_message_type = 0;
var wki_audio_autoplay = $("#wki_settings_audio_autoplay").is(":checked") ? true : false;

function checkAnswer()
{
    var answer = $('#user-response').val();

    if(!answer)
    {
      return false;
    }

    var answerException = $.trim($('#answer-exception').text());

    if(answerException.indexOf('WaniKani is looking for the') !== -1)
    {
      return false;
    }

    if(answerException.length > 0)
    {
      wki_exception_message_received = true;
      if(answerException.indexOf('answer was a bit off') !== -1)
      {
        //window.webkit.messageHandlers.interOp.postMessage('WKI: [answerException] your answer was a bit off');
        $('#wki_mimic_button').css('background-color', '#F5F7AB'); // yellow
        $('#wki_button i').removeClass().addClass('icon-warning-sign').fadeOut().fadeIn().fadeOut().fadeIn();
        wki_exception_message_type = 1;
      } else if(answerException.indexOf('possible readings') !== -1) {
        //window.webkit.messageHandlers.interOp.postMessage('WKI: [answerException] other possible readings');
        $('#wki_button i').removeClass().addClass('icon-asterisk');
        $('#wki_mimic_button').css('background-color', '#CDE0F7'); // blue
        wki_exception_message_type = 2;
      } else if(answerException.indexOf('possible meanings') !== -1)
      {
        //window.webkit.messageHandlers.interOp.postMessage('WKI: [answerException] other possible meanings');
        $('#wki_button i').removeClass().addClass('icon-asterisk');
        $('#wki_mimic_button').css('background-color', '#CDE0F7'); // blue
        wki_exception_message_type = 3;
      } else if(answerException.indexOf('View the correct') !== -1)
      {
        //window.webkit.messageHandlers.interOp.postMessage('WKI: [answerException] wrong answer');
        $('#wki_mimic_button').css('background-color', '#FBFBFB'); // default grey color
        $('#option-item-info').click();

        wki_exception_message_type = 0;
      } else
      {
        // unknown message
        //window.webkit.messageHandlers.interOp.postMessage('WKI: [answerException] ' + answerException);
        $('#wki_button i').removeClass().addClass('icon-info-sign');
        $('#wki_mimic_button').css('background-color', '#F7D4CD'); // red
        wki_exception_message_type = 0;
      }
    } else {
      wki_exception_message_received = false;
      $('#wki_button i').removeClass().addClass('icon-ok');
      $('#wki_mimic_button').css('background-color', '#FBFBFB'); // default grey color
    }


    if ($('#answer-form form fieldset').hasClass('correct'))
    {
      //window.webkit.messageHandlers.interOp.postMessage('WKI: Correct answer');

      if (wki_audio_autoplay === true)
      {
        if ($('#option-audio').hasClass('disabled'))
        {
          moveNext();
        }
        else
        {
          $("#option-audio").click();

          $('#option-audio audio').bind("ended", function () {
                                        moveNext();
                                        });
        }
      }
      else
      {
        moveNext();
      }
    }
    else if ($('#answer-form form fieldset').hasClass('incorrect'))
    {
      //window.webkit.messageHandlers.interOp.postMessage('WKI: Wrong answer');
    }

}