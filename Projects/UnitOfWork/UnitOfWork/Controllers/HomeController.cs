using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using UnitOfWork.DataAccess.DataModels;
using UnitOfWork.Interfaces.Interfaces;
using UnitOfWork.Models;

namespace UnitOfWork.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IUnitOfWork _unitOfWork;
        public HomeController(ILogger<HomeController> logger, IUnitOfWork unitOfWork)
        {
            _logger = logger;
            _unitOfWork = unitOfWork;
        }

        #region List Employee
        public ViewResult Index()
        {
            var employees = _unitOfWork.Employee.GetAll();

            ViewModel viewModel = new()
            {

                Employees = employees
            };

            return View(viewModel);

        }

        #endregion

        #region AddNewEmployee

        public IActionResult AddNewEmployee()
        {
            ViewBag.Error = TempData["Error"];
            ViewBag.Message = TempData["Message"];
            return View();
        }

        public IActionResult AddNewEmp(Employee newEmp)
        {
            if (newEmp.FirstName != null)
            {
                _unitOfWork.Employee.Add(newEmp);

                var newEmpAdd = _unitOfWork.save();

                if (newEmpAdd != "Success")
                {
                    TempData["Error"] = "Age Must be Greater or Equal to 18 Years...!";
                    return RedirectToAction("AddNewEmployee");
                }
                else
                {
                    TempData["Message"] = "Registred Successfully..!";
                    return RedirectToAction("AddNewEmployee");
                }
            }
            else
            {
                return View();
            }
        }

        #endregion

        #region DeleteEmployee
        public IActionResult DeleteEmployee(int EmpId)
        {
            if (EmpId != null)
            {
                var obj = _unitOfWork.Employee.GetFirstOrDefault(E => E.EmployeeId == EmpId);
                _unitOfWork.Employee.Remove(obj);
                var responce = _unitOfWork.save();
            }

            return RedirectToAction("Index");
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