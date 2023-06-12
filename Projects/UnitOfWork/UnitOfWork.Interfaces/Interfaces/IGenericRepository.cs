using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace UnitOfWork.Interfaces.Interfaces
{
    public interface IGenericRepository<T> where T : class
    {
        List<T> GetAll();
        int Add(T entity);
        void Remove(T entity);
        T GetFirstOrDefault(Expression<Func<T,bool>>Filter);
    }
}
