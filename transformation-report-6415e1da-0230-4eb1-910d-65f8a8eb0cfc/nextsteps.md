# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps focus on validating correctness and preparing the solution for deployment.

---

## 1. Restore and Build the Solution

Run a clean restore and build from the solution root to confirm the error-free state is reproducible in your local environment:

```bash
dotnet restore
dotnet build --configuration Release
```

Ensure there are no warnings that may indicate deprecated APIs or compatibility issues that could surface at runtime.

---

## 2. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures at this stage are likely caused by behavioral differences between .NET Framework and modern .NET, such as changes in:

- `System.Configuration` usage (replaced by `Microsoft.Extensions.Configuration`)
- Entity Framework version differences (e.g., EF6 vs EF Core)
- HTTP pipeline and middleware behavior in ASP.NET Core vs ASP.NET MVC

---

## 3. Verify Entity Framework Configuration

Since this is a Bookstore application with a `Bookstore.Data` project, confirm that the data access layer is functioning correctly:

- If the project was migrated from **EF6 to EF Core**, verify that all `DbContext` configurations, relationships, and migrations are correct.
- Run the following to check pending migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Review `appsettings.json` Configuration

Modern .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm that the following have been migrated correctly:

- Database connection strings
- Any application-specific settings previously in `<appSettings>` or `<connectionStrings>`

A typical `appsettings.json` structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 5. Manually Test the Web Application

Start the web application and navigate through its core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Test the following areas:

- Application startup with no exceptions
- Database connectivity (e.g., loading a list of books)
- Any forms or POST endpoints (model binding behavior may differ in ASP.NET Core)
- Authentication and authorization, if applicable
- Static files (CSS, JS, images) are being served correctly

---

## 6. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `TargetFramework` is set to a current, supported version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net6.0` or `net7.0` as these are out of support. Use `net8.0` or later.

---

## 7. Review NuGet Package Versions

Check that all NuGet dependencies are referencing current, stable versions compatible with your target framework. Run:

```bash
dotnet list package --outdated
```

Update packages where appropriate, particularly:

- `Microsoft.EntityFrameworkCore`
- `Microsoft.AspNetCore.*` packages
- Any third-party libraries that had separate .NET Framework and .NET Core versions

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the output directory contains all expected files before deploying to the target environment.