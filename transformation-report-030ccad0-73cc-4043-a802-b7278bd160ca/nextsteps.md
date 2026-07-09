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

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project's NuGet package references and code for any Windows-only APIs or libraries, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

These will not function on Linux or macOS and will require platform-compatible alternatives.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may have been introduced by the migration.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- If Entity Framework Core is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If the project was migrated from Entity Framework 6, confirm the migration to EF Core was handled correctly, as the two have significant API differences.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the provided local URL and manually verify that core application functionality works, including any pages that interact with `Bookstore.Domain` and `Bookstore.Data`.

---

## 8. Review Configuration and Middleware

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, confirm the following have been properly configured in `Program.cs` or `Startup.cs`:

- Middleware pipeline (`app.UseRouting()`, `app.UseAuthorization()`, etc.)
- Dependency injection registrations for services and repositories
- Static file serving (`app.UseStaticFiles()`)
- Authentication and authorization schemes, if applicable

---

## 9. Cross-Platform Smoke Test

If cross-platform support is a goal, run the application on a non-Windows environment (Linux or macOS) to surface any remaining platform-specific issues that may not appear during a Windows build.