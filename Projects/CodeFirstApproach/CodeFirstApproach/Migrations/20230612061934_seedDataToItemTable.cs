using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CodeFirstApproach.Migrations
{
    /// <inheritdoc />
    public partial class seedDataToItemTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Items",
                columns: new[] { "Item_Id", "Item_Description", "Item_Name", "Item_Price", "Item_Quantity", "Item_SSNCode", "Item_Status" },
                values: new object[] { 1L, "Food product made from cocoa beans, consumed as candy and used to make beverages and to flavour or coat various confections and bakery products. Rich in carbohydrates, it has several health benefits and is an excellent source of quick energy.", "Chocolate", 250L, 500L, 32507, 1 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Items",
                keyColumn: "Item_Id",
                keyValue: 1L);
        }
    }
}
