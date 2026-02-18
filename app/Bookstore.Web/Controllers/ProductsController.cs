using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Bookstore.Data;
using Bookstore.Domain.Products;
using Npgsql;


namespace Bookstore.Web.Controllers
{
    public class ProductsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ProductsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Products
        public async Task<IActionResult> Index()
        {
            return View(await FindAllProducts());
        }
        
        public async Task<List<Product>> FindAllProducts()
        {
            try
            {
                // TODO: Stored procedure uspGetProductData needs to be migrated to PostgreSQL function
                // Original SQL Server call: EXEC [dbo].[uspGetProductData]
                // Once migrated, use: SELECT * FROM bobsbookstore_dbo.uspgetproductdata()
                string sql = @"EXEC [dbo].[uspGetProductData];";

                return await _context.Database.SqlQueryRaw<Product>(sql).ToListAsync();
            }
            catch (Exception ex)
            {
                // Log the error or handle it as needed
                Console.WriteLine(ex.ToString());
                return new List<Product>();
            }
        }
    }
}