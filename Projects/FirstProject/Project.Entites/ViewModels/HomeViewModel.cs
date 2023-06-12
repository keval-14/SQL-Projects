using Project.Entities.ViewModels;
using Microsoft.EntityFrameworkCore;
using Project.Entities.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Project.Entities.ViewModels
{
    public class HomeViewModel
    {
      
        public List<MissionListModel> MissionList { get; set; }
        public List<AddNewEmployee> AddNewEmployee { get; set; }
        public List<GetDropdownDataModel> CityList { get; set; } = new List<GetDropdownDataModel>();
        public List<GetDropdownDataModel> CountryList { get; set; } = new List<GetDropdownDataModel>();
        public List<GetDropdownDataModel> ThemeList { get; set; } = new List<GetDropdownDataModel>();
        public List<GetDropdownDataModel> SkillList { get; set; } = new List<GetDropdownDataModel>();
       




    }
}

