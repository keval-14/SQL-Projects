using System;
using System.Collections.Generic;

namespace Project.Entities.Models;

public partial class Notification
{
    public long NotificationId { get; set; }

    public long UserId { get; set; }

    public string NotificationText { get; set; } = null!;

    public byte IsReaded { get; set; }

    public DateTime? CreatedAt { get; set; }
}
