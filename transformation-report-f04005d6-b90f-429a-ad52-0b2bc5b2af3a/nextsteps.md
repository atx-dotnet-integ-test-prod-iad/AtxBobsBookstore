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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors.

```bash
dotnet build --configuration Release
```

Ensure the output shows **0 Error(s)** for all three projects. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the correct connection strings and application settings that were previously in `Web.config`.
- Environment-specific overrides (e.g., `appsettings.Development.json`) are in place if needed.
- Any configuration sections previously read via `ConfigurationManager` have been replaced with the `IConfiguration` interface.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database connection string in `appsettings.json` is correct for your target database.
- If Entity Framework is used, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Open the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Navigate through the key pages of the application to verify basic functionality such as browsing, searching, and any data entry forms.
- Check the console output and any configured logging sinks for runtime exceptions or warnings.

---

## 6. Check for Windows-Specific API Usage

Since this was a legacy project, there may be runtime dependencies on Windows-specific APIs that do not surface as build errors but will fail on non-Windows platforms. Search the codebase for the following:

- `Registry` access (`Microsoft.Win32.Registry`)
- `System.Drawing` (GDI+) — replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if used for image processing.
- Windows file path separators (use `Path.Combine` and `Path.DirectorySeparatorChar` instead of hardcoded backslashes).
- `HttpContext.Current` — this is not available in ASP.NET Core; use dependency-injected `IHttpContextAccessor` instead.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences between ASP.NET and ASP.NET Core, particularly around:

- Middleware and HTTP pipeline behavior
- Authentication and authorization
- Session and cookie handling

---

## 8. Validate Static Assets and Bundling

ASP.NET Core does not use `BundleConfig.cs` or the legacy `System.Web.Optimization` library. Confirm that:

- Static files (CSS, JavaScript, images) are located in the `wwwroot` folder.
- Bundling and minification are handled via a supported mechanism such as the `BundleMinifier` MSBuild task, `LibMan`, or a front-end build tool.
- The `UseStaticFiles()` middleware is registered in `Program.cs` or `Startup.cs`.

---

## 9. Review Authentication and Authorization

If the application uses authentication, verify the following in `Program.cs`:

- `AddAuthentication()` and `AddAuthorization()` are called on the service collection.
- The correct authentication scheme is configured (e.g., cookies, JWT).
- `UseAuthentication()` and `UseAuthorization()` are called in the correct order in the middleware pipeline, specifically after `UseRouting()` and before `UseEndpoints()`.

---

## 10. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the `./publish` folder to confirm all required files are present, including `appsettings.json` and any static assets. The published output can then be deployed to your target hosting environment, such as IIS, a Linux server with the .NET runtime installed, or Azure App Service.

For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed on the target server and that the `web.config` generated in the publish output is present and correctly configured with the `AspNetCoreModuleV2` handler.