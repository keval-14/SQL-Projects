using Microsoft.EntityFrameworkCore;
using Project.Entites.CIDbContext;
using Project.Repository.Interface;
using Project.Repository.Repository;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddScoped<IHomeRepository, HomeRepository>();
builder.Services.AddScoped<ICRUDRepository, CRUDRepository>();

var configuration = builder.Configuration;

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
pattern: "{controller=CRUD}/{action=ListOfEmployee}/{id?}");
//pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
