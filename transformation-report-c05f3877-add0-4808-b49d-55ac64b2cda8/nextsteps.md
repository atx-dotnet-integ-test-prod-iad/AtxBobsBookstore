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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding with any builds or tests.

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

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target where appropriate.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the projects for any APIs or packages that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows libraries
- Any `<RuntimeIdentifier>win-x64</RuntimeIdentifier>` entries that may restrict portability

Run the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are caused by behavioral differences between .NET Framework and modern .NET, such as changes in `HttpClient`, JSON serialization defaults (`System.Text.Json` vs `Newtonsoft.Json`), or Entity Framework version differences.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm the Entity Framework version in use. If the project was using Entity Framework 6, verify whether it has been migrated to Entity Framework Core.
- If using EF Core, run any pending migrations against a local database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correctly configured and that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is present.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- If the project was previously an ASP.NET MVC or Web Forms application, confirm it has been migrated to ASP.NET Core.
- Web Forms (`System.Web`) is **not supported** on cross-platform .NET. If any `.aspx` files or `System.Web` references remain, those components will require rewriting as Razor Pages or MVC controllers.
- Run the web application locally and navigate through core functionality:

```bash
dotnet run --project Bookstore.Web
```

- Check that middleware configuration in `Program.cs` or `Startup.cs` is correct, including routing, authentication, and static file serving.

---

## 8. Configuration Migration

- Ensure that `Web.config` or `App.config` settings have been moved to `appsettings.json`.
- Confirm that environment-specific configuration (e.g., `appsettings.Development.json`) is in place.
- Verify that connection strings, app settings, and any custom configuration sections are being read correctly using `IConfiguration`.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.