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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify their cross-platform equivalents are in place.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Review the build output for any warnings, particularly:
- Obsolete API usage
- Nullable reference type warnings
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Verify Configuration Files

Check that configuration files have been correctly migrated:

- Confirm that `Web.config` or `App.config` settings have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Verify that connection strings in `appsettings.json` are correct and point to the intended database.
- Ensure that any environment-specific settings are properly separated by environment name.

---

## 4. Verify Entity Framework or Data Access Layer

Since the solution contains a `Bookstore.Data` project, confirm the data access layer is functioning:

- If using Entity Framework Core, verify the DbContext is correctly configured in `Program.cs` or `Startup.cs`.
- Check that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate core functionality:

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that cover:
- Data access and repository logic
- Domain model behavior
- Web layer routing and controller actions

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web
```

Manually verify the following:
- The application starts without runtime exceptions.
- Key pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization behave correctly if applicable.

---

## 7. Check Logging and Error Handling

- Confirm that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible provider such as Serilog or NLog.
- Trigger known error paths and verify that exceptions are handled and logged appropriately.
- Review the middleware pipeline in `Program.cs` to ensure error handling middleware is in place.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets, configuration files, and dependent assemblies.