using CodeFirstApproach.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace CodeFirstApproach.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        ItemContext _itemContext;
        public HomeController(ILogger<HomeController> logger, ItemContext itemContext)
        {
            _logger = logger;
            _itemContext = itemContext;
        }

        #region ListofItems
        public IActionResult ListofItems()
        {
            var items = _itemContext.Items.ToList();

            HomeViewModel model = new()
            {
                items = items,
            };
            return View(model);
        }

        #endregion

        #region AddItem
        public IActionResult AddItem()
        {
            ViewBag.Message = TempData["Message"];
            return View();
        }

        [HttpPost]
        public IActionResult AddItem(Items item)
        {
            if (item.Item_Name != null)
            {
                _itemContext.Items.Add(item);
                _itemContext.SaveChanges();
            }

            TempData["Message"] = "Item Added Successfully..!";
            return RedirectToAction("AddItem");
        }

        #endregion

        #region privacy & Err
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