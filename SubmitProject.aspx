btnUpload<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubmitProject.aspx.cs" Inherits="SmartContract.SubmitProject" %>

<!DOCTYPE html>

<html>
<head runat="server">

<meta charset="UTF-8"/>
<title>Submit Project</title>
<link href="styles.css" rel="stylesheet" type="text/css"/>
<link href="bootstrap-4.0.0-dist/css/bootstrap.css" rel="stylesheet" type="text/css"/>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome.js"></script>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome-all.js"></script>
    <script src="scripts/jquery-3.2.1.slim.min.js"></script>
    <script src="scripts/jquerry.min.js"></script>
    <script src="scripts/jquery-ui.js"></script>
    <script src="node_modules/web3/dist/web3.js"></script>
    <link href="Styles/loader.css" rel="stylesheet" />
    <link href="Styles/SmartStyle.css" rel="stylesheet" />
    <link href="loopj-jquery-tokeninput-201d2d1/styles/token-input-facebook.css" rel="stylesheet" />
    <script src="loopj-jquery-tokeninput-201d2d1/src/jquery.tokeninput.js"></script>
    <link href="loopj-jquery-tokeninput-201d2d1/styles/token-input.css" rel="stylesheet" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
    <link href="Styles/Font-Family.css" rel="stylesheet" />
	<link href="styles.css" rel="stylesheet" />


    <script>

        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
        //Logout

        function Logout() {
            sessionStorage.removeItem('logUserId');
            sessionStorage.removeItem('userName');
            sessionStorage.removeItem('address');
            sessionStorage.removeItem('balance');
            window.location = "Login.aspx";
        }

        //web3
        if (typeof web3 !== 'undefined') {
            web3 = new Web3(web3.currentProvider);
            console.log(web3);
        }
        else {
            web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8085"));
            console.log(web3);
        }

        var projectName, bidAmount, completionDate, bidDate, projectDescription, skills, filePath, address, userId;
        var formData, random;

        $(document).ready(function (e) {
            //
            web3.eth.defaultAccount = sessionStorage.getItem('address');
            web3.eth.getBalance(web3.eth.defaultAccount, (err, balance) => {
                this.balance = web3.fromWei(balance, "Ether")
                var ethBalancefrom = this.balance;
                var _ethBalancefrom = ethBalancefrom.toFixed(2);
                $("#Balance").text(_ethBalancefrom + " ETHER");


            });

            $("#loader").hide();
            $("#txtProjectName").click(function () {
                $('#lblMessage').text('');
            });
            $("#txtBidAmount").click(function () {
                $('#lblMessage').text('');
            });
            $("#txtProjectCompleteion").click(function () {
                $('#lblMessage').text('');
            });
            $("#txtBidClosing").click(function () {
                $('#lblMessage').text('');
            });
            $("#txtProjectDescription").click(function () {
                $('#lblMessage').text('');
            });
            $("#txtSkills").click(function () {
                $('#lblMessage').text('');
            });
            $("#txtFilePath").click(function () {
                $('#lblMessage').text('');
            });
            //
            if (sessionStorage.getItem('logUserId') != null) {
                $("#loader").hide();
                $("#minDate").datepicker();
                $("#maxDate").datepicker();

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

                $(".loginname").html(sessionStorage.getItem('userName'));
               web3.eth.defaultAccount = sessionStorage.getItem('address');

                //var FundTransfer =web3.eth.contract([{ "constant": true, "inputs": [{ "name": "", "type": "address" }], "name": "balanceOf", "outputs": [{ "name": "", "type": "uint256", "value": "0" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "_from", "type": "address" }, { "name": "_to", "type": "address" }, { "name": "_value", "type": "uint256" }], "name": "TransferNcoins", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": true, "name": "from", "type": "address" }, { "indexed": true, "name": "to", "type": "address" }, { "indexed": false, "name": "value", "type": "uint256" }], "name": "FundTransfer", "type": "event" }]);
                //var FundTransferContract = FundTransfer.at('0xa16da5bea54d25ba4b71056f2b258c3c2acfb0c6');
                //FundTransferContract.balanceOf(sessionStorage.getItem('address'), function (error, result) {
                //    if (result) {
                //        $("#Balance").html(result + " ETH")
                //    }
                //});
               // $("#Balance").html(sessionStorage.getItem('balance'));
                $.ajax({
                    type: "POST",
                    url: "SubmitProject.aspx/LoadSKills",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        console.log(data.d);
                        var tagObjects = JSON.parse(data.d);

                        $("#txtSkills").tokenInput(tagObjects, {
                            theme: "facebook", preventDuplicates: true
                        });
                    },
                    error: function (data) {
                        console.log("error: " + data.responseText);
                    },
                    failure: function (data) {
                        console.log("failure: " + data.responseText);
                    }

                });
                //datepicker
              //  $(".SMPRCALtextbox").datepicker({ minDate: 0, /*maxDate: "+2Y +1M +10D"*/ });

<%--                $("#txtBidClosing").datepicker({ minDate: 0 });

                $("#txtProjectCompleteion").datepicker({ minDate: 0 });--%>

                $(function () {
                    var dateFormat = "mm/dd/yy",
                      from = $("#txtBidClosing")
                        .datepicker({
                            
                            minDate: 0,
                            changeMonth: true,
                            numberOfMonths: 1
                        })
                        .on("change", function () {
                            to.datepicker("option", "minDate", getDate(this));
                        }),
                      to = $("#txtProjectCompleteion").datepicker({
                          defaultDate: "+1w",
                          changeMonth: true,
                          numberOfMonths: 1
                      })
                      .on("change", function () {
                        //  from.datepicker("option", "minDate", getDate(this));
                      });

                    function getDate(element) {
                        var date;
                        try {
                            date = $.datepicker.parseDate(dateFormat, element.value);
                        } catch (error) {
                            date = null;
                        }

                        return date;
                    }
                });
                //datepicker end
                $("#btnSubmit").click(function () {
                    $("#loader").show();
                    $("#lblMessage").html("");
                    SubmitProject();

                });

                $("#btnUpload").click(function () {
                    $("#btnUpld").click();
                    $("#btnUpld").change(function (e) {
                        var fileName = e.target.files[0].name;
                        filePath = fileName;
                        $("#txtFilePath").val(fileName);

                    });

                });
            }
           else
            {
                window.location = "Login.aspx";
            }
        });


        //Submit Project


        function SubmitProject() {
           web3.eth.defaultAccount = sessionStorage.getItem('address');

            var createTask =web3.eth.contract([
	{
	    "anonymous": false,
	    "inputs": [
			{
			    "indexed": false,
			    "name": "cAddress",
			    "type": "address"
			}
	    ],
	    "name": "ContractCreated",
	    "type": "event"
	},
	{
	    "constant": false,
	    "inputs": [
			{
			    "name": "account",
			    "type": "address"
			},
			{
			    "name": "tName",
			    "type": "string"
			},
			{
			    "name": "tValue",
			    "type": "uint256"
			}
	    ],
	    "name": "newContract",
	    "outputs": [
			{
			    "name": "contractAddress",
			    "type": "address"
			}
	    ],
	    "payable": false,
	    "stateMutability": "nonpayable",
	    "type": "function"
	},
	{
	    "constant": true,
	    "inputs": [
			{
			    "name": "",
			    "type": "uint256"
			}
	    ],
	    "name": "contracts",
	    "outputs": [
			{
			    "name": "",
			    "type": "address"
			}
	    ],
	    "payable": false,
	    "stateMutability": "view",
	    "type": "function"
	},
	{
	    "constant": true,
	    "inputs": [],
	    "name": "getContractCount",
	    "outputs": [
			{
			    "name": "contractCount",
			    "type": "uint256"
			}
	    ],
	    "payable": false,
	    "stateMutability": "view",
	    "type": "function"
	}
            ]);
            var createTaskContract = createTask.at('0x258e487c1596ec92281071354490de195311142c');

   
            projectName = $("#txtProjectName").val();
            bidAmount = $("#txtBidAmount").val();
            completionDate = $("#txtProjectCompleteion").val();
            bidDate = $("#txtBidClosing").val();
            projectDescription = $("#txtProjectDescription").val();
            skills = $("#txtSkills").val() + ",";
            random=$.now();
            var files = $("#btnUpld")[0].files;
            console.log(files);
            if (files.length > 0)
            {
                formData = new FormData();
                for (var i = 0; i < files.length; i++)
                {
                    formData.append(files[i].name, files[i]);
                }
                formData.append("myname", random);
            }
            console.log(formData);
            if ((parseInt($("#Balance").text())) > bidAmount) {
                if ($.trim(projectName) != "" && $.trim(bidAmount) != "" && $.trim(completionDate) && $.trim(bidDate) && $.trim(projectDescription) && $.trim(skills)/* && $.trim(filePath)*/) {
                    console.log("project name: " + projectName + " ProjectValue: " + bidAmount + " completionDate:" + completionDate + " bidDate: " + bidDate + " project description: " + projectDescription + " skills: " + skills + " filepath:" + filePath + " ContractAddress:" + address + " UserId:" + sessionStorage.getItem("logUserId"));

                    console.log("contract creation ..");
                    //web3.personal.unlockAccount(sessionStorage.getItem('address'), sessionStorage.getItem('password'), 260, function (error, result) {
                    //    if (result) {
                    //        console.log("Account unlocked for transaction" + result);

                    createTaskContract.newContract(sessionStorage.getItem('address'), projectName, bidAmount, { from: sessionStorage.getItem('address'), gas: '719487' }, function (error, result) {
                        console.log("contract creation initiated");
                        if (result) {

                            console.log("project created. Hash: " + result);


                        }
                        if (error) {
                            console.log("error in Contract" + error);
                            $("#loader").hide();
                            $("#lblMessage").html("Insufficient Balance or Gas");
                        }

                    //});

               // }
                    
                        if (error) {
                            $("#loader").hide();
                            $("#lblMessage").css("color", "red");
                            $("#lblMessage").html("Unable to unlock account-Please check connection");
                            console.log("Unable to unlock account" + error);
                        }
                    });


                    var watchProject = createTaskContract.ContractCreated();
                    watchProject.watch(function (error, result) {
                        if (result) {
                            console.log(result.args.cAddress);
                            $.ajax({
                                type: "POST",
                                url: "SubmitProject.aspx/CreateProject",
                                data: '{ProjectName: "' + projectName + '",ProjectValue:"' + bidAmount + '",ContractAddress:"' + result.args.cAddress + '",UserId:"' + sessionStorage.getItem("logUserId") + '",ProjectDescription:"' + projectDescription + '",CompletionDate:"' + completionDate + '",FilePath:"' + random + filePath + '",Skills:"' + skills + '",BidDate:"' + bidDate + '" }',
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (data) {

                                    $.ajax({
                                        url: "FileUpload.ashx",
                                        method: "post",
                                        data: formData,
                                        contentType: false,
                                        processData: false,
                                        sucess: function () {

                                            $("#txtProjectName").val("");
                                            $("#txtBidAmount").val("");
                                            $("#txtProjectCompleteion").val("");
                                            $("#txtBidClosing").val("");
                                            $("#txtProjectDescription").val("");
                                            $("#txtSkills").tokenInput("clear");
                                            $("#lblMessage").css("color", "green");
                                           // $("#lblMessage").css("font-size", "1.0em"); 
                                            $("#lblMessage").html("Project Created");

                                            $("#loader").hide();
                                        },
                                        error: function (err) {
                                            $("#loader").hide();
                                            $("#lblMessage").css("color", "red");
                                            $("#lblMessage").html("Unable to process");
                                            console.log(err);
                                        }
                                    });
                                    $("#txtProjectName").val("");
                                    $("#txtBidAmount").val("");
                                    $("#txtProjectCompleteion").val("");
                                    $("#txtBidClosing").val("");
                                    $("#txtProjectDescription").val("");
                                    $("#txtSkills").val("");
                                    $("#txtSkills").tokenInput("clear");
                                    $("#txtProjectName").focus();
                                    $("#txtFilePath").val("");
                                    $("#lblMessage").css("color", "green");
                                    $("#lblMessage").html("Project Created");
                                    $("#loader").hide();

                                },
                                error: function (data) {
                                    $("#loader").hide();
                                    $("#lblMessage").css("color", "red");
                                    $("#lblMessage").html("Unable to process");
                                    console.log("error: " + data.responseText);
                                },
                                failure: function (data) {
                                    console.log("failure: " + data.responseText);
                                }
                            });
                            //end call

                        }
                        if (error) {
                            console.log(error);
                        }
                    });
                    //ajax call to .net method for create account

                }
                else {
                    $("#lblMessage").css("color", "red");
                    $("#lblMessage").html("Please flll all mandatory fileds");
                    console.log("project name: " + projectName + " bidamount: " + bidAmount + " completionDate:" + completionDate + " bidDate: " + bidDate + " project description: " + projectDescription + " skills: " + skills + " filepath:" + filePath);
                    $("#loader").hide();
                    console.log("fill fields");
                }
            }
            else {

                $("#txtProjectName").val("");
                $("#txtBidAmount").val("");
                $("#txtProjectCompleteion").val("");
                $("#txtBidClosing").val("");
                $("#txtProjectDescription").val("");
                $("#txtSkills").val("");
                $("#txtFilePath").val("");
                $("#lblMessage").css("color", "red");
                $("#lblMessage").html("You don't have sufficient Ether");
                $("#loader").hide();
            }

        }


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
                            $("#newProject").hide();
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
                                            htmlSkillsList += '<div class="col-md-2"><div class="viewProdate">' + projectList[i].BidValue + '<span>ETH</span></div></div>';
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

        //Submit Bid Value


        function SubmitBidValue(TaskId) {

            localStorage.setItem('taskIdForBid', TaskId);
            window.location = 'BidSubmission.aspx'
        }



    </script>

</head>

<body>
	<header>
		<div class="headermaindiv">
           
			<div class="container">
				<div class="topheaderdiv">
					<div class="headerlogo"><img src="images/logo-header.png" width="215" height="35" alt=""/></div>
					<div class="toprightdiv">
					<div class="logoutdiv"><a href="#" onclick="Logout();">Logout</a></div>
					<div class="loginname"></div>
                    <div class="BalanceView" id="Balance" style="top: 50px;"></div>
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
                <div id="newProject">
				<div class="SMPRmainheadline">Submit Project</div>
				<div class="SMPRheadlabel">Project Name</div>
				<div class="SMPRtextdiv"><input class="SMPRtextbox" type="text" maxlength="15" id="txtProjectName"></div>
				<div class="row">
					<div class="col-sm-4">
						<div class="SMPRheadlabel">maximum Bid Amount</div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tbody>
							<tr>
							  <td><div class="SMPRtextdiv1"><input class="SMPRtextbox" type="number" min="1" id="txtBidAmount"></div></td>
							  <td valign="bottom" class="SMPRtextdivspan">ETHER</td>
							</tr>
						  </tbody>
						</table>
						
					</div>
                    	<div class="col-sm-4">
						<div class="SMPRheadlabel">Bid Closing On</div>
						<div class="SMPRtextdiv1"><input class="SMPRCALtextbox" type="text" id="txtBidClosing" readonly><span><i class="far fa-calendar-alt"></i></span></div>
					</div>
					<div class="col-sm-4">
						<div class="SMPRheadlabel">Project Completion</div>
						<div class="SMPRtextdiv1"><input class="SMPRCALtextbox" type="text" id="txtProjectCompleteion" readonly><span ><i class="far fa-calendar-alt"></i></span></div>
					</div>
				
				</div>
					<div class="SMPRheadlabel">Project Description</div>
				<div class="SMPRtextdiv"><textarea class="SMPRtextarea" id="txtProjectDescription" maxlength="500" ></textarea></div>
					<div class="SMPRheadlabel">Skills</div>
			
                    <input type="text" id="txtSkills"/>
					<div class="SMPRheadlabel">Upload Files</div>
					<div class="row">
						<div class="col-md-10">
							<div class="SMPRtextdiv"><input class="SMPRtextbox" type="text" id="txtFilePath" readonly></div>
						</div>
						<div class="col-md-2">
							<div class="uploaddiv" id="btnUpload">Upload</div>
                            <input type="file" hidden id="btnUpld" accept=".pdf,.doc,.png,.jpeg"/>
						</div>
					</div>
					<div class="Sspace"></div>
				<button title="Videos" class="submitbtn" id="btnSubmit">Submit Project</button> <div id="loader"><div class="lds-ripple"><div></div><div></div></div></div>
					<div class="Mspace"> </div>
                    <div id="lblMessage" class="lblMessage"></div>
                    </div>
                    <div id="skillRelatedProject"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
