//
// Copyright (c) 2009 Public Software Group e. V., Berlin
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

//
// All date calculations are based on the gregorian calender, also for
// dates before 1582 (before the gegorian calendar was introduced).
// The supported range is from January 1st 0001 up to December 31st 9999.
//
// gregor_daycount({year: <year>, month: <month>, day: <day>}) returns
// the number of days between the given date and January 1st 0001 (greg.).
//
// gregor_completeDate({year: <year>, month: <month>, day: <day>}) returns
// a structure (an object) with the following properties:
//   - daycount     (days since January 1st 0001, see gregor_daycount)
//   - year         (with century)
//   - month        (from 1 to 12)
//   - day          (from 1 to 28, 29, 30 or 31)
//   - iso_string   (string with format YYYY-MM-DD)
//   - us_weekday   (from 0 for Sunday to 6 for Monday)
//   - iso_weekday  (from 0 for Monday to 6 for Sunday)
//   - iso_weekyear (Year containing greater part of week st. w. Monday)
//   - iso_week     (from 1 to 52 or 53)
//   - us_week      (from 1 to 53 or 54)
//
// The structure (the object) passed as parameter to gregor_daycount or
// gregor_completeDate may describe a date in the following ways:
//   - daycount
//   - year, month, day
//   - year, us_week, us_weekday
//   - year, iso_week, iso_weekday
//   - iso_weekyear, iso_week, iso_weekday
//
// gregor_sheet({...}) returns a calendar sheet as DOM object. The
// structure (the object) passed to the function as an argument is altered
// by the function and used to store state variables. Initially it can
// contain the following fields:
//   - year            (year to show, defaults to todays year)
//   - month           (month to show, defaults to todays month)
//   - today           (structure describing a day, e.g. year, month, day)
//   - selected        (structure describing a day, e.g. year, month, day)
//   - navigation      ("enabled", "disabled", "hidden", default "enabled")
//   - week_mode       ("iso" or "us", defaults to "iso")
//   - week_numbers    ("left", "right" or null, defaults to null)
//   - month_names     (e.g. ["January", "Feburary", ...])
//   - weekday_names   (e.g. ["Mon", "Tue", ...] or ["Sun", "Mon", ...])
//   - day_callback    (function to render a cell)
//   - select_callback (function to be called, when a date was selected)
//   - element         (for internal use only)
// If "today" is undefined, it is automatically intitialized with the
// current clients date. If "selected" is undefined or null, no date is
// be initially selected. It is mandatory to provide month_names and
// weekday_names.
//
// gregor_addGui({...}) alters a referenced input field in a way that
// focussing on it causes a calendar being shown at its right side, where a
// date can be selected. The structure (the object) passed to this function
// is only evaluated once, and never modified. All options except "element"
// of the gregor_sheet({...}) function may be used as options to
// gregor_addGui({...}) as well. In addition an "element_id" must be
// provided as argument, containing the id of a text input field. The
// behaviour caused by the options "selected" and  "select_callback" are
// slightly different: If "selected" === undefined, then the current value
// of the text field referenced by "element_id" will be parsed and used as
// date selection. If "selected" === null, then no date will be initially
// selected, and the text field will be cleared. The "select_callback"
// function is always called once with the pre-selected date (or with null,
// if no date is initially selected). Whenever the selected date is changed
// or unselected later, the callback function is called again with the new
// date (or with null, in case of deselection). When the relaxed argument is set
// the calendar will not normalize the parsed date. Thats usefull if you wan't to
// allow relaxed input.
//
// EXAMPLE:
//
// <input type="text" id="test_field" name="test_field" value=""/>
// <script type="text/javascript">
//   gregor_addGui({
//     element_id: 'test_field',
//     month_names: [
//       "January", "February", "March", "April", "May", "June",
//       "July", "August", "September", "October", "November", "December"
//     ],
//     weekday_names: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
//     week_numbers: "left"
//   });
// </script>
//




// Internal constants and helper functions for date calculation


gregor_c1   = 365;                  // days of a non-leap year
gregor_c4   = 4 * gregor_c1 + 1;    // days of a full 4 year cycle
gregor_c100 = 25 * gregor_c4 - 1;   // days of a full 100 year cycle
gregor_c400 = 4 * gregor_c100 + 1;  // days of a full 400 year cycle

gregor_normalMonthOffsets = [
  0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365
];

function gregor_getMonthOffset(year, month) {
  if (
    (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) &&
    month > 2
  ) return gregor_normalMonthOffsets[month-1] + 1;
  else return gregor_normalMonthOffsets[month-1];
}

function gregor_formatInteger(int, digits) {
  var result = int.toFixed();
  if (digits != null) {
    while (result.length < digits) result = "0" + result;
  }
  return result;
}



// Calculate days since January 1st 0001 (Gegorian) for a given date


function gregor_daycount(obj) {
  if (
    obj.daycount >= 0 && obj.daycount <= 3652058 && obj.daycount % 1 == 0
  ) {
    return obj.daycount;
  } else if (
    obj.year >= 1 && obj.year <= 9999 && obj.year % 1 == 0 &&
    obj.month >= 1 && obj.month <= 12 && obj.month % 1 == 0 &&
    obj.day >= 0 && obj.day <= 31 && obj.day % 1 == 0
  ) {
    var n400 = Math.floor((obj.year-1) / 400);
    var r400 = (obj.year-1) % 400;
    var n100 = Math.floor(r400 / 100);
    var r100 = r400 % 100;
    var n4 = Math.floor(r100 / 4);
    var n1 = r100 % 4;
    return (
      gregor_c400 * n400 +
      gregor_c100 * n100 +
      gregor_c4   * n4   +
      gregor_c1   * n1   +
      gregor_getMonthOffset(obj.year, obj.month) + (obj.day - 1)
    );
  } else if (
    (
      (
        obj.year >= 1 && obj.year <= 9999 &&
        obj.year % 1 == 0 && obj.iso_weekyear == null
      ) || (
        obj.iso_weekyear >= 1 && obj.iso_weekyear <= 9999 &&
        obj.iso_weekyear % 1 == 0 && obj.year == null
      )
    ) &&
    obj.iso_week >= 0 && obj.iso_week <= 53 && obj.iso_week % 1 == 0 &&
    obj.iso_weekday >= 0 && obj.iso_weekday <= 6 &&
    obj.iso_weekday % 1 == 0
  ) {
    var jan4th = gregor_daycount({
      year:  (obj.year != null) ? obj.year : obj.iso_weekyear,
      month: 1,
      day:   4
    });
    var monday0 = jan4th - (jan4th % 7) - 7;  // monday of week 0
    return monday0 + 7 * obj.iso_week + obj.iso_weekday;
  } else if (
    obj.year >= 1 && obj.year <= 9999 && obj.year % 1 == 0 &&
    obj.us_week >= 0 && obj.us_week <= 54 && obj.us_week % 1 == 0 &&
    obj.us_weekday >= 0 && obj.us_weekday <= 6 && obj.us_weekday % 1 == 0
  ) {
    var jan1st = gregor_daycount({
      year:  obj.year,
      month: 1,
      day:   1
    });
    var sunday0 = jan1st - ((jan1st+1) % 7) - 7;  // sunday of week 0
    return sunday0 + 7 * obj.us_week + obj.us_weekday;
  }
}



// Calculate all calendar related numbers for a given date


function gregor_completeDate(obj) {
  if (
    obj.daycount >= 0 && obj.daycount <= 3652058 && obj.daycount % 1 == 0
  ) {
    var daycount = obj.daycount;
    var n400 = Math.floor(daycount / gregor_c400);
    var r400 = daycount % gregor_c400;
    var n100 = Math.floor(r400 / gregor_c100);
    var r100 = r400 % gregor_c100;
    if (n100 == 4) { n100 = 3; r100 = gregor_c100; }
    var n4 = Math.floor(r100 / gregor_c4);
    var r4 = r100 % gregor_c4;
    var n1 = Math.floor(r4 / gregor_c1);
    var r1 = r4 % gregor_c1;
    if (n1 == 4) { n1 = 3; r1 = gregor_c1; }
    var year = 1 + 400 * n400 + 100 * n100 + 4 * n4 + n1;
    var month = 1 + Math.floor(r1 / 31);
    var monthOffset = gregor_getMonthOffset(year, month);
    if (month < 12) {
      var nextMonthOffset = gregor_getMonthOffset(year, month + 1);
      if (r1 >= nextMonthOffset) {
        month++;
        monthOffset = nextMonthOffset;
      }
    }
    var day = 1 + r1 - monthOffset;
    var iso_string = ("" +
      gregor_formatInteger(year, 4) + "-" +
      gregor_formatInteger(month, 2) + "-" +
      gregor_formatInteger(day, 2)
    );
    var us_weekday = (daycount+1) % 7;
    var iso_weekday = daycount % 7;
    var iso_weekyear = year;
    if (
      month == 1 && (
        (day == 3 && iso_weekday == 6) ||
        (day == 2 && iso_weekday >= 5) ||
        (day == 1 && iso_weekday >= 4)
      )
    ) iso_weekyear--;
    else if (
      month == 12 && (
        (day == 29 && iso_weekday == 0) ||
        (day == 30 && iso_weekday <= 1) ||
        (day == 31 && iso_weekday <= 2)
      )
    ) iso_weekyear++;
    var jan4th = gregor_daycount({year: iso_weekyear, month: 1, day: 4});
    var monday0 = jan4th - (jan4th % 7) - 7;  // monday of week 0
    var iso_week = Math.floor((daycount - monday0) / 7);
    var jan1st = gregor_daycount({year: year, month: 1, day: 1});
    var sunday0 = jan1st - ((jan1st+1) % 7) - 7;  // sunday of week 0
    var us_week = Math.floor((daycount - sunday0) / 7);
    return {
      daycount:     daycount,
      year:         year,
      month:        month,
      day:          day,
      iso_string:   iso_string,
      us_weekday:   (daycount+1) % 7,  // 0 = Sunday
      iso_weekday:  daycount % 7,      // 0 = Monday
      iso_weekyear: iso_weekyear,
      iso_week:     iso_week,
      us_week:      us_week
    };
  } else if (obj.daycount == null) {
    var daycount = gregor_daycount(obj);
    if (daycount != null) {
      return gregor_completeDate({daycount: gregor_daycount(obj)});
    }
  }
}



// Test gregor_daycount and gregor_completeDate for consistency
// (Debugging only)


function gregor_test() {
  for (i=650000; i<900000; i++) {
    var obj = gregor_completeDate({daycount: i});
    var j;
    j = gregor_daycount({
      year: obj.year,
      month: obj.month,
      day: obj.day
    });
    if (i != j) { alert("ERROR"); return; }
    j = gregor_daycount({
      iso_weekyear: obj.iso_weekyear,
      iso_week:     obj.iso_week,
      iso_weekday:  obj.iso_weekday
    });
    if (i != j) { alert("ERROR"); return; }
    j = gregor_daycount({
      year: obj.year,
      iso_week:
        (obj.iso_weekyear == obj.year + 1) ? 53 :
        (obj.iso_weekyear == obj.year - 1) ? 0 :
        obj.iso_week,
      iso_weekday: obj.iso_weekday
    });
    if (i != j) { alert("ERROR"); return; }
    j = gregor_daycount({
      year: obj.year,
      us_week: obj.us_week,
      us_weekday: obj.us_weekday
    });
    if (i != j) { alert("ERROR"); return; }
  }
  alert("SUCCESS");
}



// Graphical calendar


gregor_iso_weekday_css = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

function gregor_sheet(args) {

  // setting args.today and args.selected
  if (args.today === undefined) {
    var js_date = new Date();
    args.today = gregor_completeDate({
      year:  js_date.getFullYear(),
      month: js_date.getMonth() + 1,
      day:   js_date.getDate()
    });
  } else if (args.today != null) {
    args.today = gregor_completeDate(args.today);
  }
  if (args.selected == "today") {
    args.selected = args.today;
  } else if (args.selected != null) {
    args.selected = gregor_completeDate(args.selected);
  }

  // setting args.year and args.month
  if (args.year == null) {
    if (args.selected != null) args.year = args.selected.year;
    else args.year = args.today.year;
  }
  if (args.month == null) {
    if (args.selected != null) args.month = args.selected.month;
    else args.month = args.today.month;
  }

  // setting first_day
  var first_day = gregor_completeDate({
    year:  args.year,
    month: args.month,
    day: 1
  });
  if (first_day == null) return;

  // checking args.navigation, args.week_mode and args.week_numbers
  if (args.navigation == null) args.navigation = "enabled";
  else if (
    args.navigation != "enabled" &&
    args.navigation != "disabled" &&
    args.navigation != "hidden"
  ) return;
  if (args.week_mode == null) args.week_mode = "iso";
  else if (args.week_mode != "iso" && args.week_mode != "us") return;
  if (
    args.week_numbers != null &&
    args.week_numbers != "left" &&
    args.week_numbers != "right"
  ) return;

  // checking args.month.names and args.weekday_names
  if (args.month_names.length != 12) return;
  if (args.weekday_names.length != 7) return;

  // calculating number of days in month
  var count;
  if (args.year < 9999 || args.month < 12) {
    count = gregor_daycount({
      year:  (args.month == 12) ? (args.year + 1) : args.year,
      month: (args.month == 12) ? 1 : (args.month + 1),
      day:   1
    }) - first_day.daycount;
  } else {
    // workaround for year 9999
    count = 31;
  }

  // locale variables for UI construction
  var table, row, cell, element;

  // take table element from args.element,
  // if neccessary create and store it
  if (args.element == null) {
    table = document.createElement("table");
    args.element = table;
  } else {
    table = args.element;
    while (table.firstChild) table.removeChild(table.firstChild);
  }

  // set CSS class of table according to args.week_numbers
  if (args.week_numbers == "left") {
    table.className = "gregor_sheet gregor_weeks_left";
  } else if (args.week_numbers == "right") {
    table.className = "gregor_sheet gregor_weeks_right";
  } else {
    table.className = "gregor_sheet gregor_weeks_none";
  }

  // begin of table head
  var thead = document.createElement("thead");

  // navigation
  if (args.navigation != "hidden") {

    // UI head row containing the year
    row = document.createElement("tr");
    row.className = "gregor_year_row";
    cell = document.createElement("th");
    cell.className = "gregor_year";
    cell.colSpan = args.week_numbers ? 8 : 7;
    if (args.navigation == "enabled") {
      element = document.createElement("a");
      element.className = "gregor_turn gregor_turn_left";
      element.style.cssFloat   = "left";
      element.style.styleFloat = "left";
      element.href = "#";
      element.onclick = function() {
        if (args.year > 1) args.year--;
        gregor_sheet(args);
        return false;
      }
      element.ondblclick = element.onclick;
      element.appendChild(document.createTextNode("<<"));
      cell.appendChild(element);
      element = document.createElement("a");
      element.className = "gregor_turn gregor_turn_right";
      element.style.cssFloat   = "right";
      element.style.styleFloat = "right";
      element.href = "#";
      element.onclick = function() {
        if (args.year < 9999) args.year++;
        gregor_sheet(args);
        return false;
      }
      element.ondblclick = element.onclick;
      element.appendChild(document.createTextNode(">>"));
      cell.appendChild(element);
    }
    cell.appendChild(document.createTextNode(first_day.year));
    row.appendChild(cell);
    thead.appendChild(row);

    // UI head row containing the month
    row = document.createElement("tr");
    row.className = "gregor_month_row";
    cell = document.createElement("th");
    cell.className = "gregor_month";
    cell.colSpan = args.week_numbers ? 8 : 7;
    if (args.navigation == "enabled") {
      element = document.createElement("a");
      element.className = "gregor_turn gregor_turn_left";
      element.style.cssFloat   = "left";
      element.style.styleFloat = "left";
      element.href = "#";
      element.onclick = function() {
        if (args.year > 1 || args.month > 1) {
          args.month--;
          if (args.month < 1) {
            args.month = 12;
            args.year--;
          }
        }
        gregor_sheet(args);
        return false;
      }
      element.ondblclick = element.onclick;
      element.appendChild(document.createTextNode("<<"));
      cell.appendChild(element);
      element = document.createElement("a");
      element.className = "gregor_turn gregor_turn_right";
      element.style.cssFloat   = "right";
      element.style.styleFloat = "right";
      element.href = "#";
      element.onclick = function() {
        if (args.year < 9999 || args.month < 12) {
          args.month++;
          if (args.month > 12) {
            args.month = 1;
            args.year++;
          }
        }
        gregor_sheet(args);
        return false;
      }
      element.ondblclick = element.onclick;
      element.appendChild(document.createTextNode(">>"));
      cell.appendChild(element);
    }
    cell.appendChild(document.createTextNode(
      args.month_names[first_day.month-1]
    ));
    row.appendChild(cell);
    thead.appendChild(row);

  // end of navigation
  }

  // UI weekday row
  row = document.createElement("tr");
  row.className = "gregor_weekday_row";
  if (args.week_numbers == "left") {
    cell = document.createElement("th");
    cell.className = "gregor_corner";
    row.appendChild(cell);
  }
  for (var i=0; i<7; i++) {
    cell = document.createElement("th");
    cell.className = (
      "gregor_weekday gregor_" +
      gregor_iso_weekday_css[(args.week_mode == "us") ? ((i+6)%7) : i]
    );
    cell.appendChild(document.createTextNode(args.weekday_names[i]));
    row.appendChild(cell);
  }
  if (args.week_numbers == "right") {
    cell = document.createElement("th");
    cell.className = "gregor_corner";
    row.appendChild(cell);
  }
  thead.appendChild(row);

  // end of table head and begin of table body
  table.appendChild(thead);
  var tbody = document.createElement("tbody");

  // definition of insert_week function
  var week = (
    (args.week_mode == "us") ? first_day.us_week : first_day.iso_week
  );
  insert_week = function() {
    cell = document.createElement("th");
    cell.className = "gregor_week";
    cell.appendChild(document.createTextNode(
      (week < 10) ? ("0" + week) : week)
    );
    week++;
    if (
      args.week_mode == "iso" && (
        (
          args.month == 1 && week > 52
        ) || (
          args.month == 12 && week == 53 && (
            first_day.iso_weekday == 0 ||
            first_day.iso_weekday == 5 ||
            first_day.iso_weekday == 6
          )
        )
      )
    ) week = 1;
    row.appendChild(cell);
  }

  // output data fields
  row = document.createElement("tr");
  if (args.week_numbers == "left") insert_week();
  var filler_count = (
    (args.week_mode == "us") ? first_day.us_weekday : first_day.iso_weekday
  );
  for (var i=0; i<filler_count; i++) {
    cell = document.createElement("td");
    cell.className = "gregor_empty";
    row.appendChild(cell);
  }
  for (var i=0; i<count; i++) {
    var date = gregor_completeDate({daycount: first_day.daycount + i});
    if (row == null) {
      row = document.createElement("tr");
      if (args.week_numbers == "left") insert_week();
    }
    cell = document.createElement("td");
    var cssClass = (
      "gregor_day gregor_" + gregor_iso_weekday_css[date.iso_weekday]
    );
    if (args.today != null && date.daycount == args.today.daycount) {
      cssClass += " gregor_today";
    }
    if (args.selected != null && date.daycount == args.selected.daycount) {
      cssClass += " gregor_selected";
    }
    cell.className = cssClass;
    if (args.day_callback) {
      args.day_callback(cell, date);
    } else {
      element = document.createElement("a");
      element.href = "#";
      var generate_onclick = function(date) {
        return function() {
          args.selected = date;
          gregor_sheet(args);
          if (args.select_callback != null) {
            args.select_callback(date);
          }
          return false;
        }
      }
      element.onclick = generate_onclick(date);
      element.ondblclick = element.onclick;
      element.appendChild(document.createTextNode(first_day.day + i));
      cell.appendChild(element);
    }
    row.appendChild(cell);
    if (row.childNodes.length == ((args.week_numbers == "left") ? 8 : 7)) {
      if (args.week_numbers == "right") insert_week();
      tbody.appendChild(row);
      row = null;
    }
  }
  if (row != null) {
    while (row.childNodes.length < ((args.week_numbers == "left") ? 8 : 7)) {
      cell = document.createElement("td");
      cell.className = "gregor_empty";
      row.appendChild(cell);
    }
    if (args.week_numbers == "right") insert_week();
    tbody.appendChild(row);
  }

  // end of table body
  table.appendChild(tbody);

  // return table
  return table;
}



// Rich form field support


function gregor_getAbsoluteLeft(elem) {
 var result = 0;
 while (elem && elem.style.position != "static") {
  result += elem.offsetLeft;
  elem = elem.offsetParent;
 }
 return result;
}

function gregor_getAbsoluteTop(elem) {
 var result = 0;
 while (elem && elem.style.position != "static") {
  result += elem.offsetTop;
  elem = elem.offsetParent;
 }
 return result;
}

function gregor_formatDate(format, date) {
  if (date == null) return "";
  var result = format;
  result = result.replace(/Y+/, function(s) {
    if (s.length == 2) return gregor_formatInteger(date.year % 100, 2);
    else return gregor_formatInteger(date.year, s.length);
  });
  result = result.replace(/M+/, function(s) {
    return gregor_formatInteger(date.month, s.length);
  });
  result = result.replace(/D+/, function(s) {
    return gregor_formatInteger(date.day, s.length);
  });
  return result;
}

function gregor_map2digitYear(y2, maxYear) {
  var guess = Math.floor(maxYear / 100) * 100 + y2;
  if (guess <= maxYear) return guess;
  else return guess - 100;
}

function gregor_parseDate(format, string, terminated, maxYear) {
  var numericParts, formatParts;
  numericParts = string.match(/^\s*([0-9]{4})-([0-9]{2})-([0-9]{2})\s*$/);
  if (numericParts != null) {
    return gregor_completeDate({
      year:  numericParts[1],
      month: numericParts[2],
      day:   numericParts[3]
    });
  }
  numericParts = string.match(/[0-9]+/g);
  if (numericParts == null) return null;
  formatParts = format.match(/[YMD]+/g);
  if (numericParts.length != formatParts.length) return null;
  if (
    !terminated && (
      numericParts[numericParts.length-1].length <
      formatParts[formatParts.length-1].length
    )
  ) return null;
  var year, month, day;
  for (var i=0; i<numericParts.length; i++) {
    var numericPart = numericParts[i];
    var formatPart = formatParts[i];
    if (formatPart.match(/^Y+$/)) {
      if (numericPart.length == 2 && maxYear != null) {
        year = gregor_map2digitYear(parseInt(numericPart, 10), maxYear);
      } else if (numericPart.length > 2) {
        year = parseInt(numericPart, 10);
      }
    } else if (formatPart.match(/^M+$/)) {
      month = parseInt(numericPart, 10);
    } else if (formatPart.match(/^D+$/)) {
      day = parseInt(numericPart, 10);
    } else {
      //alert("Not implemented.");
      return null;
    }
  }
  return gregor_completeDate({year: year, month: month, day: day});
}

function gregor_addGui(args) {

  // copy argument structure
  var state = {};
  for (key in args) state[key] = args[key];

  // unset state.element, which should never be set anyway
  state.element = null;

  // save original values of "year" and "month" options
  var original_year = state.year;
  var original_month = state.month;

  // get text field element
  var element = document.getElementById(state.element_id);
  state.element_id = null;

  // setup state.today, state.selected and state.format options
  if (state.today === undefined) {
    var js_date = new Date();
    state.today = gregor_completeDate({
      year:  js_date.getFullYear(),
      month: js_date.getMonth() + 1,
      day:   js_date.getDate()
    });
  } else if (state.today != null) {
    state.today = gregor_completeDate(args.today);
  }
  if (state.selected == "today") {
    state.selected = state.today;
  } else if (args.selected != null) {
    state.selected = gregor_completeDate(state.selected);
  }
  if (state.format == null) state.format = "YYYY-MM-DD";

  // using state.future to calculate maxYear (for 2 digit year conversions)
  var maxYear = (state.today == null) ? null : (
    state.today.year +
    ((state.future == null) ? 12 : state.future)
  );

  // hook into state.select_callback
  var select_callback = state.select_callback;
  state.select_callback = function(date) {
    element.value = gregor_formatDate(state.format, date);
    if (select_callback) select_callback(date);
  };
  // function to parse text field and update calendar sheet state
  var updateSheet = function(terminated) {
    var date = gregor_parseDate(
      state.format, element.value, terminated, maxYear
    );
    if (date) {
      state.year = null;
      state.month = null;
    }
    state.selected = date;
    gregor_sheet(state);
  };

  // Initial synchronization
  if (state.selected === undefined) updateSheet(true);
  if (!state.relaxed)
    element.value = gregor_formatDate(state.format, state.selected);

  if (select_callback) select_callback(state.selected);

  // variables storing popup status
  var visible = false;
  var focus = false;
  var protection = false;

  // event handlers for text field
  element.onfocus = function() {
    focus = true;
    if (!visible) {
      state.year = original_year;
      state.month = original_month;
      gregor_sheet(state);
      state.element.style.position = "absolute";
      state.element.style.top = gregor_getAbsoluteTop(element) + element.offsetHeight;
      state.element.style.left = gregor_getAbsoluteLeft(element);
      state.element.onmousedown = function() {
        protection = true;
      };
      state.element.onmouseup = function() {
        protection = false;
        element.focus();
      };
      state.element.onmouseout = state.element.onmouseup;
      element.parentNode.appendChild(state.element);
      visible = true;
    }
  };
  element.onblur = function() {
    focus = false;
    window.setTimeout(function() {
      if (visible && !focus && !protection) {
        updateSheet(true);
        if(!state.relaxed)
          element.value = gregor_formatDate(state.format, state.selected);
        if (select_callback) select_callback(state.selected);
        state.element.parentNode.removeChild(state.element);
        visible = false;
        protection = false;
      }
    }, 1);
  };
  element.onkeyup = function() {
    updateSheet(false);
    if (select_callback) select_callback(state.selected);
  };

}

