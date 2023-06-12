using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnitOfWork.DataAccess.DataModels;
using UnitOfWork.DataAccess.EmpDbContext;
using UnitOfWork.Interfaces.Interfaces;

namespace UnitOfWork.Interfaces.Repository
{
    public class EmployeeRepository : GenericRepository<Employee>, IEmployeeRepository
    {
        private readonly SqlPracticeContext _context;
        public EmployeeRepository(SqlPracticeContext sqlPracticeContext) : base(sqlPracticeContext)
        {
            _context = sqlPracticeContext;
        }
    }
}
