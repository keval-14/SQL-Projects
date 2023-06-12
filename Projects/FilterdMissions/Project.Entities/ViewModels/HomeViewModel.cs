using Project.Entities.DataModels;
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
      
        public List<MissionListModel>? MissionList { get; set; }
        public List<GetDropdownDetailResponseModel> CityList { get; set; } = new List<GetDropdownDetailResponseModel>();
        public List<GetDropdownDetailResponseModel> CountryList { get; set; } = new List<GetDropdownDetailResponseModel>();
        public List<GetDropdownDetailResponseModel> ThemeList { get; set; } = new List<GetDropdownDetailResponseModel>();
        public List<GetDropdownDetailResponseModel> SkillList { get; set; } = new List<GetDropdownDetailResponseModel>();
       // public List<GetDropdownDetailResponseModel> OrganizationNameList { get; set; } = new List<GetDropdownDetailResponseModel>();




    }
}

