using System;
using System.Collections.Generic;

namespace Project.Entities.Models;

public partial class VwGetMissionDatum
{
    public string MissionTitle { get; set; } = null!;

    public int NoOfDocs { get; set; }

    public int NoOfMedia { get; set; }

    public int NoOfApplications { get; set; }

    public int NoOfInvitations { get; set; }
}
