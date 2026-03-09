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

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under .NET compared to the legacy .NET Framework.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Access Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Connection strings** in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- If Entity Framework is used, confirm that migrations are up to date by running:

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

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Database reads and writes function as expected.
- Any authentication or session handling behaves correctly, as these areas often differ between legacy ASP.NET and modern ASP.NET Core.

---

## 6. Review Configuration and Middleware

Cross-platform .NET uses `appsettings.json` and the `Program.cs`/`Startup.cs` pattern rather than `Web.config`. Confirm the following:

- All configuration values previously in `Web.config` (connection strings, app settings, custom sections) have been moved to `appsettings.json` or environment variables.
- Middleware registration in `Program.cs` covers what was previously handled by HTTP modules or handlers in the legacy project.
- Static file serving, routing, and error handling middleware are all registered in the correct order.

---

## 7. Check for Platform-Specific Code

Since this is now a cross-platform project, review the codebase for any remaining Windows-specific dependencies:

- Use of `Microsoft.Win32` registry APIs.
- Windows-only file path assumptions (e.g., backslashes).
- Any P/Invoke calls or COM interop that may not function on non-Windows platforms.

Use `Path.Combine` and `Path.DirectorySeparatorChar` for file path handling to ensure cross-platform compatibility.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output before deploying to the target environment.