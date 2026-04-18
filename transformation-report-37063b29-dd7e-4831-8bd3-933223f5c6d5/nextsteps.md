# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no build-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas where the migration may have introduced subtle issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have been removed or changed in modern .NET. Common areas to check include:

- `System.Web` references (not available in cross-platform .NET)
- `HttpContext` and related ASP.NET types (should now use `Microsoft.AspNetCore.Http`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `EntityFramework` (classic) vs `Microsoft.EntityFrameworkCore`

---

## 5. Run the Data Layer Tests

If the `Bookstore.Data` project interacts with a database, verify the data layer functions correctly by:

1. Confirming the connection string in `appsettings.json` is valid and points to an accessible database.
2. Running any existing Entity Framework Core migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

3. If no migrations exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Existing Unit Tests

If the solution contains a test project, run all tests to validate that the domain logic and data access behavior are intact:

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)
- Static files (CSS, JS, images) are served correctly

---

## 8. Review Middleware and Startup Configuration

In cross-platform ASP.NET Core, application startup is configured differently than in .NET Framework. Confirm the following in `Program.cs` (or `Startup.cs` if still present):

- Middleware is registered in the correct order
- Services such as Entity Framework, Identity, and logging are properly registered via `builder.Services`
- Environment-specific configuration (`Development`, `Production`) is handled correctly

---

## 9. Validate Static Files and wwwroot

Ensure all static assets are located under the `wwwroot` folder in `Bookstore.Web`. Files outside this folder will not be served by default in ASP.NET Core.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.