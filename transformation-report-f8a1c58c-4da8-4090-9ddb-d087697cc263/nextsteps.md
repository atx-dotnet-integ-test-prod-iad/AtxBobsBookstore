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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were written against Windows-specific behavior (e.g., file paths, registry access, COM interop), those tests may require adjustment for cross-platform compatibility.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for your target database.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6) and was migrated to EF Core, verify that queries, relationships, and migrations behave as expected against your database schema.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Test core user-facing functionality such as browsing, searching, and any data submission forms.
- Check the console and browser developer tools for any runtime errors or missing static assets.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All environment-specific settings (connection strings, API keys, logging levels) have been moved to the appropriate `appsettings.json` files.
- Any remaining `.config` files are no longer relied upon at runtime unless explicitly loaded in code.

---

## 7. Verify Static Files and Razor Views

If `Bookstore.Web` uses Razor views or serves static files:

- Confirm that static assets (CSS, JavaScript, images) are located under the `wwwroot` folder.
- Verify that Razor views render correctly and that any tag helpers or view components function as expected.

---

## 8. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs that may cause issues on Linux or macOS:

- `System.Drawing` (GDI+) — replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if used.
- Windows registry access (`Microsoft.Win32.Registry`) — remove or abstract behind a platform check.
- Windows-specific file path assumptions (e.g., hardcoded backslashes) — use `Path.Combine` and `Path.DirectorySeparatorChar` instead.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.