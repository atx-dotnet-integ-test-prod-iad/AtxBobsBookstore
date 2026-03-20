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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that no project is still referencing `net48` or any other .NET Framework moniker unintentionally.

---

## 4. Check for Windows-Specific Dependencies

Inspect the `Bookstore.Data` and `Bookstore.Web` projects for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop components
- MSMQ or WCF dependencies

If any are found, they will need to be replaced with cross-platform equivalents.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core version being used is compatible with the target framework.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` is correctly configured for the target environment.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover the core functionality in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test key user flows such as browsing, searching, and any data entry forms.
- Check the console output and application logs for any runtime exceptions or deprecation warnings.
- Verify that static assets, routing, and middleware are functioning correctly under the new hosting model (Kestrel/ASP.NET Core).

---

## 8. Review Configuration Files

Confirm that configuration has been properly migrated from any legacy `Web.config` or `App.config` files to the ASP.NET Core `appsettings.json` format. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration
- Authentication or authorization settings

---

## 9. Validate Logging and Error Handling

Ensure that the logging framework is correctly configured in `Program.cs` or `Startup.cs`. If the legacy project used `log4net` or `NLog`, verify these have been updated or replaced with `Microsoft.Extensions.Logging` providers compatible with .NET.