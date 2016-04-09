//var fontSize = "QQ";
//
////get element
//var charDiv = document.getElementById("character");
////add style
//
//alert(charDiv.className);
//
//if (charDiv.className == "vocabulary") {
//  charDiv.style.fontSize = fontSize + "px";
//}
//
//charDiv.style.fontSize = fontSize + "px";

// HHH - Height
// WWW - Width
// FFF - Font scale

var characterStyle = document.createElement("style");
characterStyle.type = "text/css";
characterStyle.innerHTML = "div#character {vertical-align: middle;text-align: center;} div.vocabulary span {font-size: FFF%;height: HHHpx;width: WWWpx;display:table-cell;  vertical-align: middle;  text-align: center;} div.kanji span {font-size: FFF%;height: HHHpx;width: WWWpx;display:table-cell;  vertical-align: middle;  text-align: center;} div.radical span {font-size: FFF%;height: HHHpx;width: WWWpx;display:table-cell;  vertical-align: middle;  text-align: center;}  #question #character.vocabulary {line-height: 0;}";
document.getElementsByTagName("head")[0].appendChild(characterStyle);