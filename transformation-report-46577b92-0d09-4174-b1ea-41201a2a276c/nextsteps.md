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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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

If any project is still targeting `net472` or another legacy framework, update the target framework accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for APIs or packages that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)**
- **System.Drawing** (use `System.Drawing.Common` with caution, or migrate to an alternative such as `SkiaSharp`)
- **Web.config** transformations (these should be replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` stack)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is correctly referenced and compatible with the target framework.
- Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist, generate an initial migration and review the output:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate the Domain Layer (`Bookstore.Domain`)

- Confirm that all domain models, interfaces, and business logic compile without warnings.
- Check that any serialization attributes (e.g., `[Serializable]`, `[DataContract]`) are still applicable and supported under the target framework.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (if present) follow the current .NET hosting model. In .NET 6 and later, the minimal hosting model consolidates these into a single `Program.cs`.
- Verify that middleware registration, dependency injection configuration, and routing are functioning as expected.
- Check that `appsettings.json` contains the necessary configuration entries, including connection strings that were previously in `Web.config`.

---

## 8. Run the Application Locally

Start the web application and verify basic functionality:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the displayed local URL and confirm that:

- The application starts without runtime exceptions.
- Database connectivity is established.
- Core pages and features load correctly.

---

## 9. Execute Existing Tests

If the solution contains a test project, run all tests to validate that behavior has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral changes in the new framework or pre-existing issues.

---

## 10. Review Application Logs

After running the application, review the console output and any structured log files for runtime warnings or errors that did not surface at build time. Pay particular attention to:

- Middleware pipeline errors
- Entity Framework query translation warnings
- Authentication and authorization configuration issues