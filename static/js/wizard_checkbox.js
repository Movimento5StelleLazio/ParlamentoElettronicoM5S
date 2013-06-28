

function doCheck(idCheck)
{

	document.getElementById("imgCheck1").style.display="none";
	document.getElementById("imgCheck2").style.display="none";
	document.getElementById("imgCheck3").style.display="none";
	
	document.getElementById("imgCheck"+idCheck).style.display="block";
	
	document.getElementsByName("proposer_hidden")[0].name="proposer_hidden_"+idCheck;
	document.getElementsByName("proposer_hidden_"+idCheck)[0].value="true";
	 

}