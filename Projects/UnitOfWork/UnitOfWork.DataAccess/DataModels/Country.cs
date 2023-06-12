using System;
using System.Collections.Generic;

namespace UnitOfWork.DataAccess.DataModels;

public partial class Country
{
    public int CountryId { get; set; }

    public string CountryName { get; set; } = null!;

    public virtual ICollection<State> States { get; set; } = new List<State>();
}
