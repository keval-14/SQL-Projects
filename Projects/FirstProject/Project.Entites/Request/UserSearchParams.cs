using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Entities.Request
{
    public class UserSearchParams
    {
        public string? Search { get; set; }
        public string? City { get; set; }
        public string? Country { get; set; }
        public string? Theme { get; set; }
        public string? Skill { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? MinRating { get; set; }
        public int? MaxRating { get; set; }
        public int PageIndex { get; set; } = 1;
        public int PageSize { get; set; }
    }
}
