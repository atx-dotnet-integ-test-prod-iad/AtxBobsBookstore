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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas where the code may behave differently under .NET compared to the legacy framework.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Behavior

Since `Bookstore.Data` handles data access, confirm the following:

- **Database provider**: Ensure the correct EF Core provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced and configured in the project.
- **Migrations**: If Entity Framework Core is used, verify existing migrations are intact and apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- **Connection strings**: Confirm that connection strings in `appsettings.json` are correct for the target environment.

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly in a local environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary user-facing features.
- Check the console output and application logs for any runtime exceptions or middleware configuration issues.
- Pay particular attention to areas that previously relied on `System.Web` or other Windows-specific APIs, as these are common sources of runtime issues after migration even when the build succeeds.

---

## 6. Review Configuration and Middleware

Open `Bookstore.Web/Program.cs` (or `Startup.cs` if present) and verify:

- Middleware is registered in the correct order.
- Services such as authentication, authorization, and session management are configured appropriately for ASP.NET Core.
- Static file serving, routing, and error handling are set up correctly.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining platform-specific dependencies that may not surface as build errors but could cause runtime failures on non-Windows platforms:

- References to `Microsoft.Win32` or the Windows registry.
- Use of `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed).
- File path separators hardcoded as `\` instead of using `Path.Combine`.

---

## 8. Review Target Framework

Confirm that all three projects target the intended cross-platform framework version in their `.csproj` files:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other Windows-only target framework moniker.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all required assets, configuration files, and binaries are present before deploying to the target environment.