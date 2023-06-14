using Microsoft.AspNetCore.Identity;
namespace OWINAuthentication.Models
{
    // ApplicationUser.cs

    public class ApplicationUser : IdentityUser
    {
        // You can add additional properties to the ApplicationUser class as per your requirements
        // For example, you can add a FirstName and LastName property:
        public string UserName { get; set; }
        public string Email { get; set; }
    }

}
