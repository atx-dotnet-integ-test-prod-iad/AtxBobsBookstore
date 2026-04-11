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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Verify that none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a deliberate reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only and may not function correctly on Linux or macOS. Common areas to inspect include:

- Use of `System.Drawing` (replaced by cross-platform alternatives such as `SkiaSharp` or `ImageSharp`)
- Registry access via `Microsoft.Win32.Registry`
- Windows-specific authentication or identity packages
- Any P/Invoke calls targeting Windows DLLs

---

## 5. Database Migration Validation

If `Bookstore.Data` uses Entity Framework Core, verify that any existing migrations are compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated, apply migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` results file for any failing tests. If no test project exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:

- Application starts without exceptions
- Database connectivity is functional
- Core user-facing features such as browsing, searching, and purchasing books work as expected
- Authentication and authorization behave correctly if applicable

---

## 8. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Production.json` to confirm:

- Connection strings are correct for the target environment
- Any environment-specific values previously stored in `Web.config` have been migrated to the appropriate `appsettings` file
- Sensitive values such as API keys or passwords are stored using environment variables or a secrets manager rather than in plain text

---

## 9. Validate Static Assets and Razor Views

If the project uses Razor Pages or MVC views, browse through the main pages and confirm:

- Static files such as CSS and JavaScript are served correctly
- Bundling and minification are functioning if configured
- No view compilation errors appear at runtime

---

## 10. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.