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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm the appropriate web SDK is being used:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or libraries. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** configurations in `Bookstore.Web`
- **File path separators** — replace hardcoded backslashes with `Path.Combine` or `Path.DirectorySeparatorChar`
- **Entity Framework** — confirm the database provider is compatible with the target platform

---

## 5. Run the Data Layer Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that any existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to establish a baseline for correctness.

---

## 7. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following manually:

- Application starts without runtime exceptions
- All pages and routes load correctly
- Database connectivity is functional
- Any authentication or authorization flows behave as expected

---

## 8. Review Configuration Files

Ensure `appsettings.json` (and `appsettings.Development.json`) contain the correct configuration values, particularly:

- Connection strings
- Logging settings
- Any environment-specific values previously stored in `Web.config`

If `Web.config` was the previous configuration source, confirm all relevant settings have been migrated to `appsettings.json` and are being read via `IConfiguration`.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required assets, views, and static files are present before deploying to the target environment.