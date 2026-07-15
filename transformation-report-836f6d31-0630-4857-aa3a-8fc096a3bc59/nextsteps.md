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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may reference Windows-only APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings that appear after rebuilding, particularly in `Bookstore.Data` and `Bookstore.Web`.

---

## 5. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** is required for cross-platform .NET.
- **Entity Framework 6 (classic)** is not fully supported on non-Windows platforms.

Check the `Bookstore.Data.csproj` for the EF package reference:

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.x.x" />
```

If a database migration is involved, run:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests, as they may indicate runtime behavioral differences between the legacy framework and the new cross-platform .NET runtime.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following at runtime:

- Application starts without exceptions.
- All routes and pages load correctly.
- Database connectivity is functional.
- Static assets (CSS, JavaScript, images) are served properly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` is present and correctly configured. Legacy projects may have relied on `Web.config` or `App.config`, which are not used in the same way on cross-platform .NET.

- Connection strings should be in `appsettings.json`.
- Any `Web.config` transforms should be migrated to `appsettings.{Environment}.json` files.

---

## 9. Validate Middleware and HTTP Pipeline

If `Bookstore.Web` is an ASP.NET Core application, review `Program.cs` or `Startup.cs` to confirm the middleware pipeline is correctly configured, including:

- Authentication and authorization middleware.
- Static file middleware.
- Routing configuration.
- Error handling middleware.

---

## 10. Publish the Application

Once all validation steps pass, publish the application:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.