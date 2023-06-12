using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Entities.Request
{
    public class AddNewEmployee
    {
        public int EmployeeID { get; set;}
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string gender { get; set; }
        public DateTime dateOfBirth { get; set; }
        public int departmentId { get; set; }
        public int salary { get; set; }
        public string address { get; set; }
        public int cityId { get; set; }
        public int pinCode { get; set; }
        public int isActive { get; set; } = 1;

       
    }
}
