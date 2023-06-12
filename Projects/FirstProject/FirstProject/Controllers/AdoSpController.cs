using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using NPOI.SS.Formula.Functions;
using NuGet.Protocol.Plugins;
using Project.Entities.Request;
using Project.Entities.ViewModels;
using Project.Repository.Interface;
using System.Collections.ObjectModel;
using System.Data;
using Xceed.Wpf.Toolkit;

namespace FirstProject.Controllers
{
    public class AdoSpController : Controller
    {

        #region Ado.Net
        //public IActionResult SPAdo()
        //{
        //    try
        //    {
        //        var ConnectionString = "Server=PCI53\\SQL2019;Initial Catalog=CI-Main;Persist Security Info=False;User ID=sa;Password=Tatva@123;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=False;Connection Timeout=60;";
        //        SqlConnection connection = new SqlConnection(ConnectionString);

        //        connection.Open();

        //        SqlCommand command = new SqlCommand("SP_GetFilterdMissions", connection);
        //        command.CommandType = System.Data.CommandType.StoredProcedure;
        //        command.Parameters.AddWithValue("@searchTerm", "hello");

        //        command.ExecuteNonQuery();


        //        SqlDataReader sdr = command.ExecuteReader();

        //        var missionList = new ObservableCollection<MissionListModel>();

        //        while (sdr.Read())
        //        {
        //            MissionListModel model = new MissionListModel()
        //            {

        //                No = sdr.GetInt64(sdr.GetOrdinal("No")),
        //                Title = sdr.GetString(sdr.GetOrdinal("Title")),
        //                City = sdr.GetString(sdr.GetOrdinal("City")),
        //                Country = sdr.GetString(sdr.GetOrdinal("Country")),
        //                Theme = sdr.GetString(sdr.GetOrdinal("Theme")),
        //                Description = sdr.GetString(sdr.GetOrdinal("Description")),
        //                ShortDescription = sdr.GetString(sdr.GetOrdinal("ShortDescription")),
        //                OrganizationName = sdr.GetString(sdr.GetOrdinal("OrganizationName")),
        //                StartDate = sdr.GetDateTime(sdr.GetOrdinal("StartDate")),
        //                EndDate = sdr.GetDateTime(sdr.GetOrdinal("EndDate")),
        //                MissionType = sdr.GetString(sdr.GetOrdinal("MissionType")),
        //                AVGRating = sdr.GetDecimal(sdr.GetOrdinal("AVGRating")),
        //                SkillList = sdr.GetString(sdr.GetOrdinal("SkillList")),
        //                TotalRecords = sdr.GetInt32(sdr.GetOrdinal("TotalRecords"))


        //            };

        //            missionList.Add(model);

        //        }
        //        connection.Close();


        //        return View(missionList);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new Exception(ex.Message);
        //    }

        //}
        #endregion

        #region dapper

        private readonly ILogger<HomeController> _logger;
        private readonly IHomeRepository _homeRepository;

        public AdoSpController(ILogger<HomeController> logger, IHomeRepository homeRepository)
        {
            _logger = logger;
            _homeRepository = homeRepository;
        }


        public IActionResult SPAdo()
        {
            HomeViewModel data = new HomeViewModel();
            data.MissionList = _homeRepository.SPAdo().ToList();
            return View(data);
        }
        #endregion
    }
}
