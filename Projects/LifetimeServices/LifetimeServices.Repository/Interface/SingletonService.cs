using System;
namespace LifetimeServices.Repository
{
    public interface SingletonService
    {
        Guid GetOperationID();
    }
}
