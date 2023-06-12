using FirstProject.Models;
using Microsoft.AspNetCore.Mvc;
using Project.Entities.Request;
using Project.Repository.Interface;
using System.Diagnostics;
using Microsoft.Extensions.Configuration;


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