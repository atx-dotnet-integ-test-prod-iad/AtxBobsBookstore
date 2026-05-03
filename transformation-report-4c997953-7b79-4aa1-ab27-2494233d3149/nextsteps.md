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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` which is the current Long Term Support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the code and project files for any remaining Windows-specific dependencies that may not be cross-platform compatible. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or NTLM-specific configurations
- **`System.Drawing`** (use `System.Drawing.Common` with caution, or migrate to an alternative like `SkiaSharp`)
- **Connection strings** in `appsettings.json` that may reference a SQL Server instance only reachable on Windows

---

## 5. Validate Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is properly configured.
- Run any pending migrations against a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the core functionality of the application, including:

- Page rendering
- Data retrieval from the database
- Any form submissions or write operations

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests that may have been written against .NET Framework behaviors that differ in cross-platform .NET, such as:

- Exception message text differences
- Culture-sensitive string formatting
- File path separator differences (`\` vs `/`)

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) are correctly configured. Legacy projects often stored configuration in `Web.config` or `App.config`, which are not used in the same way in cross-platform .NET.

Verify the following have been migrated appropriately:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is as expected.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files.