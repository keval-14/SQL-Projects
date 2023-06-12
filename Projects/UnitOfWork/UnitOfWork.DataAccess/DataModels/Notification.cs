using System;
using System.Collections.Generic;

namespace UnitOfWork.DataAccess.DataModels;

public partial class Notification
{
    public int Id { get; set; }

    public string? Message { get; set; }
}
