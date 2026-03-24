# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If test projects exist in the solution, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before deploying.

---

## 4. Verify Runtime Behavior Locally

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following during local verification:

- Application starts without exceptions
- Database connections in `Bookstore.Data` are established correctly
- All pages and endpoints return expected responses
- Any configuration values (connection strings, API keys, etc.) in `appsettings.json` are correct for the target environment

---

## 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) to confirm:

- Connection strings reference the correct database server and credentials
- Any paths or file references that were previously Windows-specific have been updated to use cross-platform equivalents (e.g., `Path.Combine` instead of hardcoded backslashes)
- Logging configuration is appropriate for the target environment

---

## 6. Check for Platform-Specific Code

Even without build errors, there may be runtime issues caused by Windows-specific APIs or behaviors. Search the codebase for the following potential concerns:

- Use of `System.Windows` or `Microsoft.Win32` namespaces
- Registry access
- Windows file path assumptions
- `Thread.CurrentThread.CurrentCulture` or locale-specific formatting that may behave differently across platforms

Use the .NET Compatibility Analyzer if a more thorough audit is needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that migrations are up to date and can be applied to the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target server.