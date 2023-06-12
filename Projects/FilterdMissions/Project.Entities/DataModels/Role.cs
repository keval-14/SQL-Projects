using System;
using System.Collections.Generic;

namespace Project.Entities.DataModels;

public partial class Role
{
    public long RoleId { get; set; }

    public string? RoleName { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public DateTime? DeletedAt { get; set; }

    public virtual ICollection<Admin> Admins { get; set; } = new List<Admin>();
}
