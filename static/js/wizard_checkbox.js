
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