using FirstProject.Common;
using FirstProject.Models;
using Microsoft.AspNetCore.Mvc;
using Project.Entities.Request;
using Project.Entities.ViewModels;
using Project.Repository.Interface;
using Project.Repository.Repository;

namespace FirstProject.Controllers
{
    public class CRUDController : Controller
    {
        private readonly ILogger<CRUDController> _logger;
        private readonly ICRUDRepository _CRUDRepository;
        private readonly IConfiguration _configuration;
        
        public CRUDController(ILogger<CRUDController> logger, ICRUDRepository CRUDRepository, IConfiguration configuration)
        {
            _logger = logger;
            _CRUDRepository = CRUDRepository;
            _configuration = configuration;
        }

        #region ListOfEmployee & AJAX


        public IActionResult ListOfEmployee()
        {
            return View();
        }

        [HttpPost]
        public IActionResult ListOfEmployeeAjax(int pageSize, ShowPaging model,  string sortValue, string sortOreder, int page = 1, int inputNumber = 1)
        {

            var empData = _CRUDRepository.ListOfEmployee(sortValue, sortOreder);
            //set model.pageinfo
            model.PageInfo = new PageInfo();
            model.PageInfo.CurrentPage = page;
            model.PageInfo.ItemsPerPage = pageSize == 0 ? 5 : pageSize;
            model.PageInfo.TotalItems = empData.AddNewEmployee.Count();

            var employeesList = empData.AddNewEmployee.ToList();
            var empToBeSent = employeesList.Skip(model.PageInfo.PageStart).Take(pageSize == 0 ? 5 : pageSize);

            model.AddNewEmployee = empToBeSent.ToList();

            return PartialView("_EmployeeList",model);

        }

        #endregion

        #region working before PageSize DD

        //private const int PAGE_SIZE = 10;

        //public IActionResult ListOfEmployee(ShowPaging model, int page = 1, int inputNumber = 1)
        //{

        //    var empData = _CRUDRepository.ListOfEmployee();
        //    //set model.pageinfo
        //    model.PageInfo = new PageInfo();
        //    model.PageInfo.CurrentPage = page;
        //    model.PageInfo.ItemsPerPage = PAGE_SIZE;
        //    model.PageInfo.TotalItems = empData.AddNewEmployee.Count();



        //    var employeesList = empData.AddNewEmployee.ToList();
        //    var empToBeSent = employeesList.Skip(model.PageInfo.PageStart).Take(PAGE_SIZE);


        //    model.AddNewEmployee = empToBeSent.ToList();

        //    return View(model);

        //}

        #endregion

        #region Add New Emp

        public IActionResult AddNewEmployee()
        {
            ViewBag.Error = TempData["Error"];
            ViewBag.Message = TempData["Message"];
            return View();
        }


        public IActionResult AddNewEmp(AddNewEmployee newEmp)
        {
            if (newEmp.firstName != null)
            {

                var newEmpAdd = _CRUDRepository.AddNewEmp(newEmp);

                if (newEmpAdd == "0")
                {
                    TempData["Error"] = "Email Already Exists, Please enter new Email Address...!";
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

        #region UpdateEmployee

        [HttpPost]
        public JsonResult UpdateEmployee(string[] EmployeeData, int empId)
        {
            var newEmpAdd = _CRUDRepository.UpdateEmployee(EmployeeData, empId);


            return Json(newEmpAdd);
        }


        #endregion

        #region DeleteEmployee
        public IActionResult DeleteEmployee(int EmpId)
        {
            var deleteEmp = _CRUDRepository.DeleteEmployee(EmpId);

            if (deleteEmp == "1")
            {
                return Json(true);
            }
            else
            {
                return Json(false); 
            }
        }

        #endregion
    }
}
