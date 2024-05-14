// Step 1
//Create an Excel sheet that contains a column for student numbers and a column for each assessment mark.
//Insert a blank column to the right of each assessment column.

// Step 2
//Paste the following calculation into the first cell of the blank column and ensure that $C2 corresponds to the student # column and D2 corresponds to the student's mark column.
//Copy this calculation down for each student.

//=SUBSTITUTE(SUBSTITUTE("Cambrian_CustomScript_EnterMoodleMarks('STUDENTNUMBERHERE','MARKHERE');","STUDENTNUMBERHERE",SUBSTITUTE(SUBSTITUTE($C2," ",""),"a","A")),"MARKHERE",SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(D2,"-","")," ",""),"%",""))

// Step 3
// Navigate to the eGrades page for the assessment, press F12, paste the following code into the console, and press enter.

function Cambrian_CustomScript_EnterMoodleMarks(studentnumber, mark) {
    try {
        var textboxGradeReleaseDate = document.getElementById("txtGradeReleaseDate");
        if (textboxGradeReleaseDate.value === "") {
            //textboxGradeReleaseDate.value = "08/11/2019"; //Optional
        }

        if (studentnumber.length > 5) {
            if (mark === "") {
                mark = "0";
            }

            mark = mark.replace(".00", "");

            if (!mark.indexOf('-') >= 0 && studentnumber.length > 1) {
                var textbox = document.getElementById("txt" + studentnumber);
                var commentbox = document.getElementById("txtComment" + studentnumber);

                if (textbox.value === mark) {
                    textbox.style.backgroundColor = "green";
                }
                else {
                    textbox.style.backgroundColor = "blue";
                    //commentbox.value = 'Comment here.'; //Optional comment.
                    var newtd = document.createElement('td');
                    var markdiff = parseFloat(mark) - parseFloat(textbox.value);
                    newtd.appendChild(document.createTextNode('Old:' + textbox.value + ' [' + markdiff.toFixed(2) + ']'));
                    textbox.parentElement.parentElement.appendChild(newtd);
                    textbox.value = mark;
                }
            }
        }
    } catch
    {
    }
}

// Step 4
//Copy all the rows from the appropriate mark column (the one you inserted the calculation into), paste it into the console, and press enter.

// Step 5
//Repeat steps 3 and 4 for all assessments.
