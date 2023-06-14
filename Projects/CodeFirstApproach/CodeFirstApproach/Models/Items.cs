using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CodeFirstApproach.Models
{
    public class Items
    {
        [Key]
        public long Item_Id { get; set; }
        public string Item_Name { get; set;}
        public string? Item_Description { get; set; } = null;
        public int Item_Status { get; set;}
        public long Item_Price { get; set; }
        public long Item_Quantity { get; set; }
        public int Item_SSNCode { get; set; }


        //public int? CategoryId { get; set; } = null;
        //public Categories Categories { get; set; }


        public int CategoryId { get; set; }
        [ForeignKey("CategoryId")]
        public virtual Categories Categories { get; set; }



        //[Display(Name = "Categories")]
        //public virtual int? CategoryId { get; set; }

        //[ForeignKey("CategoryId")]
        //public virtual Categories Categories { get; set; }




    }
}
