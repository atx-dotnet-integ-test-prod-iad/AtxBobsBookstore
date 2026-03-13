# EF Core Migration Transformation Guide — Bookstore.Data (PostgreSQL)

> **Status**: No migration files exist yet. This guide must be applied to every
> migration file generated in this folder.
>
> - **EF Version**: EF Core 8.0  
> - **Source provider**: Microsoft SQL Server  
> - **Target provider**: PostgreSQL (Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0)  
> - **Target schema**: `bobsbookstore_dbo`  

---

## 1. Using-Statement Changes

| Action | Statement |
|--------|-----------|
| **ADD** | `using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;` |
| **REMOVE** | `using Microsoft.EntityFrameworkCore.SqlServer.Metadata;` (if present) |

---

## 2. SQL Server → PostgreSQL Annotation Replacement

Every auto-increment / identity column must replace the SQL Server annotation:

```csharp
// BEFORE (SQL Server)
.Annotation("SqlServer:Identity", "1, 1")
// or
.Annotation("SqlServer:ValueGenerationStrategy",
            SqlServerValueGenerationStrategy.IdentityColumn)

// AFTER (PostgreSQL)
.Annotation("Npgsql:ValueGenerationStrategy",
            NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
```

---

## 3. SQL Server → PostgreSQL Data-Type Map

| SQL Server type | PostgreSQL type |
|-----------------|-----------------|
| `nvarchar(max)` | `text` |
| `nvarchar(n)` | `varchar(n)` |
| `varchar(max)` | `text` |
| `varchar(n)` | `varchar(n)` |
| `nchar(n)` | `char(n)` |
| `char(n)` | `char(n)` |
| `datetime` | `timestamp without time zone` |
| `datetime2` | `timestamp without time zone` |
| `datetimeoffset` | `timestamp with time zone` |
| `smalldatetime` | `timestamp without time zone` |
| `date` | `date` |
| `time` | `time without time zone` |
| `bit` | `boolean` |
| `tinyint` | `smallint` |
| `smallint` | `smallint` |
| `int` | `integer` |
| `bigint` | `bigint` |
| `decimal(p,s)` | `numeric(p,s)` |
| `numeric(p,s)` | `numeric(p,s)` |
| `money` | `numeric(19,4)` |
| `smallmoney` | `numeric(10,4)` |
| `float` | `double precision` |
| `real` | `real` |
| `uniqueidentifier` | `uuid` |
| `varbinary(max)` | `bytea` |
| `varbinary(n)` | `bytea` |
| `image` | `bytea` |
| `xml` | `xml` |
| `rowversion` | `bytea` |
| `timestamp` | `bytea` |

---

## 4. Schema & Name Mappings (from ApplicationDbContext)

> **Target schema for ALL tables**: `bobsbookstore_dbo`

### 4.1 Table Name Mappings

| Source (SQL Server) | Target (PostgreSQL) |
|---------------------|---------------------|
| `Address` | `address` |
| `Book` | `book` |
| `Customer` | `customer` |
| `Order` | `Order` |
| `ShoppingCart` | `shoppingcart` |
| `ShoppingCartItem` | `shoppingcartitem` |
| `OrderItem` | `orderitem` |
| `Offer` | `offer` |
| `Author` | `author` |
| `Product` | `product` |
| `ReferenceData` | `referencedata` |

### 4.2 Column Name Mappings

#### address
| Source | Target |
|--------|--------|
| `AddressLine1` | `addressline1` |
| `AddressLine2` | `addressline2` |
| `City` | `city` |
| `State` | `state` |
| `Country` | `country` |
| `ZipCode` | `zipcode` |
| `CustomerId` | `customerid` |
| `IsActive` | `isactive` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### book
| Source | Target |
|--------|--------|
| `Name` | `name` |
| `Author` | `author` |
| `Year` | `year` |
| `ISBN` | `isbn` |
| `PublisherId` | `publisherid` |
| `BookTypeId` | `booktypeid` |
| `GenreId` | `genreid` |
| `ConditionId` | `conditionid` |
| `CoverImageUrl` | `coverimageurl` |
| `Summary` | `summary` |
| `Price` | `price` |
| `Quantity` | `quantity` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### customer
| Source | Target |
|--------|--------|
| `Sub` | `sub` |
| `Username` | `username` |
| `FirstName` | `firstname` |
| `LastName` | `lastname` |
| `Email` | `email` |
| `DateOfBirth` | `dateofbirth` |
| `Phone` | `phone` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### Order
| Source | Target |
|--------|--------|
| `CustomerId` | `customerid` |
| `AddressId` | `addressid` |
| `DeliveryDate` | `deliverydate` |
| `OrderStatus` | `orderstatus` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### shoppingcart
| Source | Target |
|--------|--------|
| `CorrelationId` | `correlationid` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### shoppingcartitem
| Source | Target |
|--------|--------|
| `ShoppingCartId` | `shoppingcartid` |
| `BookId` | `bookid` |
| `Quantity` | `quantity` |
| `WantToBuy` | `wanttobuy` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### orderitem
| Source | Target |
|--------|--------|
| `OrderId` | `orderid` |
| `BookId` | `bookid` |
| `Quantity` | `quantity` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### offer
| Source | Target |
|--------|--------|
| `Author` | `author` |
| `ISBN` | `isbn` |
| `BookName` | `bookname` |
| `FrontUrl` | `fronturl` |
| `GenreId` | `genreid` |
| `ConditionId` | `conditionid` |
| `PublisherId` | `publisherid` |
| `BookTypeId` | `booktypeid` |
| `Summary` | `summary` |
| `OfferStatus` | `offerstatus` |
| `Comment` | `comment` |
| `CustomerId` | `customerid` |
| `BookPrice` | `bookprice` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

#### author
| Source | Target |
|--------|--------|
| `BusinessEntityID` | `businessentityid` |
| `NationalIDNumber` | `nationalidnumber` |
| `LoginID` | `loginid` |
| `JobTitle` | `jobtitle` |
| `BirthDate` | `birthdate` |
| `MaritalStatus` | `maritalstatus` |
| `Gender` | `gender` |
| `HireDate` | `hiredate` |
| `VacationHours` | `vacationhours` |
| `ModifiedDate` | `modifieddate` |

#### product
| Source | Target |
|--------|--------|
| `ProductID` | `productid` |
| `Name` | `name` |
| `ProductNumber` | `productnumber` |
| `SafetyStockLevel` | `safetystocklevel` |

#### referencedata
| Source | Target |
|--------|--------|
| `DataType` | `datatype` |
| `Text` | `text` |
| `Id` | `id` |
| `CreatedBy` | `createdby` |
| `CreatedOn` | `createdon` |
| `UpdatedOn` | `updatedon` |

---

## 5. Operation-Level Transformation Patterns

### 5.1 CreateTable
```csharp
// BEFORE
migrationBuilder.CreateTable(
    name: "Address",
    columns: table => new
    {
        Id = table.Column<int>(type: "int", nullable: false)
            .Annotation("SqlServer:Identity", "1, 1"),
        AddressLine1 = table.Column<string>(type: "nvarchar(200)", nullable: true),
        IsActive     = table.Column<bool>(type: "bit", nullable: false),
        CreatedOn    = table.Column<DateTime>(type: "datetime2", nullable: false),
        CustomerId   = table.Column<int>(type: "int", nullable: false)
    },
    constraints: table =>
    {
        table.PrimaryKey("PK_Address", x => x.Id);
        table.ForeignKey(
            name: "FK_Address_Customer_CustomerId",
            column: x => x.CustomerId,
            principalTable: "Customer",
            principalColumn: "Id",
            onDelete: ReferentialAction.Restrict);
    });

// AFTER
migrationBuilder.CreateTable(
    name: "address",
    schema: "bobsbookstore_dbo",
    columns: table => new
    {
        id = table.Column<int>(type: "integer", nullable: false)
            .Annotation("Npgsql:ValueGenerationStrategy",
                        NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
        addressline1 = table.Column<string>(type: "varchar(200)", nullable: true),
        isactive     = table.Column<bool>(type: "boolean", nullable: false),
        createdon    = table.Column<DateTime>(type: "timestamp without time zone",
                                              nullable: false),
        customerid   = table.Column<int>(type: "integer", nullable: false)
    },
    constraints: table =>
    {
        table.PrimaryKey("pk_address", x => x.id);
        table.ForeignKey(
            name: "fk_address_customer_customerid",
            column: x => x.customerid,
            principalTable: "customer",
            principalSchema: "bobsbookstore_dbo",
            principalColumn: "id",
            onDelete: ReferentialAction.Restrict);
    });
```

### 5.2 AddColumn
```csharp
// BEFORE
migrationBuilder.AddColumn<string>(
    name: "CoverImageUrl",
    table: "Book",
    type: "nvarchar(max)",
    nullable: true);

// AFTER
migrationBuilder.AddColumn<string>(
    name: "coverimageurl",
    table: "book",
    schema: "bobsbookstore_dbo",
    type: "text",
    nullable: true);
```

### 5.3 CreateIndex
```csharp
// BEFORE
migrationBuilder.CreateIndex(
    name: "IX_Address_CustomerId",
    table: "Address",
    column: "CustomerId");

// AFTER
migrationBuilder.CreateIndex(
    name: "ix_address_customerid",
    table: "address",
    schema: "bobsbookstore_dbo",
    column: "customerid");
```

### 5.4 AddForeignKey
```csharp
// BEFORE
migrationBuilder.AddForeignKey(
    name: "FK_Book_ReferenceData_GenreId",
    table: "Book",
    column: "GenreId",
    principalTable: "ReferenceData",
    principalColumn: "Id",
    onDelete: ReferentialAction.Restrict);

// AFTER
migrationBuilder.AddForeignKey(
    name: "fk_book_referencedata_genreid",
    table: "book",
    schema: "bobsbookstore_dbo",
    column: "genreid",
    principalTable: "referencedata",
    principalSchema: "bobsbookstore_dbo",
    principalColumn: "id",
    onDelete: ReferentialAction.Restrict);
```

### 5.5 DropTable / DropColumn / DropIndex / DropForeignKey
Add `schema: "bobsbookstore_dbo"` and apply the same name mappings as the
corresponding `Create*` / `Add*` call.

```csharp
// BEFORE
migrationBuilder.DropTable(name: "ShoppingCartItem");

// AFTER
migrationBuilder.DropTable(name: "shoppingcartitem", schema: "bobsbookstore_dbo");
```

### 5.6 RenameColumn / RenameTable
Apply lowercase target names from the mappings table above.

### 5.7 Raw SQL (migrationBuilder.Sql)
```csharp
// BEFORE
migrationBuilder.Sql(
    "CREATE INDEX IX_Customer_Sub ON dbo.Customer(Sub)");

// AFTER
migrationBuilder.Sql(
    "CREATE INDEX ix_customer_sub ON bobsbookstore_dbo.customer(sub)");
```
Additional SQL dialect rules:
- Remove square-bracket identifiers: `[TableName]` → `tablename` (unquoted) or
  `"tablename"` (quoted).
- `GETDATE()` → `NOW()`
- `ISNULL(x, y)` → `COALESCE(x, y)`
- `TOP n` → `LIMIT n`
- `+` string concatenation → `||`

---

## 6. Constraint / Index Naming Convention

| Kind | Pattern |
|------|---------|
| Primary key | `pk_{table}` |
| Foreign key | `fk_{table}_{principalTable}_{column}` |
| Unique index | `uq_{table}_{column}` |
| Regular index | `ix_{table}_{column}` |

All names must be **lower-case**.

---

## 7. Checklist for Every Future Migration File

- [ ] EF version confirmed as EF Core 8.0
- [ ] `using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;` added
- [ ] `using Microsoft.EntityFrameworkCore.SqlServer.Metadata;` removed (if present)
- [ ] All SQL Server types converted per Section 3
- [ ] `SqlServer:Identity` / `SqlServer:ValueGenerationStrategy` annotations
      replaced with `Npgsql:ValueGenerationStrategy IdentityByDefaultColumn`
- [ ] `schema: "bobsbookstore_dbo"` added to every table operation
- [ ] Table names lowercased per Section 4.1
- [ ] Column names lowercased per Section 4.2
- [ ] `principalSchema: "bobsbookstore_dbo"` added to every foreign-key operation
- [ ] Index names lowercased
- [ ] Foreign-key names lowercased
- [ ] Raw SQL statements updated (schema-qualified, dialect-converted)
- [ ] `Up()` and `Down()` methods both preserved and fully transformed
