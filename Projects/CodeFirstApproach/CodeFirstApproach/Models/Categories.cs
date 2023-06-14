using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CodeFirstApproach.Models
{
    public class Categories
    {
        [Key]
        public int CategoryId { get; set; }
        public  string Title { get; set; }
        public string Description { get; set; }
        public int Status { get; set; }
    }
}
