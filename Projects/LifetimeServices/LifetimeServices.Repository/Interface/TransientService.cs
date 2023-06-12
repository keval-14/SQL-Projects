using System;

namespace LifetimeServices.Repository
{
    public interface TransientService
    {
        Guid GetOperationID();
    }
}
