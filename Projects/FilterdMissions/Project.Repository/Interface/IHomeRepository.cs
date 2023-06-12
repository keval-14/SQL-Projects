using Project.Entities.DataModels;
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
                                                  
                                                    string? MinimunRating = null,
                                                    string? MaximumRating = null,
                                                    string? SkillIds = null,
                                                    string? StoryViews = null,
                                                   
                                                    int PageNumber = 1,
                                                    int PageSize = 10,
                                                    string? Expression = "mission_id",
                                                    int SortByAsc = 1
                                                    
                                                    );
    }
}
