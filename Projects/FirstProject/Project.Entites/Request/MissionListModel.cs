using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Entities.Request
{
    public class MissionListModel
    {
        [Key]
        public long No { get; set; }
        public string? Title { get; set; }
        public string?  City { get; set; }
        public string? Country { get; set; }
        public string? Theme { get; set; }
        public string? Description { get; set; }
        public string? ShortDescription { get; set; }
        public string? OrganizationName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string? MissionType { get; set; }
        public decimal AVGRating { get; set; }
        public string? SkillList { get; set; }
        public int TotalRecords { get; set; }
    }
}
