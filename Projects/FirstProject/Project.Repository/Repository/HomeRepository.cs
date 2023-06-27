using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Project.Entities.CIDbContext;
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

        private readonly IConfiguration _configuration;
        public string ConnectionString { get; }
        public string providerName { get; }
        public HomeRepository(CiMainContext CiMainContext, IConfiguration configuration)
        {
            _CiMainContext = CiMainContext;

            _configuration = configuration;
            ConnectionString = configuration.GetConnectionString("connstr");
            providerName = "using System.Data.SqlClient";
        }


        public IDbConnection Connection
        {
            get { return new SqlConnection(ConnectionString); }
        }



        public HomeViewModel GetMissionInfo(string? SearchText = null,
                                                     string? CityName = null,
                                                     string? CountryName = null,
                                                     string? ThemeName = null,
                                                     string? SkillName = null,
                                                     DateTime? StartDate = null,
                                                     DateTime? EndDate = null,
                                                     int? MinimunRating = null,
                                                     int? MaximumRating = null,
                                                     int PageIndx = 1,
                                                     int PageSize = 10
                                                    )

        {
            List<MissionListModel> listOfMissions;
            listOfMissions = _CiMainContext.Set<MissionListModel>().FromSqlRaw("SP_GetFilterdMissions @searchTerm,@city,@country,@theme,@skill,@startDate,@endDate,@minRating,@maxRating,@pageIndex,@pageSize",
                                                                    new SqlParameter("@searchTerm", SearchText ?? (object)DBNull.Value),
                                                                    new SqlParameter("@city", CityName ?? (object)DBNull.Value),
                                                                    new SqlParameter("@country", CountryName ?? (object)DBNull.Value),
                                                                    new SqlParameter("@theme", ThemeName ?? (object)DBNull.Value),
                                                                    new SqlParameter("@skill", SkillName ?? (object)DBNull.Value),
                                                                    new SqlParameter("@startDate", StartDate ?? (object)DBNull.Value),
                                                                    new SqlParameter("@endDate", EndDate ?? (object)DBNull.Value),
                                                                    new SqlParameter("@minRating", MinimunRating ?? (object)DBNull.Value),
                                                                    new SqlParameter("@maxRating", MaximumRating ?? (object)DBNull.Value),
                                                                    new SqlParameter("@pageIndex", PageIndx),
                                                                    new SqlParameter("@pageSize", PageSize)


                                                                  ).ToList();
            List<GetDropdownDataModel> citylist = new List<GetDropdownDataModel>();
            List<GetDropdownDataModel> countrylist = new List<GetDropdownDataModel>();
            List<GetDropdownDataModel> themelist = new List<GetDropdownDataModel>();
            List<GetDropdownDataModel> skilllist = new List<GetDropdownDataModel>();




            var cityList = _CiMainContext.Cities.OrderBy(C => C.Name).ToList();
            var countryList = _CiMainContext.Countries.OrderBy(Cn => Cn.Name).ToList();
            var themeList = _CiMainContext.MissionThemes.OrderBy(mt => mt.Title).Where(mt => mt.DeletedAt == null).ToList();
            var skillList = _CiMainContext.Skills.OrderBy(s => s.SkillName).Where(s => s.DeletedAt == null).ToList();



            if (cityList != null)
            {
                cityList.ForEach(x => citylist.Add(new GetDropdownDataModel() { Key = x.Name, Value = x.Name }));
            }
            if (countryList != null)
            {
                countryList.ForEach(x => countrylist.Add(new GetDropdownDataModel() { Key = x.Name, Value = x.Name }));
            }
            if (themelist != null)
            {
                themeList.ForEach(x => themelist.Add(new GetDropdownDataModel() { Key = x.Title, Value = x.Title }));
            }
            if (skillList != null)
            {
                skillList.ForEach(x => skilllist.Add(new GetDropdownDataModel() { Key = x.SkillName, Value = x.SkillName }));
            }

            var missionData = new HomeViewModel()
            {
                MissionList = listOfMissions,
                CityList = citylist,
                CountryList = countrylist,
                ThemeList = themelist,
                SkillList = skilllist

            };

            return missionData;
        }




        public List<MissionListModel> SPAdo()
        {

            List<MissionListModel> missions = new List<MissionListModel>();
            try
            {
                using (IDbConnection dbConnection = Connection)
                {
                    dbConnection.Open();
                    DynamicParameters param = new DynamicParameters();
                    param.Add("@searchTerm", "" ?? (object)DBNull.Value);
                    param.Add("@city", "" ?? (object)DBNull.Value);
                    param.Add("@country", "" ?? (object)DBNull.Value);
                    param.Add("@theme", "" ?? (object)DBNull.Value);
                    param.Add("@skill", "" ?? (object)DBNull.Value);
                    param.Add("@startDate", "2023-06-01" ?? (object)DBNull.Value);
                    param.Add("@endDate", "2023-06-30" ?? (object)DBNull.Value);
                    param.Add("@minRating", "5" ?? (object)DBNull.Value);
                    param.Add("@maxRating", "" ?? (object)DBNull.Value);
                    param.Add("@pageIndex", "" ?? (object)DBNull.Value);
                    param.Add("@pageSize", "" ?? (object)DBNull.Value);

                    //teamList = dbConnection.Query<GetTask>("GetSingleTeamTask", param, commandType: CommandType.StoredProcedure).ToList();
                    missions = dbConnection.Query<MissionListModel>("SP_GetFilterdMissions", param, commandType: CommandType.StoredProcedure).ToList();
                    dbConnection.Close();
                    return missions;
                }
            }
            catch (Exception ex)
            {
                string errMsg = ex.Message;
                return missions;
            }



        }


    }
}
