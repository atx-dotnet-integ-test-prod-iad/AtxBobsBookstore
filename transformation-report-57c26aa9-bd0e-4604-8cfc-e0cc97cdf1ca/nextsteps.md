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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate modern .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not available or have changed in modern .NET. Review the following areas manually:

- **`System.Web` dependencies** — These do not exist in modern .NET. Any usage in `Bookstore.Web` should have been migrated to ASP.NET Core equivalents.
- **Entity Framework** — If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core.
- **Configuration** — `Web.config` and `App.config` patterns should be replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.
- **HTTP Handlers and Modules** — These should be replaced with ASP.NET Core middleware.

---

## 5. Run the Application Locally

Start the application locally and verify that it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and exercise the primary features to check for runtime exceptions or unexpected behavior.

---

## 6. Inspect the Database Connection

If `Bookstore.Data` connects to a database, verify the connection string in `appsettings.json` is correct and that the database is accessible from the current environment.

If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Automated Tests

If a test project exists in the solution, run the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.