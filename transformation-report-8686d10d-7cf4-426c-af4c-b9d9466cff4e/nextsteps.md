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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` targets, consider updating them to their latest versions that support the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., `[SupportedOSPlatform]`)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- `appsettings.Development.json` is present and contains environment-specific overrides.
- Any connection strings referencing SQL Server use the correct format for the target environment.

---

## 4. Verify Entity Framework or Data Layer

In `Bookstore.Data`, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Confirm that pages load, data is retrieved from the database, and no runtime exceptions appear in the console.

---

## 6. Run Existing Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests. Failures may indicate:
- Behavioral differences between .NET Framework and cross-platform .NET.
- Missing or changed APIs.
- Configuration or dependency injection issues in test setup.

---

## 7. Check for Windows-Specific API Usage

Since this is a cross-platform migration, audit the code for APIs that are Windows-only. Common areas to check:

- `System.Web` references (these should have been removed or replaced).
- Windows Registry access (`Microsoft.Win32.Registry`).
- Windows-specific file path assumptions (e.g., hardcoded backslashes — use `Path.Combine` instead).
- Any P/Invoke calls targeting Windows DLLs.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this audit if needed.

---

## 8. Validate Middleware and HTTP Pipeline

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured:

- Authentication and authorization middleware is registered in the correct order.
- Static files middleware is present if the application serves CSS, JS, or images.
- Exception handling middleware is configured for both development and production environments.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.