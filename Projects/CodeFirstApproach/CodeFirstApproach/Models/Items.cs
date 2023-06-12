using System.ComponentModel.DataAnnotations;

namespace CodeFirstApproach.Models
{
    public class Items
    {
        [Key]
        public long Item_Id { get; set; }
        public string Item_Name { get; set;}
        public string Item_Description { get; set;}
        public int Item_Status { get; set;}
        public long Item_Price { get; set; }
        public long Item_Quantity { get; set; }
        public int Item_SSNCode { get; set; }
    }
}
