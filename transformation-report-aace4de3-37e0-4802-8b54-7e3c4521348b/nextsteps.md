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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are now using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- **Nullable reference type warnings** – These are enabled by default in modern .NET and may indicate potential null reference issues that were previously undetected.
- **Obsolete API warnings** – Some APIs available in .NET Framework may have been marked obsolete or replaced in cross-platform .NET.

---

## 3. Verify Runtime Behavior

### 3a. Check Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present and correctly configured. Legacy `Web.config` or `App.config` settings should have been migrated to `appsettings.json`. Confirm the following are accounted for:

- Database connection strings
- Application-specific settings
- Logging configuration

### 3b. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, confirm that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider matching your database).
- Any database migrations are present and up to date. Run the following to apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the console output and manually verify:

- Pages load without errors
- Database reads and writes function correctly
- Any authentication or authorization flows behave as expected

---

## 5. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to:
- Behavioral differences between .NET Framework and cross-platform .NET
- Missing or changed APIs
- Test infrastructure that also requires updating

---

## 6. Review Platform-Specific Code

Search the codebase for any remaining platform-specific APIs that may compile successfully but fail at runtime on non-Windows environments. Common areas to check include:

- `System.Drawing` usage (replaced by libraries such as `SkiaSharp` or `ImageSharp` for cross-platform support)
- Windows Registry access (`Microsoft.Win32.Registry`)
- `System.Web` references that may have been shimmed during transformation
- File path separators — use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes

---

## 7. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required static assets, configuration files, and binaries are present before deploying to the target environment.