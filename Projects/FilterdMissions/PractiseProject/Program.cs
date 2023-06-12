using Microsoft.EntityFrameworkCore;
using Project.Entities.CIDbContext;
using Project.Entities.DataModels;
using Project.Repository.Interface;
using Project.Repository.Repository;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddScoped<IHomeRepository, HomeRepository>();

builder.Services.AddSession();
// Load configuration from appsettings.json file
var configuration = builder.Configuration;
//// Configure the database context to use SQL Server
builder.Services.AddDbContext<CiMainContext>(options => options.UseSqlServer(configuration.GetConnectionString("connstr")));
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();