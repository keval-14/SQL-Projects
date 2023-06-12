using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnitOfWork.Models
{
    public class AddNewEmployee
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public DateTime DateofBirth { get; set; }
        public int DepartmentId { get; set; }
        public int Salary { get; set; }
        public string Address { get; set; }
        public int CityId { get; set; }
        public int PinCode { get; set; }
        public int IsActive { get; set; } = 1;

       
    }
}
