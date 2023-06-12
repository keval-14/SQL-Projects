using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Project.Entities.CIDbContext;
using Project.Entities.DataModels;
using Project.Entities.Request;
using Project.Entities.ViewModels;
using Project.Repository.Interface;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Repository.Repository
{
    public class HomeRepository : IHomeRepository
    {
        private readonly CiMainContext _CiMainContext;

        public object MissionResult { get; set; }

        public HomeRepository(CiMainContext CiMainContext)
        {
            _CiMainContext = CiMainContext;
        }

        public HomeViewModel GetMissionInfo(string? SearchText = null,
             long? CityId = null,
              long? CountryId = null,
                                                    long? ThemeId = null,


                                                    string? Title = null,
                                                    string? ShortDescription = null,

                                                    DateTime? StartDate = null,
                                                    DateTime? EndDate = null,
                                                    string? MissionType = null,

                                                    string? OrganizationName = null,

                                                    string? Availability = null,
                                                    //DateOnly? CreatedAt = null,
                                                    DateTime? Deadline = null,
                                                    string? minimum_rating = null,
                                                    string? maximum_rating = null,
                                                    string? SkillIds = null,
                                                    string? StoryViews = null,

                                                    int PageNumber = 2,
                                                    int PageSize = 10,

                                                    string? Expression = "mission_id",
                                                    int IsSortByAsc = 1
                                                    )
        {
            List<MissionListModel> details;
            details = _CiMainContext.Set<MissionListModel>().FromSqlRaw("TotalSearchInMissions @SearchText,@city_id,@country_id,@theme_id,@title,@short_description,@start_date,@end_date,@mission_type,@organization_name,@availability,@deadline,@minimum_rating,@maximum_rating,@skillids,@storyviews,@PageNumber,@PageSize,@Expression,@IsSortByAsc",
                                                                    new SqlParameter("@SearchText", SearchText ?? (object)DBNull.Value),
                                                                     new SqlParameter("@city_id", CityId ?? (object)DBNull.Value),
                                                                     new SqlParameter("@country_id", CountryId ?? (object)DBNull.Value),
                                                                    new SqlParameter("@theme_id", ThemeId ?? (object)DBNull.Value),


                                                                    new SqlParameter("@title", Title ?? (object)DBNull.Value),
                                                                    new SqlParameter("@short_description", ShortDescription ?? (object)DBNull.Value),

                                                                    new SqlParameter("@start_date", StartDate ?? (object)DBNull.Value),
                                                                    new SqlParameter("@end_date", EndDate ?? (object)DBNull.Value),
                                                                    new SqlParameter("@mission_type", MissionType ?? (object)DBNull.Value),

                                                                    new SqlParameter("@organization_name", OrganizationName ?? (object)DBNull.Value),

                                                                    new SqlParameter("@availability", Availability ?? (object)DBNull.Value),
                                                                    //new SqlParameter("@created_at", CreatedAt ?? (object)DBNull.Value),
                                                                    new SqlParameter("@deadline", Deadline ?? (object)DBNull.Value),
                                                                    new SqlParameter("@minimum_rating", minimum_rating ?? (object)DBNull.Value),
                                                                    new SqlParameter("@maximum_rating", maximum_rating ?? (object)DBNull.Value),
                                                                    new SqlParameter("@skillids", SkillIds ?? (object)DBNull.Value),
                                                                    new SqlParameter("@storyviews", StoryViews ?? (object)DBNull.Value),
                                                                    new SqlParameter("@PageNumber", PageNumber),
                                                                    new SqlParameter("@PageSize", PageSize),
                                                                    new SqlParameter("@Expression", Expression),
                                                                    new SqlParameter("@IsSortByAsc", IsSortByAsc)
                                                                  ).ToList();
            List<GetDropdownDetailResponseModel> citylist = new List<GetDropdownDetailResponseModel>();
            List<GetDropdownDetailResponseModel> countrylist = new List<GetDropdownDetailResponseModel>();
            List<GetDropdownDetailResponseModel> themelist = new List<GetDropdownDetailResponseModel>();
            List<GetDropdownDetailResponseModel> skilllist = new List<GetDropdownDetailResponseModel>();



            var cityList = _CiMainContext.Cities.ToList();
            var countryList = _CiMainContext.Countries.ToList();
            var themeList = _CiMainContext.MissionThemes.Where(mt => mt.DeletedAt == null).ToList();
            var skillList = _CiMainContext.Skills.Where(mt => mt.DeletedAt == null).ToList();



            if (cityList != null)
            {
                cityList.ForEach(x => citylist.Add(new GetDropdownDetailResponseModel() { Key = Convert.ToString(x.CityId), Value = x.Name }));
            }
            if (countryList != null)
            {
                countryList.ForEach(x => countrylist.Add(new GetDropdownDetailResponseModel() { Key = Convert.ToString(x.CountryId), Value = x.Name }));
            }
            if (themelist != null)
            {
                themeList.ForEach(x => themelist.Add(new GetDropdownDetailResponseModel() { Key = Convert.ToString(x.MissionThemeId), Value = x.Title }));
            }
            if (skillList != null)
            {
                skillList.ForEach(x => skilllist.Add(new GetDropdownDetailResponseModel() { Key = Convert.ToString(x.SkillId), Value = x.SkillName }));
            }


            var viewModel = new HomeViewModel()
            {
                MissionList = details,
                CityList = citylist,
                CountryList = countrylist,
                ThemeList = themelist,
                SkillList = skilllist

            };
            return viewModel;
        }
    }
}
