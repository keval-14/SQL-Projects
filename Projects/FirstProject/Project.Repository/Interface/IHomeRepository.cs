using Project.Entities.Request;
using Project.Entities.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Repository.Interface
{
    public interface IHomeRepository
    {
        public HomeViewModel GetMissionInfo(
                                                     string? SearchText = null,
                                                     string? CityName = null,
                                                     string? CountryName = null,
                                                     string? ThemeName = null,
                                                     string? SkillName = null,
                                                     DateTime? StartDate = null,
                                                     DateTime? EndDate = null,
                                                     int? MinimunRating = null,
                                                     int? MaximumRating = null,
                                                     int PageIndx = 1,
                                                     int PageSize = 5
                                                     );
        
    public List<MissionListModel> SPAdo();
    }

}
