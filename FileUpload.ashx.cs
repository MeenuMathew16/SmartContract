using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace SmartContract
{
    /// <summary>
    /// Summary description for FileUpload
    /// </summary>
    public class FileUpload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            string myName = context.Request.Form["myName"];

            if (context.Request.Files.Count > 0)
            {
                HttpFileCollection selectedFiles = context.Request.Files;
                for (int i = 0; i < selectedFiles.Count; i++)
                {

                    HttpPostedFile PostedFile = selectedFiles[i];
                    string FileName = context.Server.MapPath("~/Uploads/" + myName + Path.GetFileName(PostedFile.FileName));
                    PostedFile.SaveAs(FileName);
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}