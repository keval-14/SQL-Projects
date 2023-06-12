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
        public long? CityId { get; set; }
        public long? CountryId { get; set; }
        public long? ThemeId { get; set; }
        public string? MissionSkill { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? Deadline { get; set; }
        public string? MissionType { get; set; }
        public string? MissionAvailibility { get; set; }
        public string? OrganizationName { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public int IsSortByAsc { get; set; } = 1;
        public string? Expression { get; set; } = "mission_id";
    }
}
