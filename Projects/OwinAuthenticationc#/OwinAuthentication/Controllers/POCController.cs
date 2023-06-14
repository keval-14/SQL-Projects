using System.Web.Http;

namespace OwinAuthentication.Controllers
{
    [Authorize]
    public class POCController : ApiController
    {
        [HttpGet]
        [Route("api/TestMethod")]
        public string TestMethod()
        {
            return "Hello, C# Corner Member. ";
        }
        
    }
}
