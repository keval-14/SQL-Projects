using System;
using System.Collections.Generic;

namespace UnitOfWork.DataAccess.DataModels;

public partial class DbLog
{
    public string? Dbname { get; set; }

    public string? TableName { get; set; }

    public string? EventType { get; set; }

    public string? LoginName { get; set; }

    public string? SqlQuery { get; set; }

    public DateTime? AuditDateTime { get; set; }
}
