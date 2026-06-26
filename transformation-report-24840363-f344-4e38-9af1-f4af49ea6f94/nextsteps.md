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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Ensure that any settings previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 3.2 Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify the database connection:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are used, confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run the Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any unhandled exceptions or missing middleware registrations.

---

## 5. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether they indicate regressions introduced during migration or test code that itself requires updating for .NET compatibility.

---

## 6. Review Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET:

- `System.Web` references — these should have been replaced with ASP.NET Core equivalents.
- Windows Registry access (`Microsoft.Win32.Registry`).
- `System.Drawing` — consider replacing with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if image processing is used.
- Any P/Invoke calls targeting Windows-specific native libraries.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 7. Validate Dependency Injection and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm:

- All services from `Bookstore.Domain` and `Bookstore.Data` are registered correctly with the DI container.
- Middleware is ordered correctly (authentication, authorization, routing, etc.).
- Static file serving and routing are configured as expected for the application.

---

## 8. Publish the Application

Once local validation is complete, produce a published output:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application starts correctly from the published output:

```bash
dotnet ./publish/Bookstore.Web.dll
```