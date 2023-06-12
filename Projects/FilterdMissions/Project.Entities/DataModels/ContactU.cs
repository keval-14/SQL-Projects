using System;
using System.Collections.Generic;

namespace Project.Entities.DataModels;

public partial class ContactU
{
    public long ContactUsId { get; set; }

    public long? UserId { get; set; }

    public string? UserName { get; set; }

    public string? UserEmail { get; set; }

    public string? Subject { get; set; }

    public string? Message { get; set; }

    public DateTime? CreatedAt { get; set; }
}
