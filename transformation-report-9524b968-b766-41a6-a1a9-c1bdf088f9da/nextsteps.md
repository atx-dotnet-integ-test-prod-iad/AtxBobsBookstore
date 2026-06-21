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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated to versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, certain APIs or packages may only function on Windows. Review the following areas:

- Any use of `Microsoft.Win32` or `System.Windows` namespaces in `Bookstore.Domain` or `Bookstore.Data`.
- References to `System.Web` which is not available on cross-platform .NET. If found, these should be replaced with `Microsoft.AspNetCore` equivalents.
- Any P/Invoke calls or COM interop that may be platform-specific.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
cd app/Bookstore.Web
dotnet run
```

- Confirm the application starts without runtime exceptions.
- Navigate through the key pages and features of the bookstore (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output for any runtime warnings or errors.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection is functioning correctly.

- Verify the connection string in `appsettings.json` is correct for the target environment.
- If migrations are used, run the following to apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Confirm that data can be read from and written to the database through the application.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced by the migration. Pay particular attention to tests covering:

- Domain logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Controller actions or middleware in `Bookstore.Web`

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order.
- Authentication and authorization configuration has been updated to use ASP.NET Core equivalents if it was previously using `System.Web` based mechanisms.
- Static file serving, routing, and error handling are configured appropriately for ASP.NET Core.

---

## 9. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.