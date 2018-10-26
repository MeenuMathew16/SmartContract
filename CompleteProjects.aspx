<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompleteProjects.aspx.cs" Inherits="SmartContract.CompleteProjects" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Completed Projects List</title>

    <link href="Styles/SmartStyle.css" rel="stylesheet" />
    <link href="bootstrap-4.0.0-dist/css/bootstrap.css" rel="stylesheet" type="text/css"/>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome.js"></script>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome-all.js"></script>
	<link href="Styles/Font-Family.css" rel="stylesheet" />
    <script src="scripts/jquery-3.2.1.slim.min.js"></script>
    <script src="scripts/jquerry.min.js"></script>
    <script src="node_modules/web3/dist/web3.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
    <script src="scripts/jquery-ui.js"></script>
    <link href="styles.css" rel="stylesheet" />
    </head>
<script>
    function preventBack() { window.history.forward(); }
    setTimeout("preventBack()", 0);
    window.onunload = function () { null };
    //Web3

    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
        console.log(web3);
    }
    else {
        web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8085"));
        console.log(web3);
    }

    //Assigned Projects

    function AssignedProject(taskId) {
        localStorage.setItem("taskId", taskId);
        window.location = "ApproveProject.aspx";
        
    }

    function Logout() {
        sessionStorage.removeItem('logUserId');
        sessionStorage.removeItem('userName');
        sessionStorage.removeItem('address');
        sessionStorage.removeItem('balance');
        window.location = "Login.aspx";
    }

    //Submit Bid Value


    function SubmitBidValue(TaskId) {

        localStorage.setItem('taskIdForBid', TaskId);
        window.location = 'BidSubmission.aspx'
    }



 $(document).ready(function (e) {
     if (sessionStorage.getItem('logUserId') != null) {

         $("#minDate").datepicker();
         $("#maxDate").datepicker();
         //
         web3.eth.defaultAccount = sessionStorage.getItem('address');
         web3.eth.getBalance(web3.eth.defaultAccount, (err, balance) => {
             this.balance = web3.fromWei(balance, "Ether")
             var ethBalancefrom = this.balance;
             var _ethBalancefrom = ethBalancefrom.toFixed(2);
             $("#Balance").text(_ethBalancefrom + " ETHER");


         });
         //Skills Loading

         $.ajax({
             type: "POST",
             url: "SubmitProject.aspx/LoadSKills",
             contentType: "application/json; charset=utf-8",
             dataType: "json",
             success: function (data) {
                 if (data != null && data.d != "") {
                     var htmlSkill = '';
                     var projectList = $.parseJSON(data.d);
                     if (projectList.length > 0) {
                         for (var i = 0; i < projectList.length; i++) {
                             htmlSkill += '<div class="SMPRskills"><span><input class="messageCheckbox" type="checkbox" value=' + projectList[i].id + ' name="skills"/></span>' + projectList[i].name + '</div>';
                         }

                     }

                 }
                 if (htmlSkill != "")
                     $("#Skills").append(htmlSkill);
             },
             failure: function (data) {
             },
             error: function (data) {

             }
         });

         //Project Loading 

            $.ajax({
                 type: "POST",
                 url: "CompleteProjects.aspx/ViewProject",
                 data: '{UserId: "' + sessionStorage.getItem('logUserId') + '"}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (data) {
                     if (data != null && data.d != "") {
                         var htmlProject='';
                         var projectList = $.parseJSON(data.d);
                         if (projectList.length > 0) {
                             for (var i = 0; i < projectList.length; i++) {
                                 htmlProject += '<div class="row">';
                                 htmlProject += '<div class="col-md-8"><a href="#"><div class="viewProheading" onclick="AssignedProject(' + projectList[i].TaskId + ');">' + projectList[i].TaskName + '</div></a></div>';
                                 htmlProject += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].TaskCompletionDate + '</div></div>';
                                 htmlProject += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].BidValue + '<span> ETHER</span></div></div></div>';
                                 htmlProject += '<div class="row">';
                                 htmlProject += '<div class="col-md-10"><div class="viewProdesc">' + projectList[i].ProjectDescription + '</div></div>';
                                 htmlProject += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].BidCount + '<span>Bids</span></div></div></div>';
                                 htmlProject += '<div class="technologytext">' + projectList[i].Technology  + '</div>';
                                 htmlProject += '<div class="divider"></div>';
                              
                             }
                         }
                         else {
                             htmlProject = "<div class='row'><div class='col-md-8'><div class='technologytext'>No projects for approval </div></div></div>";
                         }
                     }
                     else {
                         htmlProject = "<div class='row'><div class='col-md-8'><div class='technologytext'>No projects for approval </div></div></div>";
                     }
                     if (htmlProject != "")
                         $("#projectList").append(htmlProject);
                 },
                 failure: function (data) {
                 },
                 error: function (data) {
                   
                 }
             });



            $(".loginname").html(sessionStorage.getItem('userName'));
           web3.eth.defaultAccount = sessionStorage.getItem('address');

         //var FundTransfer =web3.eth.contract([{ "constant": true, "inputs": [{ "name": "", "type": "address" }], "name": "balanceOf", "outputs": [{ "name": "", "type": "uint256", "value": "0" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "_from", "type": "address" }, { "name": "_to", "type": "address" }, { "name": "_value", "type": "uint256" }], "name": "TransferNcoins", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": true, "name": "from", "type": "address" }, { "indexed": true, "name": "to", "type": "address" }, { "indexed": false, "name": "value", "type": "uint256" }], "name": "FundTransfer", "type": "event" }]);
         //var FundTransferContract = FundTransfer.at('0xa16da5bea54d25ba4b71056f2b258c3c2acfb0c6');
         //FundTransferContract.balanceOf(sessionStorage.getItem('address'), function (error, result) {
         //    if (result) {
         //        $("#Balance").html(result + " ETH")
         //    }
         //});
           // $("#Balance").html(sessionStorage.getItem('balance') + "");
        }
        else {
            window.location = "Login.aspx";
        }
 });
 
 // Apply Filters


 function ApplyFilter() {


     if ($("#Min").val() == '' && $("#Max").val() == '' && $("#minDate").val() == '' && $("#maxDate").val() == '' && $('[class="messageCheckbox"]:checked').length == 0) {
         $("#lblFilters").css("color", "Red");
         $("#lblFilters").css("font-size", "13px");
         $("#lblFilters").html("Search with any of the filters *");
     }
     else {
        $("#lblFilters").html("");
         var selectedSkills = [];
         var flag;
         var minAmount = 0;
         var maxAmount = 0;
         var checkedSkill = '';
         var sDate = '';
         var eDate = '';
         minAmount = $("#Min").val();
         maxAmount = $("#Max").val();
         if (minAmount == '') {
             minAmount = 0;
         }
         if (maxAmount == '') {
             maxAmount = 0;
         }

         var sDate = $("#minDate").val();
         var eDate = $("#maxDate").val();
         var inputElements = document.getElementsByClassName('messageCheckbox');
         for (var i = 0; inputElements[i]; i++) {
             if (inputElements[i].checked == true) {
                 selectedSkills[i] = inputElements[i].value;
                 flag = 1;
             }
             checkedSkill = selectedSkills.join();

         }
         if (flag == 1) {
             checkedSkill = selectedSkills.join();

         }

         else {
             checkedSkill = '';
         }
         if (parseInt(minAmount) > parseInt(maxAmount) || sDate > eDate) {
             $("#lblFilters").css("color", "Red");
             $("#lblFilters").css("font-size", "13px");
             $("#lblFilters").html("Please Enter Valid Data *");
             $('#minDate').val("");
             $('#maxDate').val("");
             $("#Min").val("");
             $("#Max").val("");
         }
         else {
             $("#skillRelatedProject").html(" ");
             $.ajax({
                 type: "POST",
                 url: "BiddingTasks.aspx/FiltersChecking",
                 data: '{userId: ' + sessionStorage.getItem('logUserId') + ',skills:"' + checkedSkill + '", minAmount:' + minAmount + ', maxAmount:' + maxAmount + ', sDate:"' + sDate + '",eDate: "' + eDate + '"}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (data) {
                     $("#projectList").hide();
                     if (data != null && data.d != "") {

                         var htmlSkillsList = '';
                         var projectList = $.parseJSON(data.d);
                         if (projectList.length > 0) {
                             htmlSkillsList += '<div class="SMPRmainheadline" id="ProjectFilter"> BIDDING PROJECTS</div>';
                             for (var i = 0; i < projectList.length; i++) {

                                 if (projectList[i].TaskId != taskId) {
                                     htmlSkillsList += '<div class="row">';
                                     htmlSkillsList += '<div class="col-md-6"><a href="#"><div class="viewProheading" onclick="SubmitBidValue(' + projectList[i].TaskId + ')">' + projectList[i].TaskName + '</div></a></div>';
                                     htmlSkillsList += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].TaskCompletionDate + '</div></div>';
                                     htmlSkillsList += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].BidValue + '<span> ETHER</span></div></div>';
                                     htmlSkillsList += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].Creator + '</div></div></div>';
                                     htmlSkillsList += '<div class="row">';
                                     htmlSkillsList += '<div class="col-md-10"><div class="viewProdesc">' + projectList[i].Description + '</div></div>';
                                     htmlSkillsList += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].BidCount + '<span>Bids</span></div></div></div>';
                                     htmlSkillsList += '<div class="technologytext">' + projectList[i].Technology + '</div>';
                                     htmlSkillsList += '<div class="divider"></div>';
                                     var taskId = projectList[i].TaskId;
                                 }
                             }
                         }
                         else {
                             htmlSkillsList = "<div class='SMPRmainheadline' id='ProjectFilter'> BIDDING PROJECTS</div><div class='row'><div class='col-md-8'><div class='technologytext'>No matching projects found</div></div></div>";
                         }
                     }
                     else {
                         htmlSkillsList = "<div class='SMPRmainheadline' id='ProjectFilter'> BIDDING PROJECTS</div><div class='row'><div class='col-md-8'><div class='technologytext'>No matching projects found</div></div></div>";
                     }
                     if (htmlSkillsList != "")
                         $("#skillRelatedProject").html(htmlSkillsList);
                 },
                 failure: function (data) {
                 },
                 error: function (data) {

                 }
             });
         }
     }

 }


 //Clear Function

 function ClearFilter() {
     $("#Min").val("");
     $("#Max").val("");
     $('.messageCheckbox').prop('checked', false);
     $('#minDate').val("");
     $('#maxDate').val("");
 }


    </script>
<body>
 
	<header>
		<div class="headermaindiv">
			<div class="container">
				<div class="topheaderdiv">
					<div class="headerlogo"><img src="images/logo-header.png" width="215" height="35" alt=""/></div>
					<div class="toprightdiv">
					<div class="logoutdiv"><a href="#" onclick="Logout()">Logout</a></div>
					<div class="loginname" id="loginname">Richard</div>
                    <div class="BalanceView" id="Balance"></div>
                	<div class="FindProject"><a href="ResetPassword.aspx">Reset Password</a></div>
					<div class="FindProject"><a href="SubmitProject.aspx">Post Project</a></div>
				</div>
				</div>
			</div>
		</div>
		<div class="menuheader">
			<div class="container">
				<div class="topmenu">
					<ul>
                       <li><a href="BiddingTasks.aspx">Projects on Bidding</a></li>
						<li><a href="CreatedTaskView.aspx">Created Projects</a></li>
					    <li><a href="AssignedProjects.aspx">Assigned Projects</a></li>
                        <li><a href="CompleteProjects.aspx">Completed Projects</a></li>
						<li><a href="TerminateProjects.aspx">Terminated Projects</a></li>
                        <li><a href="AssignedTaskView.aspx">My Projects</a></li>
					</ul>
				</div>
			</div>
		</div>
	</header>
	<div class="container">
		<div class="row">
			<div class="col-md-3">
				<div class="filtermaindiv">
					<div class="SMPRheading">Filter</div>
					<div class="divider"></div>
					<div class="SMPRsubheading">Skills</div>
                    <div id="Skills">
					
                     </div>
                    <div class="divider"></div>
                   	<div class="SMPRheading">Bid amount</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="SMPRtextdiv1"><input type="number" min="0" class="SMPRtminbid" id="Min" placeholder="Min"/></div>
						</div>
						<div class="col-sm-6">
							<div class="SMPRtextdiv1"><input type="number" min="0" class="SMPRtminbid" id="Max" placeholder="Max"/></div>
						</div>
					</div>
					<div class="Sspace"></div>
					<div class="divider"></div>
					<div class="SMPRheading">Completion Date</div>
					<div class="SMPRbiddatesm">From</div>
					<div class="SMPRtextdiv1"><input class="SMPRCALtextbox" type="text" id="minDate"/><span><i class="far fa-calendar-alt"></i></span></div>
					<div class="SMPRbiddatesm">To</div>
					<div class="SMPRtextdiv1" ><input class="SMPRCALtextbox" type="text" id="maxDate"/><span><i class="far fa-calendar-alt"></i></span></div>
					<div class="Sspace"></div>
					<div class="divider"></div>
				    <div class="filterbtnmaindiv">
					<div class="filterbtn"><a href="#" onclick="ApplyFilter()">Search</a></div>
					<div class="clearbtn"><a href="#" onclick="ClearFilter()">Clear</a></div>
                  
					</div>
                     
                   <div class="divider"></div>
                   <div id="lblFilters" class="lblMessage"></div>
				</div>
			</div>
			<div class="col-md-9">
				<div class="SMPRcontentdiv">
                 <div id="projectList">
				<div class="SMPRmainheadline">Completed Project</div>
				
					</div>
                    <div id="skillRelatedProject"></div>
					<div class="Sspace"></div>
				<div class="Mspace"></div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>
