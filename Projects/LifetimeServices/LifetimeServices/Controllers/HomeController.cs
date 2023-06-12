using LifetimeServices.Models;
using LifetimeServices.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace LifetimeServices.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly TransientService _TS1;
        private readonly TransientService _TS2;
        private readonly ScopedService _SS1;
        private readonly ScopedService _SS2;
        private readonly SingletonService _SIS1;
        private readonly SingletonService _SIS2;
        public HomeController(ILogger<HomeController> logger, TransientService ts1, TransientService ts2, ScopedService ss1, ScopedService ss2, SingletonService sis1, SingletonService sis2)
        {
            _logger = logger;
            _TS1 = ts1; 
            _TS2 = ts2;
            _SS1 = ss1;
            _SS2 = ss2;
            _SIS1 = sis1;
            _SIS2 = sis2;
        }

        public IActionResult Index()
        {
            ViewBag.transient1 = _TS1.GetOperationID().ToString();
            ViewBag.transient2 = _TS2.GetOperationID().ToString();
            ViewBag.scoped1 = _SS1.GetOperationID().ToString();
            ViewBag.scoped2 = _SS2.GetOperationID().ToString();
            ViewBag.singleton1 = _SIS1.GetOperationID().ToString();
            ViewBag.singleton2 = _SIS2.GetOperationID().ToString();
            return View();
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