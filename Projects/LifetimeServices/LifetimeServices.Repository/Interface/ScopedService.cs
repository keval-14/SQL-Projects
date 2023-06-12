using System;
namespace LifetimeServices.Repository
{
    public interface ScopedService
    {
        Guid GetOperationID();

    }
}
