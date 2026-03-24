# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

Since all projects compiled without errors, the following steps focus on validating correctness and behavior before any deployment.

---

## 1. Restore and Build the Solution

Run a clean restore and build from the solution root to confirm the error-free state is reproducible in your local environment:

```bash
dotnet restore
dotnet build --configuration Release
```

Ensure there are no warnings that could indicate compatibility issues, such as obsolete API usage or nullable reference warnings that may surface at runtime.

---

## 2. Review Target Framework

Confirm that each project is targeting the intended .NET version. Open each `.csproj` file and verify the `<TargetFramework>` element:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Make sure all three projects target a consistent and supported version of .NET (e.g., .NET 6, 7, or 8).

---

## 3. Validate Runtime Dependencies

Check that all NuGet packages referenced in each project are compatible with the target framework. Pay particular attention to:

- Any packages that were previously Windows-specific (e.g., `System.Drawing.Common`, `Microsoft.Web.*`)
- Entity Framework or data access packages in `Bookstore.Data`
- Any packages in `Bookstore.Web` related to ASP.NET (ensure they are the cross-platform `Microsoft.AspNetCore.*` variants, not legacy `System.Web.*`)

Run the following to check for outdated or vulnerable packages:

```bash
dotnet list package --outdated
dotnet list package --vulnerable
```

---

## 4. Run the Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application in a browser and exercise the primary workflows (browsing books, data retrieval, etc.) to confirm basic functionality is intact.

---

## 5. Check Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for your environment
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- The database schema matches what the application expects

---

## 6. Execute Existing Tests

If the solution contains any test projects, run them to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly:

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced during the migration rather than compilation issues.

---

## 7. Verify Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order
- Configuration sources (`appsettings.json`, environment variables) are loading as expected
- Authentication, authorization, and routing are functioning correctly if applicable

---

## 8. Cross-Platform Smoke Test

If the goal is cross-platform support, run the application on each target operating system (Windows, Linux, macOS) to catch any platform-specific issues that would not surface as build errors, such as:

- File path separator assumptions (`\` vs `/`)
- Case-sensitive file system differences (relevant on Linux)
- Platform-specific API calls that compile but fail at runtime