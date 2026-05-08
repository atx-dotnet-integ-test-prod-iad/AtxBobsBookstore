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
            migrationBuilder.EnsureSchema(
                name: "bobsbookstore_dbo");

            // ---------------------------------------------------------------
            // referencedata
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "referencedata",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    datatype = table.Column<int>(type: "integer", nullable: false),
                    text = table.Column<string>(type: "text", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_referencedata", x => x.id);
                });

            // ---------------------------------------------------------------
            // author
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("pk_author", x => x.businessentityid);
                });

            // ---------------------------------------------------------------
            // product
            // ---------------------------------------------------------------
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
                    table.PrimaryKey("pk_product", x => x.productid);
                });

            // ---------------------------------------------------------------
            // customer
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "customer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    sub = table.Column<string>(type: "text", nullable: false),
                    username = table.Column<string>(type: "text", nullable: true),
                    firstname = table.Column<string>(type: "text", nullable: true),
                    lastname = table.Column<string>(type: "text", nullable: true),
                    email = table.Column<string>(type: "text", nullable: true),
                    dateofbirth = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    phone = table.Column<string>(type: "text", nullable: true),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_customer", x => x.id);
                });

            // ---------------------------------------------------------------
            // book
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "book",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
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
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_book", x => x.id);
                    table.ForeignKey(
                        name: "fk_book_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_book_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_book_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_book_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ---------------------------------------------------------------
            // address
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "address",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    addressline1 = table.Column<string>(type: "text", nullable: false),
                    addressline2 = table.Column<string>(type: "text", nullable: true),
                    city = table.Column<string>(type: "text", nullable: false),
                    state = table.Column<string>(type: "text", nullable: false),
                    country = table.Column<string>(type: "text", nullable: false),
                    zipcode = table.Column<string>(type: "text", nullable: false),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    isactive = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_address", x => x.id);
                    table.ForeignKey(
                        name: "fk_address_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ---------------------------------------------------------------
            // Order
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "Order",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    customerid = table.Column<int>(type: "integer", nullable: false),
                    addressid = table.Column<int>(type: "integer", nullable: false),
                    deliverydate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    orderstatus = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_order", x => x.id);
                    table.ForeignKey(
                        name: "fk_order_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ---------------------------------------------------------------
            // shoppingcart
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    correlationid = table.Column<string>(type: "text", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_shoppingcart", x => x.id);
                });

            // ---------------------------------------------------------------
            // offer
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "offer",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
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
                    bookprice = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_offer", x => x.id);
                    table.ForeignKey(
                        name: "fk_offer_customer_customerid",
                        column: x => x.customerid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "customer",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_booktypeid",
                        column: x => x.booktypeid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_conditionid",
                        column: x => x.conditionid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_genreid",
                        column: x => x.genreid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_offer_referencedata_publisherid",
                        column: x => x.publisherid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "referencedata",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            // ---------------------------------------------------------------
            // orderitem
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    orderid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_orderitem", x => x.id);
                    table.ForeignKey(
                        name: "fk_orderitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_orderitem_order_orderid",
                        column: x => x.orderid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "Order",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ---------------------------------------------------------------
            // shoppingcartitem
            // ---------------------------------------------------------------
            migrationBuilder.CreateTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    shoppingcartid = table.Column<int>(type: "integer", nullable: false),
                    bookid = table.Column<int>(type: "integer", nullable: false),
                    quantity = table.Column<int>(type: "integer", nullable: false),
                    wanttobuy = table.Column<bool>(type: "boolean", nullable: false),
                    createdby = table.Column<string>(type: "text", nullable: false),
                    createdon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updatedon = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_shoppingcartitem", x => x.id);
                    table.ForeignKey(
                        name: "fk_shoppingcartitem_book_bookid",
                        column: x => x.bookid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "book",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_shoppingcartitem_shoppingcart_shoppingcartid",
                        column: x => x.shoppingcartid,
                        principalSchema: "bobsbookstore_dbo",
                        principalTable: "shoppingcart",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            // ---------------------------------------------------------------
            // Indexes
            // ---------------------------------------------------------------
            migrationBuilder.CreateIndex(
                name: "ix_address_customerid",
                schema: "bobsbookstore_dbo",
                table: "address",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "ix_book_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "ix_book_conditionid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "ix_book_genreid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "ix_book_publisherid",
                schema: "bobsbookstore_dbo",
                table: "book",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "ix_customer_sub",
                schema: "bobsbookstore_dbo",
                table: "customer",
                column: "sub",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_offer_booktypeid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "booktypeid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_conditionid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "conditionid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_customerid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_genreid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "genreid");

            migrationBuilder.CreateIndex(
                name: "ix_offer_publisherid",
                schema: "bobsbookstore_dbo",
                table: "offer",
                column: "publisherid");

            migrationBuilder.CreateIndex(
                name: "ix_order_customerid",
                schema: "bobsbookstore_dbo",
                table: "Order",
                column: "customerid");

            migrationBuilder.CreateIndex(
                name: "ix_orderitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "ix_orderitem_orderid",
                schema: "bobsbookstore_dbo",
                table: "orderitem",
                column: "orderid");

            migrationBuilder.CreateIndex(
                name: "ix_shoppingcartitem_bookid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "bookid");

            migrationBuilder.CreateIndex(
                name: "ix_shoppingcartitem_shoppingcartid",
                schema: "bobsbookstore_dbo",
                table: "shoppingcartitem",
                column: "shoppingcartid");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "shoppingcartitem",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "orderitem",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "author",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "product",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "address",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "shoppingcart",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "offer",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "Order",
                schema: "bobsbookstore_dbo");

            migrationBuilder.DropTable(
                name: "book",
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
