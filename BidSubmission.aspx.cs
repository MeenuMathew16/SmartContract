using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmartContract
{
    public partial class BidSubmission : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public static string constr = ConfigurationManager.ConnectionStrings["ConNew"].ConnectionString;
        public class BidSubmissions
        {

            public string hostedBy;
            public string taskDescription;
            public string taskName;
            public string filePath;
            public int bidValue;

        }

        [WebMethod]
        public static BidSubmissions SubmitProjectBid(int TaskId)
        {
            BidSubmissions projectDetail = new BidSubmissions();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand BidCmd = new SqlCommand("dbo.[USPTaskDetailsView]"))
                    {
                        BidCmd.CommandType = CommandType.StoredProcedure;
                        BidCmd.Parameters.AddWithValue("@TaskId", TaskId);
                        BidCmd.Connection = con;
                        con.Open();
                        using (SqlDataReader reader = BidCmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {
                                reader.Read();
                                projectDetail.hostedBy = reader["Name"].ToString();
                                projectDetail.taskDescription = reader["TaskDescription"].ToString();
                                projectDetail.taskName = reader["TaskName"].ToString();
                                projectDetail.filePath = reader["FilePath"].ToString();
                                projectDetail.bidValue = Convert.ToInt32(reader["BidValue"]);
                            }

                        }

                    }
                }
               
            }

            catch (Exception)
            {
                Console.WriteLine("Error");
            }
          
            return projectDetail;
        }
        [WebMethod]
        public static string SubmitBidValue(int taskId, int bidderId, int bidValue)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand submitBidCmd = new SqlCommand("dbo.USPInsertBid"))
                    {
                        submitBidCmd.CommandType = CommandType.StoredProcedure;
                        submitBidCmd.Parameters.AddWithValue("@TaskId", taskId);
                        submitBidCmd.Parameters.AddWithValue("@BidderId", bidderId);
                        submitBidCmd.Parameters.AddWithValue("@BidValue", bidValue);
                        submitBidCmd.Connection = con;
                        con.Open();
                        int retVal = submitBidCmd.ExecuteNonQuery();
                        if (retVal == 0)
                        {
                            return "true";
                         
                        }
                        else
                        {
                            return "false";
                            
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