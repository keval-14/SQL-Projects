using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using UnitOfWork.DataAccess.EmpDbContext;
using UnitOfWork.Interfaces.Interfaces;

namespace UnitOfWork.Interfaces.Repository
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        private readonly SqlPracticeContext _SqlPracticeContext;
        private readonly DbSet<T> dbSet;

        public GenericRepository(SqlPracticeContext sqlPracticeContext)
        {
            _SqlPracticeContext = sqlPracticeContext;
            this.dbSet = _SqlPracticeContext.Set<T>();
        }

        #region Add
        public int Add(T entity)
        {
            var isAdded = dbSet.Add(entity);
            if (isAdded != null)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        #endregion

        #region GetAll
        public List<T> GetAll()
        {
            return dbSet.ToList();
            //return _SqlPracticeContext.Set<T>().ToList();  
        }

        #endregion

        #region GetFirstOrDefault
        public T GetFirstOrDefault(Expression<Func<T, bool>> Filter)
        {
            IQueryable<T> data = dbSet;
            data = data.Where(Filter);
            return data.FirstOrDefault();
        }

        #endregion

        #region Remove
        public void Remove(T entity)
        {
            dbSet.Remove(entity);
        }

        #endregion
    }
}
