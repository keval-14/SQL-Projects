using Microsoft.AspNetCore.Mvc;
using PractiseProject.Models;
using Project.Repository.Repository;
using Project.Repository.Interface;
using System.Diagnostics;
using Project.Entities.ViewModels;
using System.Data;
using Project.Entities.Request;

namespace PractiseProject.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHomeRepository _homeRepository;
        public HomeController(ILogger<HomeController> logger, IHomeRepository homeRepository)
        {
            _logger = logger;
            _homeRepository = homeRepository;
        }

        public IActionResult Index(string? searchText)
        {
            var viewModel = _homeRepository.GetMissionInfo();
            return View(viewModel);
        }

        [HttpPost]
        public IActionResult MissionPagination(UserSearchParams queryParams)
        {
            if (string.IsNullOrEmpty(queryParams.Search))
            {
                queryParams.Search = null;
            }
            var viewModel = _homeRepository.GetMissionInfo(queryParams.Search, queryParams.CityId, queryParams.CountryId, queryParams.ThemeId, null,null,queryParams.StartDate,queryParams.EndDate,queryParams.MissionType, queryParams.OrganizationName, queryParams.MissionAvailibility, queryParams.Deadline, null, null, queryParams.MissionSkill,null, queryParams.PageNumber, queryParams.PageSize,queryParams.Expression,queryParams.IsSortByAsc);
            return PartialView("_MissionList", viewModel);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}