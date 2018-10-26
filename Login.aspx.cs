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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public class UserLogin
        {
            public int userId;
            public string Name;
            public string userAddress;
            public int accountBalance;
            public string userPassword;
            public string emailId;


        }
        [WebMethod]
        public static UserLogin ValidateUser(string email, string passWord)
        {
            UserLogin userDetail = new UserLogin();
            string constr = ConfigurationManager.ConnectionStrings["ConNew"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand loginCmd = new SqlCommand("dbo.USPLogin"))
                {
                    loginCmd.CommandType = CommandType.StoredProcedure;
                    loginCmd.Parameters.AddWithValue("@Email", email);
                    loginCmd.Parameters.AddWithValue("@Password", passWord);
                    loginCmd.Connection = con;
                    con.Open();
                    using (SqlDataReader reader = loginCmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            reader.Read();
                            userDetail.userId = Convert.ToInt32(reader["userId"]);
                            userDetail.Name = reader["Name"].ToString();
                            userDetail.userAddress = reader["Address"].ToString();
                            userDetail.accountBalance = Convert.ToInt32(reader["AccountBalance"]);
                            userDetail.userPassword = reader["Password"].ToString();
                            userDetail.emailId = reader["EmailId"].ToString();

                        }

                    }

                }
            }
            return userDetail;
        }
    }
}