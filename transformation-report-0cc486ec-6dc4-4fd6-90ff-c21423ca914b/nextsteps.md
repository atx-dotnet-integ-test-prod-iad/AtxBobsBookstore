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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it is using:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```
or simply `net8.0` if no Windows-specific APIs are required.

---

## 4. Check for Windows-Specific or Legacy APIs

Search the codebase for any usage of APIs that are not cross-platform, such as:

- `System.Web` (should be replaced with `Microsoft.AspNetCore`)
- Windows Registry access
- `HttpContext.Current`
- `WebConfigurationManager` or `ConfigurationManager` without the appropriate NuGet package (`System.Configuration.ConfigurationManager`)

Run the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling if a deeper API surface check is needed.

---

## 5. Validate Configuration

Confirm that `appsettings.json` is present in `Bookstore.Web` and contains the configuration values that were previously in `Web.config` or `App.config`, including:

- Database connection strings
- Application settings
- Logging configuration

Example structure:

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

## 6. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the version being used is Entity Framework Core and not the legacy Entity Framework 6 (unless EF6 on .NET is intentional).

Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Page rendering
- Database reads and writes
- Authentication and authorization, if applicable

---

## 8. Run Existing Tests

If the solution contains test projects, execute them to confirm existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 9. Publish the Application

Once validation is complete, publish the application to a local folder to confirm the published output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.