using Microsoft.EntityFrameworkCore;

namespace CodeFirstApproach.Models
{
    public class ItemContext : DbContext
    {
        public ItemContext(DbContextOptions<ItemContext> options): base(options)
        {

        }

        public DbSet<Items> Items { get; set; }
        public DbSet<Categories> categories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Items>().HasData(
                new Items() { Item_Id = 1, Item_Name = "Chocolate", Item_Description = "Food product made from cocoa beans, consumed as candy and used to make beverages and to flavour or coat various confections and bakery products. Rich in carbohydrates, it has several health benefits and is an excellent source of quick energy.", Item_Price = 250, Item_Quantity = 500, Item_SSNCode = 32507, Item_Status = 1, CategoryId = 2 }

                );
        }

    }
}
