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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review each project's NuGet package references and code for any APIs or packages that are Windows-only. Common areas to check include:

- `System.Drawing.Common` — has platform restrictions on non-Windows systems
- `Microsoft.Win32` namespace usage
- Any COM interop or P/Invoke calls
- Registry access via `RegistryKey`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `dotnet-compatibility` tool if needed.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences between the legacy framework and the new .NET runtime.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- The connection string in `appsettings.json` (or equivalent configuration) is correct for the target environment.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrating from Entity Framework 6, confirm the migration to EF Core was handled correctly and that all `DbContext` configurations, relationships, and queries function as expected.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas at a minimum:

- Application startup with no unhandled exceptions
- Routing and page rendering
- Data reads and writes through `Bookstore.Data`
- Any authentication or authorization middleware that may have changed behavior

---

## 8. Review Configuration and Middleware

In ASP.NET Core, configuration and middleware differ significantly from legacy ASP.NET (Web Forms or MVC on .NET Framework). Confirm the following in `Program.cs` or `Startup.cs`:

- `appsettings.json` is present and loaded correctly
- Middleware order is correct (e.g., `UseAuthentication` before `UseAuthorization`)
- Static files, routing, and session configuration are explicitly registered if used

---

## 9. Address Compiler Warnings

After a successful build, review all compiler warnings. Warnings related to the following should be addressed before considering the migration complete:

- Nullable reference types (`CS8600`, `CS8602`, `CS8603`, etc.)
- Obsolete API usage (`CS0618`)
- Async method issues (`CS1998`)

These can be viewed in full by running:

```bash
dotnet build --configuration Release 2>&1 | grep -i warning
```