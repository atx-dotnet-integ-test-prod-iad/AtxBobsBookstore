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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any NuGet packages that only support Windows

You can use the .NET Compatibility Analyzer or run the following to check platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project locally to verify the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify the following:

- The application starts without runtime exceptions
- All pages or API endpoints load correctly
- Database connectivity functions as expected (see section below)

---

## 6. Validate Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Connection strings** in `appsettings.json` are correct and point to the intended database.
- If Entity Framework Core is used, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review test results carefully. Failures may indicate runtime behavioral differences between .NET Framework and modern .NET that were not caught at compile time.

---

## 8. Validate Configuration and Middleware

In `Bookstore.Web`, review the `Program.cs` (and `Startup.cs` if still present) for the following:

- Middleware is registered in the correct order
- Authentication and authorization configuration is correct
- Static files, routing, and session configuration are appropriate for ASP.NET Core

If the project was migrated from ASP.NET MVC (System.Web), confirm that all `System.Web` references have been removed and replaced with their ASP.NET Core equivalents.

---

## 9. Test on Target Platforms

Since the goal is cross-platform support, test the application on each intended operating system:

```bash
# On Linux or macOS
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay attention to:

- File path separators
- Case-sensitive file systems (Linux)
- Any platform-specific runtime behavior

---

## 10. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.