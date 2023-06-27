using System;
using System.Collections.Generic;

namespace Project.Entities.Models;

public partial class MissionDetail
{
    public long MissionId { get; set; }

    public long? CityId { get; set; }

    public string? CityName { get; set; }

    public long? CountryId { get; set; }

    public string? CountryName { get; set; }

    public long? ThemeId { get; set; }

    public string? ThemeName { get; set; }

    public string Title { get; set; } = null!;

    public string? ShortDescription { get; set; }

    public string? Description { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public string MissionType { get; set; } = null!;

    public string? Status { get; set; }

    public DateTime? Deadline { get; set; }

    public string? OrganizationName { get; set; }

    public string? OrganizationDetail { get; set; }

    public string? Availability { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public DateTime? DeletedAt { get; set; }
}
