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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects in the same solution can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework usage has been updated to EF Core. Confirm that database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced and configured correctly in the `DbContext`.
- **`Bookstore.Web`**: Confirm that any previously used `System.Web` namespaces have been replaced with their ASP.NET Core equivalents. Check areas such as authentication, session management, HTTP context access, and bundling/minification.
- **`Bookstore.Domain`**: Inspect any serialization, configuration, or reflection-based code that may rely on behavior specific to .NET Framework.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core business logic and data access behavior.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally and verify basic functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas:

- Application starts without runtime exceptions
- Database connectivity is functional (check connection strings in `appsettings.json`)
- Core pages and routes load correctly
- Authentication and authorization behave as expected
- Any file I/O or path-dependent code works correctly on the target OS

---

## 7. Review Configuration Files

.NET applications use `appsettings.json` instead of `Web.config` or `App.config`. Confirm that:

- Connection strings have been migrated to `appsettings.json`
- Any environment-specific settings use `appsettings.Development.json` or environment variables
- No sensitive values are hardcoded

---

## 8. Validate Static Files and Middleware Pipeline

In ASP.NET Core, static files and middleware must be explicitly configured. In `Program.cs` or `Startup.cs`, confirm the following middleware is present and ordered correctly:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers(); // or app.MapRazorPages() depending on the project type
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target environment.