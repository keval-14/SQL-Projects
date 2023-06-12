using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnitOfWork.DataAccess.DataModels;

namespace UnitOfWork.Interfaces.Interfaces
{
    public interface IEmployeeRepository : IGenericRepository<Employee>
    {
    }
}
