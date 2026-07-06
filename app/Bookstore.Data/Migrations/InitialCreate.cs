using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Bookstore.Data.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // -------------------------------------------------------
            // Create schema
            // -------------------------------------------------------
            migrationBuilder.EnsureSchema(
                name: "bobsbookstore_dbo");

            // -------------------------------------------------------
            // referencedata  (no FK deps — must come before Book/Offer)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "referencedata",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    datatype = table.Column<int>(type: "integer", nullable: false),
                    text = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_referencedata", x => x.id);
                });

            // -------------------------------------------------------
            // customer  (no FK deps)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "customer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    sub = table.Column<string>(type: "text", nullable: false),
                    username = table.Column<string>(type: "text", nullable: true),
                    firstname = table.Column<string>(type: "text", nullable: true),
                    lastname = table.Column<string>(type: "text", nullable: true),
                    email = table.Column<string>(type: "text", nullable: true),
                    dateofbirth = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    phone = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_customer", x => x.id);
                });

            // -------------------------------------------------------
            // author  (no FK deps)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "author",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    businessentityid = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nationalidnumber = table.Column<string>(type: "varchar(15)", maxLength: 15, nullable: false),
                    loginid = table.Column<string>(type: "varchar(256)", maxLength: 256, nullable: false),
                    jobtitle = table.Column<string>(type: "varchar(50)", maxLength: 50, nullable: false),
                    birthdate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    maritalstatus = table.Column<string>(type: "char(1)", maxLength: 1, nullable: false),
                    gender = table.Column<string>(type: "char(1)", maxLength: 1, nullable: false),
                    hiredate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    vacationhours = table.Column<short>(type: "smallint", nullable: false),
                    modifieddate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_author", x => x.businessentityid);
                });

            // -------------------------------------------------------
            // product  (no FK deps)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "product",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    productid = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    name = table.Column<string>(type: "varchar(15)", maxLength: 15, nullable: false),
                    productnumber = table.Column<string>(type: "varchar(256)", maxLength: 256, nullable: false),
                    safetystocklevel = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_product", x => x.productid);
                });

            // -------------------------------------------------------
            // shoppingcart  (no FK deps)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    correlationid = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_shoppingcart", x => x.id);
                });

            // -------------------------------------------------------
            // address  (FK -> customer)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "address",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    addressline1 = table.Column<string>(type: "text", nullable: false),
                    addressline2 = table.Column<string>(type: "text", nullable: true),
                    city = table.Column<string>(type: "text", nullable: false),
                    state = table.Column<string>(type: "text", nullable: false),
                    country = table.Column<string>(type: "text", nullable: false),
                    zipcode = table.Column<string>(type: "text", nullable: false),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    isactive = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_address", x => x.id);
                    table.ForeignKey(
                        name: "FK_address_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // -------------------------------------------------------
            // book  (FKs -> referencedata)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "book",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    name = table.Column<string>(type: "text", nullable: false),
                    author = table.Column<string>(type: "text", nullable: false),
                    year = table.Column<int>(type: "integer", nullable: true),
                    isbn = table.Column<string>(type: "text", nullable: false),
                    publisherid = table.Column<int>(type: "integer", nullable: false),
                    booktypeid = table.Column<int>(type: "integer", nullable: false),
                    genreid = table.Column<int>(type: "integer", nullable: false),
                    conditionid = table.Column<int>(type: "integer", nullable: false),
                    coverimageurl = table.Column<string>(type: "text", nullable: true),
                    summary = table.Column<string>(type: "text", nullable: true),
                    price = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_book", x => x.id);
                    table.ForeignKey(
                        name: "FK_book_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_book_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_book_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_book_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // -------------------------------------------------------
            // offer  (FKs -> customer, referencedata)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "offer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    author = table.Column<string>(type: "text", nullable: false),
                    isbn = table.Column<string>(type: "text", nullable: false),
                    bookname = table.Column<string>(type: "text", nullable: false),
                    fronturl = table.Column<string>(type: "text", nullable: true),
                    genreid = table.Column<int>(type: "integer", nullable: false),
                    conditionid = table.Column<int>(type: "integer", nullable: false),
                    publisherid = table.Column<int>(type: "integer", nullable: false),
                    booktypeid = table.Column<int>(type: "integer", nullable: false),
                    summary = table.Column<string>(type: "text", nullable: true),
                    offerstatus = table.Column<int>(type: "integer", nullable: false),
                    comment = table.Column<string>(type: "text", nullable: true),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    bookprice = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_offer", x => x.id);
                    table.ForeignKey(
                        name: "FK_offer_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_offer_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // -------------------------------------------------------
            // Order  (FKs -> customer, address)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "Order",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    addressid = table.Column<int>(type: "integer", nullable: false),
                    deliverydate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    orderstatus = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Order", x => x.id);
                    table.ForeignKey(
                        name: "FK_Order_address_addressid",
                        column: x => x.addressid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "address",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Order_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // -------------------------------------------------------
            // shoppingcartitem  (FKs -> shoppingcart, book)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    shoppingcartid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    wanttobuy = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_shoppingcartitem", x => x.id);
                    table.ForeignKey(
                        name: "FK_shoppingcartitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_shoppingcartitem_shoppingcart_shoppingcartid",
                        column: x => x.shoppingcartid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "shoppingcart",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // -------------------------------------------------------
            // orderitem  (FKs -> Order, book)
            // -------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    createdby = table.Column<string>(type: "text", nullable: false, defaultValue: "System"),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    orderid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_orderitem", x => x.id);
                    table.ForeignKey(
                        name: "FK_orderitem_Order_orderid",
                        column: x => x.orderid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "Order",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_orderitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // -------------------------------------------------------
            // Seed data — referencedata
            // -------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "referencedata",
                columns: new[] { "id", "createdon", "createdby", "updatedon", "datatype", "text" },
                values: new object[,]
                {
                    { 1,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 2, "Hardcover" },
                    { 2,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 2, "Trade Paperback" },
                    { 3,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 2, "Mass Market Paperback" },
                    { 4,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "New" },
                    { 5,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "Like New" },
                    { 6,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "Good" },
                    { 7,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 1, "Acceptable" },
                    { 8,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Biographies" },
                    { 9,  new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Children's Books" },
                    { 10, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "History" },
                    { 11, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Literature & Fiction" },
                    { 12, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Mystery, Thriller & Suspense" },
                    { 13, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Science Fiction & Fantasy" },
                    { 14, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 3, "Travel" },
                    { 15, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Arcadia Books" },
                    { 16, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Astral Publishing" },
                    { 17, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Moonlight Publishing" },
                    { 18, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Dreamscape Press" },
                    { 19, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Enchanted Library" },
                    { 20, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Fantasia House" },
                    { 21, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Horizon Books" },
                    { 22, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Infinity Press" },
                    { 23, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Paradigm Publishing" },
                    { 24, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), 0, "Aurora Publishing" }
                });

            // -------------------------------------------------------
            // Seed data — book
            // -------------------------------------------------------
            migrationBuilder.InsertData(
                schema: "bobsbookstore_dbo",
                table: "book",
                columns: new[] { "id", "createdon", "createdby", "updatedon", "name", "author", "isbn", "publisherid", "booktypeid", "genreid", "conditionid", "price", "quantity", "year", "summary", "coverimageurl" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "2020: The Apocalypse",       "Li Juan",       "6556784356", 15, 1, 13, 5, 10.95m, 25, null, null, "/images/coverimages/apocalypse.png" },
                    { 2, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Children Of Iron",           "Nikki Wolf",    "7665438976", 16, 1, 11, 6, 13.95m,  3, null, null, "/images/coverimages/childrenofiron.png" },
                    { 3, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Gold In The Dark",           "Richard Roe",   "5442280765", 17, 1, 13, 5,  6.50m, 10, null, null, "/images/coverimages/goldinthedark.png" },
                    { 4, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Leagues Of Smoke",           "Pat Candella",  "4556789542", 18, 2, 11, 7,  3.00m,  1, null, null, "/images/coverimages/leaguesofsmoke.png" },
                    { 5, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "Alone With The Stars",       "Carlos Salazar","4563358087", 19, 2, 12, 5, 15.95m,  5, null, null, "/images/coverimages/alonewiththestars.png" },
                    { 6, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "The Girl In The Polaroid",   "Terri Whitlock","2354435678", 20, 1, 12, 6,  8.25m,  2, null, null, "/images/coverimages/girlinthepolaroid.png" },
                    { 7, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "1001 Jokes",                 "Mary Major",    "6554789632", 21, 2, 11, 5, 13.95m,  7, null, null, "/images/coverimages/1001jokes.png" },
                    { 8, new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "System", new DateTime(2024, 1, 1, 0, 0, 0, DateTimeKind.Utc), "My Search For Meaning",      "Mateo Jackson", "4558786554", 22, 3,  8, 7,  5.00m, 15, null, null, "/images/coverimages/mysearchformeaning.png" }
                });

            // -------------------------------------------------------
            // Indexes
            // -------------------------------------------------------
            migrationBuilder.CreateIndex(
                name: "IX_address_customerid",
                schema: "bobsbookstore_dbo",
                table: "address",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "IX_book_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "IX_book_conditionid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "IX_book_genreid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "IX_book_publisherid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_conditionid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_customerid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_genreid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "IX_offer_publisherid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "IX_Order_addressid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "addressid");

            migrationBuilder.CreateIndex(
                name: "IX_Order_customerid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "IX_orderitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "IX_orderitem_orderid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "orderid");

            migrationBuilder.CreateIndex(
                name: "IX_shoppingcartitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "IX_shoppingcartitem_shoppingcartid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "shoppingcartid");

            migrationBuilder.CreateIndex(
                name: "IX_customer_sub",
                schema: "bobsbookstore_dbo",
                table: "customer",
                column: "sub",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Drop in reverse dependency order

            migrationBuilder.DropTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "Order",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "offer",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "book",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "address",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "author",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "product",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "customer",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "referencedata",
                schema: "bobsbookstore_dbo");
        }
    }
}
