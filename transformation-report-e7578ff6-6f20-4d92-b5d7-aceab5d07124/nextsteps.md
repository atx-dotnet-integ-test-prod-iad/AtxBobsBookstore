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

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or framework compatibility concerns.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your database connection strings in `appsettings.json` are correctly configured for the target environment.

Check that all migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Data is read from and written to the database as expected.
- Any authentication or authorization flows function correctly.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from legacy .NET Framework projects. Confirm the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously found in `Web.config` or `App.config`.
- Any file paths used in the application use `Path.Combine` or forward-slash-compatible formats to ensure cross-platform compatibility.
- Environment-specific settings (e.g., connection strings) are not hardcoded.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining Windows-specific APIs that may have been carried over from the legacy project. Common areas to check include:

- Use of the Windows Registry (`Microsoft.Win32.Registry`)
- Windows-only authentication schemes (e.g., NTLM/Windows Authentication)
- `System.Drawing` usage, which requires additional native dependencies on Linux/macOS

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if platform-specific code paths are required.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.