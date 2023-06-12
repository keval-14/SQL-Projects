using Project.Entities.Request;
using Project.Entities.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Repository.Interface
{
    public interface ICRUDRepository
    {
        public string AddNewEmp(AddNewEmployee newEmp);
        public int UpdateEmployee(string[] EmployeeData, int empId);
        public string DeleteEmployee(int EmpId);
        public HomeViewModel ListOfEmployee(string sortValue, string sortOreder);
    }
}
