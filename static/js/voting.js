jsProtect(function() {
  voting_text_approval_single               = "Approval"
  voting_text_approval_multi                = "Approval"
  voting_text_first_preference_single       = "Approval (first preference)"
  voting_text_first_preference_multi        = "Approval (first preference)"
  voting_text_second_preference_single      = "Approval (second preference)"
  voting_text_second_preference_multi       = "Approval (second preference)"
  voting_text_third_preference_single       = "Approval (third preference)"
  voting_text_third_preference_multi        = "Approval (third preference)"
  voting_text_numeric_preference_single     = "Approval (#th preference)"
  voting_text_numeric_preference_multi      = "Approval (#th preference)"
  voting_text_abstention_single             = "Abstention"
  voting_text_abstention_multi              = "Abstention"
  voting_text_disapproval_above_one_single  = "Disapproval (prefer to lower block)"
  voting_text_disapproval_above_one_multi   = "Disapproval (prefer to lower block)"
  voting_text_disapproval_above_many_single = "Disapproval (prefer to lower blocks)"
  voting_text_disapproval_above_many_multi  = "Disapproval (prefer to lower blocks)"
  voting_text_disapproval_above_last_single = "Disapproval (prefer to last block)"
  voting_text_disapproval_above_last_multi  = "Disapproval (prefer to last block)"
  voting_text_disapproval_single            = "Disapproval"
  voting_text_disapproval_multi             = "Disapproval"

  function voting_setCategoryHeadings() {
    var approvalCount = 0;
    var disapprovalCount = 0;
    var sections = document.getElementById("voting").childNodes;
    for (var i=0; i<sections.length; i++) {
      var section = sections[i];
      if (section.className == "approval")       approvalCount++;
      if (section.className == "disapproval") disapprovalCount++;
    }
    var approvalIndex = 0;
    var disapprovalIndex = 0;
    for (var i=0; i<sections.length; i++) {
      var section = sections[i];
      if (
        section.className == "approval" ||
        section.className == "abstention" ||
        section.className == "disapproval"
      ) {
        var setHeading = function(heading) {
          var headingNodes = section.childNodes;
          for (var j=0; j<headingNodes.length; j++) {
            var headingNode = headingNodes[j];
            if (headingNode.className == "cathead") {
              headingNode.textContent = heading;
            }
          }
        }
        var count = 0;
        var entries = section.childNodes;
        for (var j=0; j<entries.length; j++) {
          var entry = entries[j];
          if (entry.className == "movable") count++;
        }
        if (section.className == "approval") {
          if (approvalCount > 1) {
            if (approvalIndex == 0) {
              if (count == 1) setHeading(voting_text_first_preference_single);
              else setHeading(voting_text_first_preference_multi);
            } else if (approvalIndex == 1) {
              if (count == 1) setHeading(voting_text_second_preference_single);
              else setHeading(voting_text_second_preference_multi);
            } else if (approvalIndex == 2) {
              if (count == 1) setHeading(voting_text_third_preference_single);
              else setHeading(voting_text_third_preference_multi);
            } else {
              var text;
              if (count == 1) text = voting_text_numeric_preference_single;
              else text = voting_text_numeric_preference_multi;
              text = text.replace(/#/, "" + (approvalIndex + 1))
              setHeading(text);
            }
          } else {
            if (count == 1) setHeading(voting_text_approval_single);
            else setHeading(voting_text_approval_multi);
          }
          approvalIndex++;
        } else if (section.className == "abstention") {
          if (count == 1) setHeading(voting_text_abstention_single);
          else setHeading(voting_text_abstention_multi);
        } else if (section.className == "disapproval") {
          if (disapprovalCount > disapprovalIndex + 2) {
            if (count == 1) setHeading(voting_text_disapproval_above_many_single);
            else setHeading(voting_text_disapproval_above_many_multi);
          } else if (disapprovalCount == 2 && disapprovalIndex == 0) {
            if (count == 1) setHeading(voting_text_disapproval_above_one_single);
            else setHeading(voting_text_disapproval_above_one_multi);
          } else if (disapprovalIndex == disapprovalCount - 2) {
            if (count == 1) setHeading(voting_text_disapproval_above_last_single);
            else setHeading(voting_text_disapproval_above_last_multi);
          } else {
            if (count == 1) setHeading(voting_text_disapproval_single);
            else setHeading(voting_text_disapproval_multi);
          }
          disapprovalIndex++;
        }
      }
    }
  }
  function voting_calculateScoring() {
    var mainDiv = document.getElementById("voting");
    var form = document.getElementById("voting_form");
    var scoringString = "";
    var approvalCount = 0;
    var disapprovalCount = 0;
    var sections = mainDiv.childNodes;
    for (var j=0; j<sections.length; j++) {
      var section = sections[j];
      if (section.className == "approval")       approvalCount++;
      if (section.className == "disapproval") disapprovalCount++;
    }
    var approvalIndex = 0;
    var disapprovalIndex = 0;
    for (var j=0; j<sections.length; j++) {
      var section = sections[j];
      if (
        section.className == "approval"    ||
        section.className == "abstention"  ||
        section.className == "disapproval"
      ) {
        var score;
        if (section.className == "approval") {
          score = approvalCount - approvalIndex;
          approvalIndex++;
        } else if (section.className == "abstention") {
          score = 0;
        } else if (section.className == "disapproval") {
          score = -1 - disapprovalIndex;
          disapprovalIndex++;
        }
        var entries = section.childNodes;
        for (var k=0; k<entries.length; k++) {
          var entry = entries[k];
          if (entry.className == "movable") {
            var id = entry.id.match(/[0-9]+/);
            var field = document.createElement("input");
            scoringString += id + ":" + score + ";";
          }
        }
      }
    }
    var fields = form.childNodes;
    for (var j=0; j<fields.length; j++) {
      var field = fields[j];
      if (field.name == "scoring") {
        field.setAttribute("value", scoringString);
        return;
      }
    }
    throw('Hidden input field named "scoring" not found.');
  }
  function voting_move(element, up, dropX, dropY) {
    jsProtect(function() {
      if (typeof(element) == "string") element = document.getElementById(element);
      var mouse = (up == null);
      var oldParent = element.parentNode;
      if (mouse) var centerY = dropY + element.clientHeight / 2;
      var approvalCount = 0;
      var disapprovalCount = 0;
      var mainDiv = document.getElementById("voting");
      var sections = mainDiv.childNodes;
      for (var i=0; i<sections.length; i++) {
        var section = sections[i];
        if (section.className == "approval")       approvalCount++;
        if (section.className == "disapproval") disapprovalCount++;
      }
      if (mouse) {
        for (var i=0; i<sections.length; i++) {
          var section = sections[i];
          if (
            section.className == "approval" ||
            section.className == "abstention" ||
            section.className == "disapproval"
          ) {
            if (
              centerY >= section.offsetTop &&
              centerY <  section.offsetTop + section.clientHeight
            ) {
              var entries = section.childNodes;
              for (var j=0; j<entries.length; j++) {
                var entry = entries[j];
                if (entry.className == "movable") {
                  if (centerY < entry.offsetTop + entry.clientHeight / 2) {
                    if (element != entry) {
                      oldParent.removeChild(element);
                      section.insertBefore(element, entry);
                    }
                    break;
                  }
                }
              }
              if (j == entries.length) {
                oldParent.removeChild(element);
                section.appendChild(element);
              }
              break;
            }
          }
        }
        if (i == sections.length) {
          var newSection = document.createElement("div");
          var cathead = document.createElement("div");
          cathead.setAttribute("class", "cathead");
          newSection.appendChild(cathead);
          for (var i=0; i<sections.length; i++) {
            var section = sections[i];
            if (
              section.className == "approval" ||
              section.className == "abstention" ||
              section.className == "disapproval"
            ) {
              if (centerY < section.offsetTop + section.clientHeight / 2) {
                if (section.className == "disapproval") {
                  newSection.setAttribute("class", "disapproval");
                  disapprovalCount++;
                } else {
                  newSection.setAttribute("class", "approval");
                  approvalCount++;
                }
                mainDiv.insertBefore(newSection, section);
                break;
              }
            }
          }
          if (i == sections.length) {
            newSection.setAttribute("class", "disapproval");
            disapprovalCount++;
            mainDiv.appendChild(newSection);
          }
          oldParent.removeChild(element);
          newSection.appendChild(element);
        }
      } else {
        var oldFound = false;
        var prevSection = null;
        var nextSection = null;
        for (var i=0; i<sections.length; i++) {
          var section = sections[i];
          if (
            section.className == "approval" ||
            section.className == "abstention" ||
            section.className == "disapproval"
          ) {
            if (oldFound) {
              nextSection = section;
              break;
            } else if (section == oldParent) {
              oldFound = true;
            } else {
              prevSection = section;
            }
          }
        }
        var create;
        if (oldParent.className == "abstention") {
          create = true;
        } else {
          create = false;
          for (var i=0; i<oldParent.childNodes.length; i++) {
            var entry = oldParent.childNodes[i];
            if (entry.className == "movable") {
              if (entry != element) {
                create = true;
                break;
              }
            }
          }
        }
        var newSection;
        if (create) {
          newSection = document.createElement("div");
          var cathead = document.createElement("div");
          cathead.setAttribute("class", "cathead");
          newSection.appendChild(cathead);
          if (
            oldParent.className == "approval" ||
            (oldParent.className == "abstention" && up)
          ) {
            newSection.setAttribute("class", "approval");
            approvalCount++;
          } else {
            newSection.setAttribute("class", "disapproval");
            disapprovalCount++;
          }
          if (up) {
            mainDiv.insertBefore(newSection, oldParent);
          } else {
            if (nextSection) mainDiv.insertBefore(newSection, nextSection);
            else mainDiv.appendChild(newSection);
          }
        } else {
          if (up) newSection = prevSection;
          else newSection = nextSection;
        }
        if (newSection) {
          oldParent.removeChild(element);
          if (create || up) {
            newSection.appendChild(element);
          } else {
            var inserted = false;
            for (var i=0; i<newSection.childNodes.length; i++) {
              var entry = newSection.childNodes[i];
              if (entry.className == "movable") {
                newSection.insertBefore(element, entry);
                inserted = true;
                break;
              }
            }
            if (!inserted) newSection.appendChild(element);
          }
        }
      }
      // sections = mainDiv.childNodes;
      for (i=0; i<sections.length; i++) {
        var section = sections[i];
        if (
          (section.className == "approval"    &&    approvalCount > 1) ||
          (section.className == "disapproval" && disapprovalCount > 1)
        ) {
          var entries = section.childNodes;
          for (var j=0; j<entries.length; j++) {
            var entry = entries[j];
            if (entry.className == "movable") break;
          }
          if (j == entries.length) {
            section.parentNode.removeChild(section);
          }
        }
      }
      voting_setCategoryHeadings();
      voting_calculateScoring();
    });
  }
  window.elementDropped = function(element, dropX, dropY) {
    voting_move(element, null, dropX, dropY);
  }
  window.addEventListener("load", function(event) {
    jsProtect(function() {
      voting_setCategoryHeadings();
      voting_calculateScoring();  // checks if script works fine
    });
  }, false);
  window.voting_moveUp = function(element) {
    return voting_move(element, true);
  }
  window.voting_moveDown = function(element) {
    return voting_move(element, false);
  }
});
