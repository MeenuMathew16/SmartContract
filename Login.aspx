<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SmartContract.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="UTF-8"/>
<title>Smartcontract Login</title>
<link href="styles.css" rel="stylesheet" type="text/css"/>
<link href="bootstrap-4.0.0-dist/css/bootstrap.css" rel="stylesheet" type="text/css"/>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome-all.js"></script>
    <link href="Styles/loader.css" rel="stylesheet" />
    <script src="scripts/jquery-3.2.1.slim.min.js"></script>
    <script src="scripts/jquerry.min.js"></script>
    <script src="scripts/jquery-ui.js"></script>
    <script src="node_modules/web3/dist/web3.js"></script>
	<link href="https://fonts.googleapis.com/css?family=Cabin" rel="stylesheet"/>
	<style>
	@import url('https://fonts.googleapis.com/css?family=Cabin');
	</style>
    <script src="scripts/jquery-3.2.1.slim.min.js"></script>
    <script src="scripts/jquerry.min.js"></script>
    <link href="styles.css" rel="stylesheet" />
    
</head>
<script>
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
        console.log(web3);
    }
    else {
        // web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8085"));

        alert('Install MetaMask');
        window.location.replace("https://metamask.io/");
    }
   //Page Load
    $(document).ready(function () {
        $(function () {
            $('#txtEmail, #txtPassword').keypress(function (e) {
                if (e.which == 13) {
                    $('#btnLogin').focus().click();
                }
            });
        });
        $("#txtEmail").click(function () {
            $('#lblMessage').text('');
        });
        $("#txtPassword").click(function () {
            $('#lblMessage').text('');
        });
        console.log("document is ready");
        //Login Button..
        $("#btnLogin").click(function () {
            console.log("Login initiated");
            var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

            var email = $("#txtEmail").val();
            var passWord = $("#txtPassword").val();
            if (email != "" && passWord != "") {
                if (filter.test(email)) {
                    console.log("Connecting to server....");
                    console.log("Email : " + email + "  Password :*****");
                    // ajax call to .net method
                    $.ajax({
                        type: "POST",
                        url: "Login.aspx/ValidateUser",
                        data: '{email: "' + email + '",passWord: "' + passWord + '" }',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            var ethBalance, ethbalanceWei;
                            var dbAddress=data.d.userAddress;
                            if (data.d.userId != 0) {
                                if (web3.eth.accounts == undefined) {
                                    alert("login an account in metamask");
                                }
                                else {
                                    if (web3.eth.accounts != dbAddress.toLowerCase()) {
                                        alert("The accounts that you have registered and in metamask is different. we are taking the metamask for this session");
                                        $("#txtEmail").val()="";
                                        $("#txtPassword").val()="";

                                    }
                                    else
                                    {
                                       web3.eth.getBalance(dbAddress, (err, balance) => {
                                            this.balance = web3.fromWei(balance, "Ether") + " Ether"
                                            ethBalance = this.balance;
                                            console.log(ethBalance);
                                            sessionStorage.setItem('balance', ethBalance);
                                            window.location = "BiddingTasks.aspx";
                                        });
                                    }
                                  
                                        //$("#lblMessage").css("color", "green");
                                        //$("#lblMessage").html("Login Sucessfull");
                                        sessionStorage.setItem('logUserId', data.d.userId);
                                        sessionStorage.setItem('userName', data.d.Name);
                                        sessionStorage.setItem('address',web3.eth.accounts);
                                        sessionStorage.setItem('password', data.d.userPassword);
                                        sessionStorage.setItem('loginEmailId', data.d.emailId);
                                        console.log("Sucess");

                                }
                               
                            }
                          
                            else {
                                console.log("Wrong username or password");
                                $("#lblMessage").css("color", "red");
                                $("#lblMessage").html("Wrong Email Id or Password");

                            }
                        }
                    });
                }
                else {
                    console.log("its not a email format");
                    $("#lblMessage").css("color", "red");
                    $("#lblMessage").html("Not a email format");
                }


            }
            else {
                console.log("Please flll all mandatory fileds");
                $("#lblMessage").css("color", "red");
                $("#lblMessage").html("Please flll all mandatory fileds");
            }

        });
     //forgot button
        $("#btnForgotPassword").click(function () {
            console.log("Clicked ForgotPassword");
           

        });
    });
    


    </script>
<body>

        <div class="loginmaindiv" id="login">
            <div class="loginlogo"><img src="images/smartContract-logo-login.png" alt="" /></div>
            <div class="divider"></div>
            <div class="Sspace"></div>
            <div class="loginlabel">Email</div>
            <div class="logintextdiv"><input class="logintextbox" type="text" id="txtEmail"></div>
            <div class="loginlabel">Password</div>
            <div class="logintextdiv"><input class="logintextbox" type="password"id="txtPassword"></div>
            <div class="loginbtndiv">
            <button title="Videos" class="loginbtn" id="btnLogin">Login</button>
            </div>
            <div class="Sspace"></div>
            <div id="lblMessage" class="lblMessage"></div>
            <div class="Sspace"></div>
            <div class="forgotpassowrd"><a href="ForgotPassword.aspx" id="btnForgotPassword">Forgot Password?</a></div>
            <div class="Sspace"></div>
            <div class="divider"></div>
            <div class="Sspace"></div>
            <div class="signuptext">Don't have an account? <a href="SignUp.aspx">Sign Up</a></div>
            <div class="Mspace"></div>
        </div>
</body>

</html>
