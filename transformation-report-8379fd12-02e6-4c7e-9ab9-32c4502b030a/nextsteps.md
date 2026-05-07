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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may indicate areas that need further attention.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using EF Core rather than EF 6. EF 6 is not fully supported on cross-platform .NET.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm it has been migrated to ASP.NET Core. Web Forms is not supported on cross-platform .NET.
- **`Bookstore.Domain`**: Check for any use of `System.Configuration.ConfigurationManager` or similar APIs that are not available by default in cross-platform .NET. These require the `System.Configuration.ConfigurationManager` NuGet package.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 6. Run the Application Locally

Start the web application locally and verify that it functions as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following areas at a minimum:

- Application startup and home page load
- Any database-driven pages to confirm data access is working
- Form submissions or any write operations
- Error pages and logging output

---

## 7. Verify Database Connectivity

If `Bookstore.Data` uses a database, confirm that the connection string in `appsettings.json` (or equivalent configuration file) is correct for the target environment. In cross-platform .NET, connection strings are typically stored in `appsettings.json` rather than `web.config` or `app.config`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

If EF Core migrations are used, apply them to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Logging and Configuration

Cross-platform ASP.NET Core uses a different configuration and logging system than .NET Framework. Confirm that:

- Logging is configured in `Program.cs` using `ILogger` or a compatible provider.
- Configuration values previously read from `web.config` have been moved to `appsettings.json` or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present, including static assets, configuration files, and compiled assemblies.