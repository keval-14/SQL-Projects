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
        public int RowNum { get; set; }
        public long mission_id { get; set; }
        public long theme_id { get; set; }  
        public string? themeName { get; set; }
        public long country_id { get; set; }
        public string? countryName { get; set; }
        public long city_id { get; set; }
        public string? cityName { get; set; }
        public string? title { get; set; }
        public string? short_description { get; set; }
        //public datetime? description { get; set; }
        public DateTime? start_date { get; set; }
        public DateTime? end_date { get; set; }
        public string? mission_type { get; set; }
        
        public string? organization_name { get; set; }
        
        public string? availability { get; set; }
        //public string? created_at { get; set; }
        public DateTime? deadline { get; set; }
       
        //public int? avg_rating { get; set; }
        public int TotalCount { get; set; }
    }
}
