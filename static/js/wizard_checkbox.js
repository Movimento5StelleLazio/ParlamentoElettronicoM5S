
var oldCheckName="proposer_hidden";

function doCheck(idCheck)
{
	
	if (document.getElementById("imgCheck"+idCheck).style.display=="block")
		{
		 
		    document.getElementById("imgCheck"+idCheck).style.display="none";
		    document.getElementsByName(oldCheckName)[0].name="proposer_hidden";
		    document.getElementsByName("proposer_hidden")[0].value="false";
		    oldCheckName="proposer_hidden";
		}
	else
		{
			document.getElementById("imgCheck1").style.display="none";
			document.getElementById("imgCheck2").style.display="none";
			document.getElementById("imgCheck3").style.display="none";
			document.getElementById("imgCheck"+idCheck).style.display="block";
			document.getElementsByName(oldCheckName)[0].name="proposer_hidden_"+idCheck;
			document.getElementsByName("proposer_hidden_"+idCheck)[0].value="true";
			oldCheckName="proposer_hidden_"+idCheck;
		
		}
}

/**
 * 
 * Test
 */
var oldCheckNamePag1="policyChooser";

function doCheckPag1(idCheck,imgId)
{
	
	if (document.getElementById("imgCheck"+imgId).style.display=="block")
	{
	    document.getElementById("imgCheck"+imgId).style.display="none";
	    document.getElementsByName("policyChooser")[0].value="0";
	    oldCheckNamePag1="policyChooser";
	}
	else
	{
		document.getElementById("imgCheck1").style.display="none";
		document.getElementById("imgCheck2").style.display="none";
		document.getElementById("imgCheck3").style.display="none";
		document.getElementById("imgCheck"+imgId).style.display="block";
		document.getElementsByName("policyChooser")[0].value=idCheck;
		oldCheckNamePag1="policyChooser"
	}

}

/**
 * 
 * test
 * @param id
 */
function doCheckPag10(id)
{
	
	if (document.getElementById("imgCheck"+id).style.display=="block")
	{
	   document.getElementById("imgCheck"+id).style.display="none";
	   document.getElementById("technicalChooser"+id).disabled=true;
	   document.getElementById("div"+id).style.opacity="0.5";
	   document.getElementById("div"+id).disabled=true;
	   document.getElementById("nota"+id).disabled=true;
	   document.getElementById("nota"+id).style.opacity="0.5";
	}
	else
	{    console.log("abilita id="+id);
		 document.getElementById("imgCheck"+id).style.display="block";
		 document.getElementById("technicalChooser"+id).disabled=false;
		 document.getElementById("div"+id).style.opacity="1";
		 document.getElementById("div"+id).disabled=false;
		 document.getElementById("nota"+id).disabled=false;
		 document.getElementById("nota"+id).style.opacity="1";
		 
	}

}