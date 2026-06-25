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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the migrated code may contain Windows-specific API calls that will fail on Linux or macOS at runtime. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings related to platform-specific code paths, particularly in `Bookstore.Data` and `Bookstore.Web`.

---

## 5. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct provider package is referenced for cross-platform use.

- For SQL Server: `Microsoft.EntityFrameworkCore.SqlServer`
- For SQLite: `Microsoft.EntityFrameworkCore.Sqlite`

Run any pending migrations to ensure the database schema is up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the test suite to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between the legacy framework and the new target framework.

---

## 7. Run the Application Locally

Start the `Bookstore.Web` project locally to verify runtime behavior.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages load correctly
- Data is read from and written to the database
- No unhandled exceptions appear in the console output

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains the correct configuration values, particularly connection strings, and that any values previously stored in `Web.config` have been migrated appropriately.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

Confirm that environment-specific settings are handled using `appsettings.Development.json` or environment variables rather than legacy config transforms.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target environment.