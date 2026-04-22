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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are now using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly:
- Nullable reference type warnings, which may have been introduced if the new project format enables nullable context by default.
- Obsolete API warnings, which may indicate APIs that have been removed or changed in modern .NET.

---

## 3. Review Configuration Files

Legacy ASP.NET projects rely on `Web.config` and `App.config`. These are replaced by `appsettings.json` in modern .NET. Verify the following:

- `appsettings.json` and `appsettings.{Environment}.json` exist in `Bookstore.Web` and contain the correct connection strings and application settings.
- Any configuration previously in `Web.config` (such as connection strings, app settings, or HTTP handlers) has been migrated to the appropriate `appsettings.json` or middleware configuration in `Program.cs` / `Startup.cs`.
- Environment variables or secrets are handled using `dotnet user-secrets` for local development if sensitive values are involved.

---

## 4. Verify the Data Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify that the correct EF Core version is referenced and that the `DbContext` configuration uses the modern `OnConfiguring` or dependency injection approach.
- Run any pending migrations or verify that the database schema is consistent:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used EF 6, ensure it has been migrated to EF Core, as EF 6 is not fully supported on cross-platform .NET.

---

## 5. Run the Application Locally

Start the web application and verify basic functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and confirm pages load correctly.
- Check that database connectivity is working by exercising features that read from or write to the database.
- Review the console output and application logs for any runtime exceptions.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved:

```bash
dotnet test
```

- Review any failing tests and determine whether the failure is due to a genuine behavioral change or a test configuration issue introduced during migration.
- Pay particular attention to tests that involve HTTP context, authentication, or data access, as these areas commonly require updates when moving from legacy ASP.NET to modern ASP.NET Core.

---

## 7. Validate Authentication and Authorization

If the application uses authentication, confirm that the middleware is correctly configured in `Program.cs`:

- Forms Authentication from legacy ASP.NET is replaced by Cookie Authentication middleware in ASP.NET Core.
- Verify that `app.UseAuthentication()` and `app.UseAuthorization()` are present and ordered correctly in the middleware pipeline.

---

## 8. Check Static Files and Bundling

Legacy projects may have used `BundleConfig.cs` or `ScriptManager` for static asset management. In ASP.NET Core:

- Static files are served via `app.UseStaticFiles()`.
- Bundling and minification can be handled by the `BundleMinifier` NuGet package or a front-end build tool.
- Confirm that CSS, JavaScript, and image files are located under the `wwwroot` folder and are being served correctly.