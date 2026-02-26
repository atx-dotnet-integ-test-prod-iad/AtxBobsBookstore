namespace Bookstore.Domain.Authors;

// This is a result class (DTO) not mapped to a database table
public class AuthorAgeResult
{
    public int BusinessEntityID { get; set; }
    public string FormattedModifiedDate { get; set; }
    public int Age { get; set; }
}
