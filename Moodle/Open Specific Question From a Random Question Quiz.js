// Step 1
//Open the Moodle Quiz marks page.
//Change the QuestionName variable below to text that appears on the question popup page.
//Press F2 and paste the following code into the console window.

var Cambrian_CustomScript_QuestionName = "Describe the order of";

$('.grades a[href*="/mod/quiz/reviewquestion.php?"]').each(function () {
  if ($(this).find('span[class*="partiallycorrect"]').length > 0 || $(this).find('span[class*="incorrect"]').length > 0) {
    $.get(this.href, function (data) {
      if (data.indexOf(Cambrian_CustomScript_QuestionName) >= 0) {

        $(this).parent().css('background-color', 'lightgreen');
        window.open(this.url, '_blank');
        console.log(this.url);
      }
    });
  }
});