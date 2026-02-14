using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Bookstore.Domain
{
    public abstract class Entity
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("createdby")]
        public string CreatedBy { get; set; } = "System";

        [Column("createdon")]
        public DateTime CreatedOn { get; set; } = DateTime.UtcNow;

        [Column("updatedon")]
        public DateTime UpdatedOn { get; set; } = DateTime.UtcNow;

        //[Timestamp]
        //public long RowVersion { get; set; }

        // NotMapped attribute cannot be applied to methods, only to properties
        // This is a helper method that doesn't map to database
        public bool IsNewEntity()
        {
            return Id == 0;
        }
    }
}