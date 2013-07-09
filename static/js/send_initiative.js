
function sendInitiative(page)
{
//	  document.getElementById("policyChooser").selectedIndex;
//	  
//	  var _select = document.getElementById('policyChooser');
//	  var _policy_name = _select.options[_select.selectedIndex].innerHTML;
//	  var indice_id= document.getElementsByName(_policy_name)[0].value;
//	  var id= indice_id.substring(indice_id.indexOf("_")+1,indice_id.lenght);
//	  
	 
	  //document.getElementsByName("policy_id_hidden")[0].value=document.getElementById("issue_title").value;
	  document.getElementsByName("issue_title_hidden")[0].value=document.getElementById("issue_title").value;
      document.getElementsByName("issue_brief_description_hidden")[0].value=document.getElementById("issue_brief_description").innerHTML;
      document.getElementsByName("issue_keywords_hidden")[0].value=document.getElementById("issue_keywords").value;
      document.getElementsByName("problem_description_hidden")[0].value=document.getElementById("problem_description").value;
      document.getElementsByName("aim_description_hidden")[0].value=document.getElementById("aim_description").value;
      document.getElementsByName("initiative_title_hidden")[0].value=document.getElementById("initiative_title").value;
      document.getElementsByName("initiative_brief_description_hidden")[0].value=document.getElementById("initiative_brief_description").value;
      document.getElementsByName("draft_hidden")[0].value=document.getElementById("draft").value;
     
      try
      {
	      document.getElementsByName("proposer1_hidden")[0].value=document.getElementsByName("proposer1")[0].value==1?true:false;
	      document.getElementsByName("proposer2_hidden")[0].value=document.getElementsByName("proposer2")[0].value==1?true:false;
	      document.getElementsByName("proposer3_hidden")[0].value=document.getElementsByName("proposer3")[0].value==1?true:false;
      }
      catch(e)
      {
    	  //forced set
      }
      
      document.getElementById("wizardForm"+page+"").submit();
	
	
}
