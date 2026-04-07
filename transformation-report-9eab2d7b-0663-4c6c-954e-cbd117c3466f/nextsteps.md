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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to verify database interactions behave as expected under the new framework.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` likely interacts with a database, verify the following:

- **Connection strings** in `appsettings.json` (or `appsettings.Development.json`) are correctly configured for the target environment.
- If Entity Framework Core is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Test core user-facing functionality such as browsing, searching, and any authentication flows.
- Check the browser console and application logs for runtime errors or missing static assets.

---

## 6. Review Configuration and Middleware

Open `Program.cs` (and `Startup.cs` if still present) in `Bookstore.Web` and confirm the following:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`).
- Static files, routing, and any session or caching middleware are configured appropriately for ASP.NET Core.
- Environment-specific configuration (Development vs. Production) is handled via `IConfiguration` and `appsettings.{Environment}.json`.

---

## 7. Check for Windows-Specific or Legacy API Usage

Even without build errors, runtime issues can arise from APIs that existed in .NET Framework but behave differently or are absent in cross-platform .NET. Review the codebase for:

- Use of `System.Web` namespaces (these are not available in .NET Core/5+).
- `HttpContext.Current` usage, which should be replaced with injected `IHttpContextAccessor`.
- Any P/Invoke calls or Windows Registry access that may not function on non-Windows platforms.
- `ConfigurationManager` usage, which should be replaced with `IConfiguration`.

---

## 8. Validate on Target Deployment Platform

If the application is intended to run on Linux or macOS, test it on that platform explicitly:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then deploy the published output to the target machine and run it to confirm cross-platform compatibility.

---

## 9. Review Deprecated or Outdated Package References

Check each `.csproj` file for NuGet packages that may have been carried over from the legacy project and are now outdated or have cross-platform replacements:

```bash
dotnet list package --outdated
```

Update packages where appropriate, and replace any packages that are Windows-only with their cross-platform equivalents.