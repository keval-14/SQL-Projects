using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnitOfWork.Interfaces.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IEmployeeRepository Employee { get; }

        string save();
    }
}
