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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify that all previously passing tests continue to pass.
- Pay close attention to any tests that interact with the data layer (`Bookstore.Data`), as database provider behavior can differ between .NET Framework and modern .NET.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely uses Entity Framework or another ORM, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. If the project was previously using EF 6, a migration to EF Core may require regenerating migrations:

```bash
dotnet ef migrations add InitialMigration
dotnet ef database update
```

- Verify that connection strings in `appsettings.json` are correct and accessible from the new runtime environment.

---

## 5. Run the Web Application Locally

Start the web application to confirm it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application and test core functionality such as browsing, searching, and any data submission forms.
- Check the console output and application logs for runtime exceptions that would not appear at build time.
- If the project uses `System.Web` or any other Windows-only APIs that were stubbed during transformation, those areas will require manual review and testing.

---

## 6. Review Configuration Files

- Confirm that `appsettings.json` contains all settings that were previously in `Web.config` or `App.config`.
- Verify that environment-specific configuration (e.g., `appsettings.Development.json`) is set up correctly.
- Ensure authentication, authorization, and session configuration has been correctly ported to the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs`.

---

## 7. Check Static Files and Bundling

If the application serves static assets (CSS, JavaScript, images):

- Confirm that the `wwwroot` folder is structured correctly.
- If the project previously used ASP.NET Bundling and Minification (`System.Web.Optimization`), verify that a replacement such as `BundleMinifier` or a front-end build tool has been configured.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Use `net8.0` unless there is a specific dependency on Windows APIs that requires the `-windows` suffix.