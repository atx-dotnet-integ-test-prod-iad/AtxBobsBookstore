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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any libraries that are Windows-only. Common examples include:

- `System.Drawing.Common` (requires additional configuration on non-Windows)
- `Microsoft.Win32.*` namespaces
- COM interop references

If any are found, replace them with cross-platform alternatives or add the appropriate runtime guard using `RuntimeInformation.IsOSPlatform`.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality is preserved:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences between the old and new target frameworks.

---

## 7. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify core functionality such as:

- Page rendering
- Data retrieval and display
- Form submissions
- Authentication, if applicable

---

## 8. Validate Configuration Files

Review `appsettings.json` (and `appsettings.Development.json`) to confirm:

- Connection strings are correct and accessible.
- Any configuration keys previously stored in `Web.config` have been migrated to `appsettings.json`.
- The `Web.config` file is no longer relied upon for runtime configuration (it may still exist for IIS hosting purposes, but application settings should be in `appsettings.json`).

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all necessary files are present, then deploy the contents to your target hosting environment (e.g., IIS, Azure App Service, or a Linux server with the .NET runtime installed).