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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check each project's `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform target, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also verify the following:

- No remaining references to `System.Web`, which is not available on cross-platform .NET.
- No use of Windows-only APIs unless the project is explicitly targeting Windows with `<TargetFramework>net8.0-windows</TargetFramework>`.
- Connection strings and configuration in `appsettings.json` are correct and not relying on `Web.config` or `App.config` transforms.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover:

- Domain model validation logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Controller actions or middleware behavior in `Bookstore.Web`

---

## 5. Validate the Data Layer

Since `Bookstore.Data` handles data access, confirm the following:

- If Entity Framework Core is used, run any pending migrations against a test database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify that the database schema matches expectations after migration.
- Test basic CRUD operations against the database to confirm the data layer functions correctly.

---

## 6. Run the Web Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Routing resolves correctly for all expected endpoints.
- Pages or API responses return expected data.
- Static assets load correctly if the project serves front-end content.

---

## 7. Review Logging and Error Handling

Ensure that logging is configured using the .NET built-in logging infrastructure (`Microsoft.Extensions.Logging`) and not a legacy framework-specific approach. Check `Program.cs` or `Startup.cs` for proper configuration.

Review any error handling middleware to confirm it behaves as expected in the new runtime environment.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.