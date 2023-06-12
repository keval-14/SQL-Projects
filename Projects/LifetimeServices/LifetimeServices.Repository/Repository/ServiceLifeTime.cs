using System;
namespace LifetimeServices.Repository.Repository
{
    public class ServiceLifeTime : ScopedService, TransientService, SingletonService
    {
        Guid id;
        public ServiceLifeTime()
        {
            id = Guid.NewGuid();
        }
        public Guid GetOperationID()
        {
            return id;
        }
    }
}
