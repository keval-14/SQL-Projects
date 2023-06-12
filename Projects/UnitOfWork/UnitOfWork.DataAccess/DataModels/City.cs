using System;
using System.Collections.Generic;

namespace UnitOfWork.DataAccess.DataModels;

public partial class City
{
    public int CityId { get; set; }

    public string CityName { get; set; } = null!;

    public int StateId { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual State State { get; set; } = null!;
}
