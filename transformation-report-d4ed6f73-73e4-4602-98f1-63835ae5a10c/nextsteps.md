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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference old `net4x` target frameworks, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output shows `Build succeeded` with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the target framework is set to a supported cross-platform version, such as `net8.0` or `net6.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another Windows-only framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific APIs

Search the codebase for any APIs that are Windows-specific and may not function correctly on Linux or macOS. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- Registry access (`Microsoft.Win32.Registry`)
- Windows file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- If using **Entity Framework**, confirm the project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If connection strings were previously stored in `Web.config`, confirm they have been moved to `appsettings.json`.

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to validate that business logic and data access behave as expected after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:

- Application startup with no unhandled exceptions
- Database connectivity and data retrieval
- Authentication and authorization flows, if applicable
- Static file serving (CSS, JS, images)
- Any areas of the application that previously relied on `Global.asax`, HTTP Modules, or HTTP Handlers, as these need to be replaced with ASP.NET Core middleware

---

## 8. Review Configuration and Middleware

If the project originated from an ASP.NET (non-Core) application, confirm that:

- `Startup.cs` or `Program.cs` correctly registers all required services and middleware
- `appsettings.json` contains all necessary configuration values previously held in `Web.config`
- Logging is configured using `Microsoft.Extensions.Logging` or a compatible provider

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the `./publish` directory to ensure all required files, including static assets and configuration files, are present before deploying to the target environment.