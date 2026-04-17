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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target where appropriate.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, inspect each project for any remaining Windows-specific APIs or libraries, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

If `Bookstore.Web` was previously an ASP.NET Web Forms or MVC 5 project, confirm it has been migrated to ASP.NET Core. Look for the presence of `Startup.cs` or `Program.cs` with the ASP.NET Core host builder pattern.

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the tests to verify that core logic remains intact after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider writing basic tests for the domain and data layers to validate expected behavior before deploying.

---

## 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The `DbContext` is correctly configured in `Bookstore.Web`'s `Program.cs` or `Startup.cs`.
- Connection strings in `appsettings.json` are valid and accessible in the target environment.

Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application locally to perform a manual smoke test.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load, data is retrieved correctly, and no runtime exceptions are thrown.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Logging configuration
- Application-specific settings

Legacy `Web.config` or `App.config` values are not automatically read by .NET applications and must be migrated to `appsettings.json` or environment variables.

---

## 9. Validate Static Files and Middleware (Bookstore.Web)

If the web project serves static files (CSS, JavaScript, images), confirm that `app.UseStaticFiles()` is present in `Program.cs` and that the files are located in the `wwwroot` directory.

Also verify that the middleware pipeline is correctly ordered, particularly for authentication, routing, and authorization if those features are used.