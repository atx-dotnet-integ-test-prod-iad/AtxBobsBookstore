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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, modern version of .NET (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET)
- `HttpContext` and related types (replaced by `Microsoft.AspNetCore.Http`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- Windows-only APIs such as the registry or certain `System.Drawing` features

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` likely contains data access logic, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Entity Framework Core (if used) migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality works as expected, including:

- Page rendering
- Data retrieval and display
- Any form submissions or user interactions

---

## 8. Review Application Configuration

Confirm that configuration files have been properly migrated:

- `Web.config` settings should now reside in `appsettings.json` or `appsettings.{Environment}.json`.
- Environment-specific settings (e.g., connection strings) should be externalized and not hardcoded.
- Logging configuration should be present under the `"Logging"` section in `appsettings.json`.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.