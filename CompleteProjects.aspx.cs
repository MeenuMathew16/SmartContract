using Newtonsoft.Json;
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
    public partial class CompleteProjects : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public static string constr = ConfigurationManager.ConnectionStrings["ConNew"].ConnectionString;
        [WebMethod]
        public static string ViewProject(int UserId)
        {
            DataTable viewTable;
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand viewProjectCmd = new SqlCommand("dbo.USPListTasksBasedOnStatus"))
                    {
                        viewProjectCmd.CommandType = CommandType.StoredProcedure;
                        viewProjectCmd.Parameters.AddWithValue("@UserId", UserId);
                        viewProjectCmd.Parameters.AddWithValue("@Operation", 2);
                        viewProjectCmd.Connection = con;
                        con.Open();
                        using (SqlDataReader reader = viewProjectCmd.ExecuteReader())
                        {
                            if (reader.HasRows)
                            {
                                viewTable = new DataTable();
                                viewTable.Load(reader);
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

            catch (Exception)
            {
                Console.WriteLine("Error");
            }
           
            return string.Empty;
        }
        //[WebMethod]
        //public static string FiltersChecking(int userId, string skills, int minAmount, int maxAmount, string sDate, string eDate)
        //{
        //    DataTable viewTable;
        //    try
        //    {
        //        string constr = ConfigurationManager.ConnectionStrings["ConNew"].ConnectionString;
        //        using (SqlConnection con = new SqlConnection(constr))
        //        {
        //            using (SqlCommand skillsCmd = new SqlCommand("dbo.USPSearchByCompleted"))
        //            {
        //                skillsCmd.CommandType = CommandType.StoredProcedure;
        //                skillsCmd.Parameters.AddWithValue("@UserId", userId);
        //                skillsCmd.Parameters.AddWithValue("@TechIdList", skills);
        //                skillsCmd.Parameters.AddWithValue("@MinAmt", minAmount);
        //                skillsCmd.Parameters.AddWithValue("@MaxAmt", maxAmount);
        //                skillsCmd.Parameters.AddWithValue("@SDate", sDate);
        //                skillsCmd.Parameters.AddWithValue("@EDate", eDate);
        //                skillsCmd.Connection = con;
        //                con.Open();
        //                using (SqlDataReader reader = skillsCmd.ExecuteReader())
        //                {
        //                    if (reader.HasRows)
        //                    {
        //                        viewTable = new DataTable();
        //                        viewTable.Load(reader);
        //                        return JsonConvert.SerializeObject(viewTable);
        //                    }
        //                    else
        //                    {
        //                        return string.Empty;
        //                    }
        //                }
        //            }
        //        }
        //    }

        //    catch (Exception)
        //    {
        //        Console.WriteLine("Error");
        //    }
        //    finally
        //    {

        //    }
        //    return string.Empty;
        //}

    }
}