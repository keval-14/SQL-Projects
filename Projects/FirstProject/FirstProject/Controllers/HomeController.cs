using FirstProject.Models;
using Microsoft.AspNetCore.Mvc;
using Project.Entities.Request;
using Project.Repository.Interface;
using System.Diagnostics;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using System.Data;
using Dapper;

namespace FirstProject.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHomeRepository _homeRepository;
        private readonly IConfiguration _configuration;

        public HomeController(ILogger<HomeController> logger, IHomeRepository homeRepository, IConfiguration configuration)
        {
            _logger = logger;
            _homeRepository = homeRepository;
            _configuration = configuration;
        }


        #region Mission List and pass Params from Appsetting.json file
        public IActionResult Index(string? searchText)
        {
            var data = _homeRepository.GetMissionInfo();
            return View(data);
        }

        [HttpPost]
        public IActionResult MissionPagination(UserSearchParams queryParams)
        {
            //UserSearchParams queryParams
            //var PageIndex = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build().GetSection("spParams")["PageIndex"];
            var viewModel = _homeRepository.GetMissionInfo(queryParams.Search, queryParams.City, queryParams.Country, queryParams.Theme, queryParams.Skill, queryParams.StartDate, queryParams.EndDate, queryParams.MinRating, queryParams.MaxRating,queryParams.PageIndex, queryParams.PageSize);


            //UserSearchParams spParamsAll = _configuration.GetSection("spParams").Get<UserSearchParams>();
            //var viewModel = _homeRepository.GetMissionInfo(spParamsAll.Search, spParamsAll.City, spParamsAll.Country, spParamsAll.Theme, spParamsAll.Skill, spParamsAll.StartDate, spParamsAll.EndDate, spParamsAll.MinRating, spParamsAll.MaxRating, spParamsAll.PageIndex, spParamsAll.PageSize);

            return PartialView("_MissionList", viewModel);
        }

        #endregion

        #region test output param 

        public IActionResult CallAPI()
        {
            return View();
        }


        public IActionResult TransferData()
        {
            var connTrue = "Server=PCI53\\SQL2019;Initial Catalog=SQL-Practice;Persist Security Info=False;User ID=sa;Password=Tatva@123;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=False;Connection Timeout=60;";
            using (var connection = new SqlConnection(connTrue))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@outPut", dbType: DbType.String, direction: ParameterDirection.Output, size: 200);

                connection.Execute("SP_InsertOrUpdateIntoEmployeeTempTbl", parameters, commandType: CommandType.StoredProcedure);

                var message = parameters.Get<string>("@outPut");
            }

        #region ado testing for output param
            SqlConnection conn = new SqlConnection(connTrue);
            try
            {
                SqlParameter count = new SqlParameter
                {
                    ParameterName = "@outPut",
                    DbType = DbType.String,
                    Direction = ParameterDirection.Output
                };
                SqlCommand cmd = new SqlCommand("SP_InsertOrUpdateIntoEmployeeTempTbl", conn);

                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                cmd.ExecuteNonQuery();
                //conn.Execute("SP_InsertOrUpdateIntoEmployeeTempTbl", count, commandType: CommandType.StoredProcedure);
                var message = Convert.ToString(count.Value);
                conn.Close();
                //connTrue = "1";

                connTrue = message;

            }
            catch (Exception ex)
            {
                connTrue = "Connection is not Established with DataBase";
                EventLog.WriteEntry("Error", ex.Message, EventLogEntryType.Warning);
            }
            return View();
        }
        #endregion


        #endregion

        #region privacy and err
        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        #endregion
    }
}