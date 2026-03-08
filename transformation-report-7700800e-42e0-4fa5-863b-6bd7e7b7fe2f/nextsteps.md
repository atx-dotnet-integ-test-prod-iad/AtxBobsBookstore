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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net472` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Run the .NET Compatibility Analyzer or review the project references manually to identify any remaining Windows-specific APIs or libraries. Pay particular attention to:

- `System.Web` references (not available in cross-platform .NET)
- Windows Registry access
- COM interop dependencies
- Any `[assembly: TargetFramework]` attributes pointing to `.NETFramework`

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test output carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed in the application code.

---

## 6. Validate the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm the following areas are functioning as expected:

- Application startup and routing
- Database connectivity via `Bookstore.Data`
- Domain logic in `Bookstore.Domain`
- Any authentication or session handling
- Static file serving

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that migrations are in a valid state:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations were originally written for EF6, they will need to be recreated for EF Core. Confirm the database schema matches expectations after applying migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all configuration values that were previously stored in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Application-specific settings

The `System.Configuration.ConfigurationManager` API behaves differently in cross-platform .NET, so any direct reads from `App.config` should be migrated to use `IConfiguration` from `Microsoft.Extensions.Configuration`.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to the target environment.