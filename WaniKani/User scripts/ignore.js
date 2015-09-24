var debugLogEnabled = false;
var scriptShortName = "WKO";

scriptLog = debugLogEnabled ? function(msg) { if(typeof msg === 'string'){ console.log(scriptShortName + ": " + msg); }else{ console.log(msg); } } : function() {};

/*
 * Other settings
 */
var prefAllowUnignore = true;

/*
 * "Ignore Answer" Button Click
 */
var ActionEnum = Object.freeze({ ignore:0, unignore:1 });
var WKO_ignoreAnswer = function ()
{
  try
  {
    /* Check if the current item was answered incorrectly */
    var elmnts = document.getElementsByClassName("incorrect");
    var elmnts2 = document.getElementsByClassName("WKO_ignored");
    
    var curAction;
    if(!isEmpty(elmnts[0])) // Current answer is wrong
      curAction = ActionEnum.ignore;
    else if(prefAllowUnignore && !isEmpty(elmnts2[0])) // Current answer is ignored
      curAction = ActionEnum.unignore;
    else // Either there is no current answer, or it's correct
    {
      alert("WKO: Current item wasn't answered incorrectly, nor ignored previously!");
      return false;
    }
    
    /* Grab information about current question */
    var curItem = $.jStorage.get("currentItem");
    var questionType = $.jStorage.get("questionType");
    
    /* Build item name */
    var itemName;
    
    if(curItem.rad)
      itemName = "r";
    else if(curItem.kan)
      itemName = "k";
    else
      itemName = "v";
    
    itemName += curItem.id;
    scriptLog(itemName);
    
    /* Grab item from jStorage.
     *
     * item.rc and item.mc => Reading/Meaning Completed (if answered the item correctly)
     * item.ri and item.mi => Reading/Meaning Invalid (number of mistakes before answering correctly)
     */
    var item = $.jStorage.get(itemName) || {};
    
    /* Update the item data */
    if(questionType === "meaning")
	  	{
        if(!("mi" in item) || isEmpty(item.mi))
        {
          throw Error("item.mi undefined");
          return false;
        }
        else if(item.mi < 0 || (item.mi == 0 && curAction == ActionEnum.ignore))
        {
          throw Error("item.mi too small");
          return false;
        }
        
        if(curAction == ActionEnum.ignore)
          item.mi -= 1;
        else
          item.mi += 1;
        
        delete item.mc;
      }
    else
    {
      if(!("ri" in item) || isEmpty(item.ri))
      {
        throw Error("item.ri undefined");
        return false;
      }
      else if(item.ri < 0 || (item.ri == 0 && curAction == ActionEnum.ignore))
      {
        throw Error("i.ri too small");
        return false;
      }
      
      if(curAction == ActionEnum.ignore)
        item.ri -= 1;
      else
        item.ri += 1;
      
      delete item.rc;
    }
    
    /* Save the new state back into jStorage */
    $.jStorage.set(itemName, item);
    
    /* Modify the questions counter and wrong counter and change the style of the answer field */
    var wrongCount = $.jStorage.get("wrongCount");
    var questionCount = $.jStorage.get("questionCount");
    
    if(curAction == ActionEnum.ignore)
    {
      $.jStorage.set("wrongCount", wrongCount-1);
      $.jStorage.set("questionCount", questionCount-1);
      
      $("#answer-form fieldset").removeClass("incorrect");
      $("#answer-form fieldset").addClass("WKO_ignored");
    }
    else
    {
      $.jStorage.set("wrongCount", wrongCount+1);
      $.jStorage.set("questionCount", questionCount+1);
      
      $("#answer-form fieldset").removeClass("WKO_ignored");
      $("#answer-form fieldset").addClass("incorrect");
    }
    
    return true;
  }
  catch(err) { logError(err); }
}

/*
 * Inject Ignore Button
 */
function addIgnoreAnswerBtn()
{
  var fontSize = "30px";
  //get element
//  $('[lang="ja"], #user-response').css = $('[lang="ja"], #user-response').css + "font-size: 250%;";  //document.getElementById("character");
  //add style
  
  $("#additional-content ul").append('<li id="option-double-check"><span title="Change Result"><i class="icon-thumbs-up"></i></span></li>');
  $("#additional-content ul li").css("width", "16.2%"); //make space in the buttons row
  var customStyle = document.createElement("style");
  customStyle.innerHTML = "#answer-exception span:before {left: 40.5%}"; //get the arrow to point to the eye again
  document.head.appendChild(customStyle);
  
  $("#option-double-check").click(function(){
                                  WKO_ignoreAnswer();
                                  });
}

/*
 * Prepares the script
 */
function scriptInit()
{
  scriptLog("loaded");
  
  // Set up hooks
  try
  {
    addIgnoreAnswerBtn();
  }
  catch(err) { logError(err); }
}

/*
 * Helper Functions/Variables
 */

function isEmpty(value){
  return (typeof value === "undefined" || value === null);
}

/*
 * Error handling
 * Can use 'error.stack', not cross-browser (though it should work on Firefox and Chrome)
 */
function logError(error)
{
  var stackMessage = "";
  if("stack" in error)
    stackMessage = "\n\tStack: " + error.stack;
		
  console.error(scriptShortName + " Error: " + error.name + "\n\tMessage: " + error.message + stackMessage);
}

/*
 * Start the script
 */
scriptInit();


var buttonStyle = document.createElement("style");
buttonStyle.type = "text/css";
buttonStyle.innerHTML = "#WKO_button {background-color: #CC0000; color: #FFFFFF; cursor: pointer; display: inline-block; font-size: 0.8125em; padding: 10px; vertical-align: bottom;}";
document.getElementsByTagName("head")[0].appendChild(buttonStyle);

var barStyle = document.createElement("style");
barStyle.type = "text/css";
barStyle.innerHTML = "#answer-form fieldset.WKO_ignored input[type=\"text\"]:-moz-placeholder, #answer-form fieldset.WKO_ignored input[type=\"text\"]:-moz-placeholder {color: #FFFFFF; font-family: \"Source Sans Pro\",sans-serif; font-weight: 300; text-shadow: none; transition: color 0.15s linear 0s; } #answer-form fieldset.WKO_ignored button, #answer-form fieldset.WKO_ignored input[type=\"text\"], #answer-form fieldset.WKO_ignored input[type=\"text\"]:disabled { background-color: #FFCC00 !important; }";
document.getElementsByTagName("head")[0].appendChild(barStyle);

