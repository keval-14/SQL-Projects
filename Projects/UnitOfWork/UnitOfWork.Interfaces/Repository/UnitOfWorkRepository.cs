using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnitOfWork.DataAccess.EmpDbContext;
using UnitOfWork.Interfaces.Interfaces;

namespace UnitOfWork.Interfaces.Repository
{
    public class UnitOfWorkRepository : IUnitOfWork
    {
        private readonly SqlPracticeContext _context;
        private readonly string InnerException;

        public IEmployeeRepository Employee { get; private set; }
        public UnitOfWorkRepository(SqlPracticeContext sqlPracticeContext)
        {
            _context = sqlPracticeContext;
            Employee = new EmployeeRepository(_context);
        }

        #region Dispose
        public void Dispose()
        {
            _context.Dispose();
        }

        #endregion

        #region Save 
        public string save()
        {
            try
            {
                _context.SaveChanges();
                return "Success";
            }
            catch (Exception ex)
            {
                //var err = ex.InnerException;
                return ex.InnerException.Message;
            }
        }

        #endregion
    }
}
