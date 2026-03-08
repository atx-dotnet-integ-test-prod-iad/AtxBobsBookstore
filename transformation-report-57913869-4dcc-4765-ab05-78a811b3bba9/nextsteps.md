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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:
- Any remaining references to `System.Web` or other Windows-only namespaces.
- Any use of `HttpContext`, `HttpRequest`, or similar types that may have changed APIs in ASP.NET Core.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the necessary configuration (connection strings, app settings, etc.).
- Any environment-specific settings are handled via `appsettings.Development.json` or environment variables.
- If `Web.config` transformations were previously used, ensure that equivalent logic has been moved to `appsettings.json` or `Program.cs`/`Startup.cs`.

---

## 4. Verify Database Connectivity

If the project uses Entity Framework, confirm the migration setup is intact.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present and the database connection string in `appsettings.json` is correct, apply the migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Walk through the core application workflows (browsing books, user authentication, data access, etc.) to confirm expected behavior.
- Check the console output and any log files for unhandled exceptions or runtime warnings.

---

## 6. Run Existing Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. If tests were written against .NET Framework-specific APIs, they may require updates to work correctly under cross-platform .NET.

---

## 7. Validate Platform Compatibility

Since the goal is cross-platform support, test the application on a non-Windows environment if possible (Linux or macOS). Common issues to look for include:

- **File path separators**: Ensure no hardcoded backslashes (`\`) are used in file paths. Use `Path.Combine` instead.
- **Case-sensitive file references**: Linux file systems are case-sensitive; verify that all file and directory references use consistent casing.
- **Windows-only APIs**: Use the [.NET Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific API calls.

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.