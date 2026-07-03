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

The following steps outline how to validate, test, and deploy the migrated solution.

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

Verify that all three projects build without warnings or errors. Pay attention to any warnings about obsolete APIs or framework-specific members that may have been carried over from the legacy project.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the expected database and that any Entity Framework migrations are up to date. Run pending migrations if necessary:

  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```

- **Configuration**: Verify that `appsettings.json` contains the correct connection strings and application settings, as legacy `Web.config` or `App.config` values may not have been fully migrated.

- **Static files and routing**: Confirm that pages, routes, and static assets load correctly in the browser.

- **Authentication and authorization**: If the application uses any authentication middleware, verify that it is configured correctly in `Program.cs` or `Startup.cs`.

---

## 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `netcoreapp*` or `net4*`, update it to the appropriate current target.

---

## 6. Address Any Remaining Compatibility Concerns

Review the code for any patterns that are common sources of issues after migration:

- Usages of `System.Web` namespaces, which are not available in cross-platform .NET.
- References to Windows-specific APIs (e.g., registry access, Windows identity APIs) that may fail on non-Windows platforms.
- Any third-party libraries that were present in the legacy project should be verified to have .NET-compatible versions available on NuGet.

---

## 7. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.