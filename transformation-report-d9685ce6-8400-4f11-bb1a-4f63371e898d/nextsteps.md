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

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these may indicate areas that were not fully modernized.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported version of .NET (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other legacy .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review `Bookstore.Data` and `Bookstore.Web` for any APIs or packages that are Windows-only. Common areas to check:

- **Entity Framework**: Confirm the provider (e.g., SQL Server, SQLite) is configured correctly for the target environment.
- **Configuration**: Ensure `Web.config` or `App.config` usage has been replaced with `appsettings.json` and `IConfiguration`.
- **Authentication/Authorization**: Verify that any Windows Authentication or legacy membership providers have been replaced with ASP.NET Core equivalents.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and manually verify core functionality such as:

- Page rendering
- Database connectivity
- Any book listing, search, or purchase workflows

---

## 6. Run Existing Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no tests currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to establish a baseline before further changes.

---

## 7. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply migrations to a local database to verify they execute without errors:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.