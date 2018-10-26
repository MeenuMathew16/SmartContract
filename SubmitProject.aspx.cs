using Newtonsoft.Json;
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
    public partial class SubmitProject : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public static string constr = ConfigurationManager.ConnectionStrings["ConNew"].ConnectionString;
        [WebMethod]
        public static int CreateProject(string ProjectName, int ProjectValue, string ContractAddress, int UserId, string ProjectDescription, DateTime CompletionDate ,string FilePath, string Skills,DateTime BidDate)
        {
            try
            {
              
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand createProjectCmd = new SqlCommand("dbo.USPNewContract"))
                    {
                        createProjectCmd.CommandType = CommandType.StoredProcedure;
                        createProjectCmd.Parameters.AddWithValue("@TaskName", ProjectName);
                        createProjectCmd.Parameters.AddWithValue("@BidValue", ProjectValue);
                        createProjectCmd.Parameters.AddWithValue("@ContractAddress", ContractAddress);
                        createProjectCmd.Parameters.AddWithValue("@UserId", UserId);
                        createProjectCmd.Parameters.AddWithValue("@FilePath", FilePath);
                        createProjectCmd.Parameters.AddWithValue("@ProjectDescription", ProjectDescription.Trim());
                        createProjectCmd.Parameters.AddWithValue("@CompletionDate", Convert.ToDateTime(CompletionDate));
                        createProjectCmd.Parameters.AddWithValue("@BidClosingDate", Convert.ToDateTime(BidDate));
                        createProjectCmd.Parameters.AddWithValue("@Technology", Skills);
                        createProjectCmd.Connection = con;
                        con.Open();
                        int ExVal = createProjectCmd.ExecuteNonQuery();

                    }

                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error : " + e);
            }

            return 1;
        }
        [WebMethod]
        public static string LoadSKills()
        {
            DataTable viewTable;
            string skillData="";
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand loadSkillCmd = new SqlCommand("dbo.USPListTechnologies"))
                    {
                        loadSkillCmd.CommandType = CommandType.StoredProcedure;
                        loadSkillCmd.Connection = con;
                        con.Open();
                        using (SqlDataReader reader = loadSkillCmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {
                                viewTable = new DataTable();
                                viewTable.Load(reader);
                                skillData= JsonConvert.SerializeObject(viewTable);
                                return JsonConvert.SerializeObject(viewTable);
                            }
                            else
                            {
                                return string.Empty;
                            }


                        }

                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error : " + e);
            }
            return skillData;
        }
    }
}