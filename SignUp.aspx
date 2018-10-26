<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="SmartContract.SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="UTF-8"/>
<title>Smartcontract Signup</title>
<link href="styles.css" rel="stylesheet" type="text/css"/>
<link href="bootstrap-4.0.0-dist/css/bootstrap.css" rel="stylesheet" type="text/css"/>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome.js"></script>
	<script src="fontawesome-free-5.0.8/svg-with-js/js/fontawesome-all.js"></script>
	<link href="https://fonts.googleapis.com/css?family=Cabin" rel="stylesheet"/>
    <link href="Styles/loader.css" rel="stylesheet" />
	<style>
	@import url('https://fonts.googleapis.com/css?family=Cabin');
	</style>
    <script src="node_modules/web3/dist/web3.js"></script>
    <script src="scripts/jquery-3.2.1.slim.min.js"></script>
    <script src="scripts/jquerry.min.js"></script>
    <link href="styles.css" rel="stylesheet" />
    <script>
        //checking for web3 provider
        if (typeof web3 !== 'undefined') {
            web3 = new Web3(web3.currentProvider);
            console.log(web3);
        }
        else {
           // web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8085"));
            
            alert('Install MetaMask');
            window.location.replace("https://metamask.io/");
        }

        var email, password, fName, lName, cPassword, eValidate, pValidate, aValidate,ethAddress;
        //email validation 
        function validateEmail(sEmail) {
            var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
            if (filter.test(sEmail)) {
                return true;
            }
            else {
                return false;
            }
        }
        //password validation
        function validatePassword(pwrd, cPwrd) {
          
            if (pwrd == cPwrd) {
                return true;
            }
            else {
                return false;
            }
        }
        //page load
        $(document).ready(function (e) {
            if (typeof web3 !== 'undefined') {
                web3js = new Web3(web3.currentProvider);
            } else {
                alert('Install MetaMask');
                window.location.replace("https://metamask.io/");
              
            }


            $("#txtAddress").val(web3.eth.accounts);
     //alphabet only firstname field
            $("#txtFirstName").bind('keyup blur', function () {
                $(this).val(function (i, val) {
                    return val.replace(/[^a-z\s]/gi, '');
                });
            });
    //alphabet only lastname field
            $("#txtLastName").bind('keyup blur', function () {
                $(this).val(function (i, val) {
                    return val.replace(/[^a-z\s]/gi, '');
                });
            });
    //create button 
            $("#btnCreateAccount").click(function () {
                email = $("#txtEmail").val();
                password = $("#txtPassword").val();
                cPassword = $("#txtConfirmPassword").val();
                fName = $("#txtFirstName").val();
                lName = $("#txtLastName").val();
                ethAddress = $("#txtAddress").val();

    //field validation
                if ($.trim(email) != "" && $.trim(password) != "" && $.trim(fName) != "" && $.trim(lName) != "" && $.trim(cPassword) != "") {
    //email validation               
                    if (validateEmail(email)) {
                        eValidate = true;
                    }
                    else {
                        eValidate = false;
                        console.log("enter valid email");
                        $("#lblMessage").html("Enter a valid email id");
                    

                    }
                    if (web3.isAddress(ethAddress) == true) {
                        aValidate = true;
                    }
                    else {
                        aValidate = false;
                        console.log("enter valid address");
                        $("#lblMessage").html("Enter a valid Ethereum Address");
                    }
    //password validation
                    if (validatePassword(password, cPassword))
                    {
                        pValidate = true;

                    }else
                    {
                        pValidate = false;
                        $("#lblMessage").css("color", "red");
                        $("#lblMessage").html("Confirm password doesnt match");
                        console.log("Password not match");
                        
                    }

                    if (pValidate == true && eValidate == true && aValidate==true) {
                        console.log("Account creation initiated with user details.. Name:" + fName + " " + lName + " email:" + email + " address: " + ethAddress);
                        //create account using web3

                                //ajax call to .net method for create account
                                $.ajax({
                                    type: "POST",
                                    url: "SignUp.aspx/CreateAccount",
                                    data: '{lastName: "' + lName + '",firstName:"' + fName + '",address:"' + ethAddress + '",email:"' + email + '",password:"' + password + '" }',
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (data) {
                                        console.log("Account created : " + data.d);
                                        if (data.d == "Sucessfully Inserted") {
                                            $("#txtEmail").val("");
                                             $("#txtPassword").val("");
                                             $("#txtConfirmPassword").val("");
                                             $("#txtFirstName").val("");
                                             $("#txtLastName").val("");
                                             $("#txtAddress").val("");
                                            $("#lblMessage").css("color", "green");
                                            $("#lblMessage").html("Account Created Sucessfully");
                                            
                                            window.setTimeout(function () {
                                                 window.location = "Login.aspx";
                                            }, 5000);
                                        }
                                        if (data.d == "Error") {
                                            console.log(data.d.email);
                                            $("#lblMessage").css("color", "red");
                                            $("#lblMessage").html("Please fill with a unique emailid and Address");
                                            $("#txtEmail").val("");
                                            $("#txtAddress").val("");

                                        }
                                        if (data.d == "false") {
                                            console.log("error");
                                            $("#lblMessage").css("color", "red");
                                            $("#lblMessage").html("Please fill with a unique emailid and Address");
                                            $("#txtEmail").val("");
                                            $("#txtAddress").val("");

                                        }

                                     
                                    },
                                    error: function (data) {
                                        console.log("error: " + data.responseText);
                                    },
                                    failure: function (data) {
                                        console.log("failure: " + data.responseText);
                                    }
                                });

                            

                    }

                }
                else {
                    $("#lblMessage").css("color", "red");
                    $("#lblMessage").html("Please fill fields");
                    console.log("Fill Fields");
                }
                
            });
        });
        </script>
</head>

<body>
	<div class="signupmaindiv">
		<div class="loginlogo"><img src="images/smartContract-logo-login.png" alt=""/></div>
		<div class="divider"></div>
		<div class="Sspace"></div>
		<div class="loginlabel">Email Address</div>
		<div class="logintextdiv"><input class="logintextbox" type="text" id="txtEmail" placeholder="Email Address"/></div>
		<div class="loginlabel">First Name</div>
		<div class="logintextdiv"><input class="logintextbox" type="text" id="txtFirstName" placeholder="First Name"/></div>
		<div class="loginlabel">Last Name</div>
		<div class="logintextdiv"><input class="logintextbox" type="text" id="txtLastName" placeholder="Last Name"/></div>
        <div class="loginlabel">Ethereum Address</div>
		<div class="logintextdiv"><input class="logintextbox" type="text" id="txtAddress" placeholder="Ethereum Address"/></div>
		<div class="loginlabel">Password</div>
		<div class="logintextdiv"><input class="logintextbox" type="password" id="txtPassword" placeholder="Password"/></div>
		<div class="loginlabel">Confirm Password</div>
		<div class="logintextdiv"><input class="logintextbox" type="password" id="txtConfirmPassword" placeholder="Confirm Password"/></div>
		<div class="loginbtndiv">
		<button title="Videos" class="loginbtn" id="btnCreateAccount">Create Account</button>
		</div>
		<div class="Sspace"></div>
                    <div id="lblMessage" class="lblMessage"></div>
        
		<div class="Sspace"></div>
		<div class="signuptext">By registering you confirm that you accept the <a href="#">Terms and Conditions</a> and <a href="#">Privacy Policy</a></div>
	  <div class="Sspace"></div>
		<div class="divider"></div>
		<div class="Sspace"></div>
		<div class="signuptext">To Already a member? <a href="Login.aspx">Log In</a></div>
		<div class="Mspace"></div>
	</div>
</body>

</html>
