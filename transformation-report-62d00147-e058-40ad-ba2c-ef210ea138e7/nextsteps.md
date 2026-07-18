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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end-of-life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-specific APIs are being used unintentionally. Run the .NET Compatibility Analyzer if not already applied:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- Windows-only file path assumptions

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are due to migration-related behavioral changes or pre-existing issues.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` likely interacts with a database, verify the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any pending Entity Framework Core migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and exercise the primary application workflows, including any pages or API endpoints that interact with `Bookstore.Domain` and `Bookstore.Data`.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) and confirm:

- Middleware is registered in the correct order.
- Services such as dependency injection registrations for repositories or domain services are present.
- Authentication and authorization middleware, if applicable, has been correctly migrated from the legacy configuration.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.