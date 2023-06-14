using Microsoft.AspNet.Identity.EntityFramework;

namespace OWINAuthenticationAPI2._0.Data
{
    public class OwinAuthDbContext : IdentityDbContext
    {
        public OwinAuthDbContext()
            : base("OwinAuthDbContext")
        {
        }
    }
}
