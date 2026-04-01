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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Pay attention to:
- Any tests that were previously passing on the legacy framework but now fail.
- Tests that rely on Windows-specific APIs or behaviors that may not translate directly to cross-platform .NET.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If you are migrating from Entity Framework 6 (EF6) to EF Core, review your model configurations, relationships, and queries for any breaking changes. Common areas to check include:
- Lazy loading configuration
- Cascade delete behavior
- Raw SQL queries using `FromSqlRaw` instead of `SqlQuery`

Apply pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Configuration and Middleware (Bookstore.Web)

If `Bookstore.Web` was migrated from ASP.NET (System.Web) to ASP.NET Core, verify the following:

- `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`.
- Authentication and authorization middleware is correctly configured in `Program.cs` or `Startup.cs`.
- Any HTTP modules or HTTP handlers from the legacy project have been replaced with the equivalent ASP.NET Core middleware.
- Static file serving, routing, and model binding behave as expected.

---

## 6. Run the Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Walk through the primary user flows such as browsing, searching, and any data entry forms to confirm the application behaves correctly end to end.

---

## 7. Check for Platform-Specific API Usage

Run the .NET compatibility analyzer to surface any remaining platform-specific API calls that may cause issues on non-Windows operating systems:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

Address any `CA1416` platform compatibility warnings that appear in the output.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If you intend to support a specific long-term support (LTS) release, confirm the selected framework version aligns with that goal.