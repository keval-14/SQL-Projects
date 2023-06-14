using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace OWINAuthDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize]
    public class HomeController : ControllerBase
    {
        [HttpGet]
        [Route("/TestMethod")]
        public string TestMethod(string uName, string password)
        {
            return "Hello, C# Corner Member. ";
        }
    }
}
