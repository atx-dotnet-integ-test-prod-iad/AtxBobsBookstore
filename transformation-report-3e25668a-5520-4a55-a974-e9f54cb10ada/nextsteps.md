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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that are compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results for any failures. Pay particular attention to:

- Data access logic in `Bookstore.Data`, as ORM behavior (e.g., Entity Framework) can differ between .NET Framework and modern .NET.
- Any tests that rely on platform-specific APIs that may have changed.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to check manually:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that migrations (if applicable) run correctly.
- **Configuration loading**: Verify that settings previously in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read at runtime.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware, confirm that login, roles, and access control function as expected.
- **Static assets and routing**: Confirm that pages render correctly and that routing behaves as expected under ASP.NET Core conventions.

---

## 5. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET. Review the following areas:

- **`System.Web` dependencies**: Any code that previously relied on `System.Web` (e.g., `HttpContext`, `HttpRequest`) should now be using the ASP.NET Core equivalents. Search the codebase for any remaining references.
- **`ConfigurationManager`**: If `System.Configuration.ConfigurationManager` is still in use, consider migrating to `Microsoft.Extensions.Configuration`.
- **Globalization and encoding**: Modern .NET has stricter defaults in some globalization scenarios. Test any locale-sensitive functionality.

---

## 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version (e.g., `net8.0` or `net9.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid compatibility issues between them.

---

## 7. Publish the Application

Once validation is complete, publish the application to a folder for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present, including configuration files, static assets, and the compiled binaries.