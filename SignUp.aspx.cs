using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmartContract
{
    public partial class SignUp : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string CreateAccount(string lastName, string firstName, string address, string email, string password)
        {
            try
            {
                string constr = ConfigurationManager.ConnectionStrings["ConNew"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand createAccountCmd = new SqlCommand("dbo.USPUserRegistration"))
                    {
                        createAccountCmd.CommandType = CommandType.StoredProcedure;
                        createAccountCmd.Parameters.AddWithValue("@FirstName", firstName);
                        createAccountCmd.Parameters.AddWithValue("@LastName", lastName);
                        createAccountCmd.Parameters.AddWithValue("@Password", password);
                        createAccountCmd.Parameters.AddWithValue("@EmailId", email);
                        createAccountCmd.Parameters.AddWithValue("@Address", address);
                        createAccountCmd.Connection = con;
                        con.Open();
                        var UserId = createAccountCmd.ExecuteNonQuery();
                        if (UserId == 1)
                        {
                            return "Sucessfully Inserted";

                        }
                        else
                        {
                            return "Error";

                        }

                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error : " + e);
            }
            return "false";
        }
    }
}