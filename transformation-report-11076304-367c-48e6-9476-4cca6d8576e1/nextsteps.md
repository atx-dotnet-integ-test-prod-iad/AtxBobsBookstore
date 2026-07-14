# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs available in .NET Framework may behave differently or have been removed in cross-platform .NET. Pay specific attention to:

- **`Bookstore.Data`**: Verify that Entity Framework or any data access library has been updated to its cross-platform equivalent (e.g., EF Core instead of EF 6). Confirm that database connection strings and providers are compatible.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or MVC project targeting .NET Framework, confirm it has been migrated to ASP.NET Core. Web Forms is not supported on cross-platform .NET.
- **`Bookstore.Domain`**: Review any use of `System.Configuration`, `System.Web`, or other .NET Framework-specific namespaces that may have been silently removed or stubbed out.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or smoke tests that exercise the core domain logic and data access layer before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:
- Application starts without runtime exceptions.
- Database connectivity is functional.
- Core application routes and pages load correctly.
- Any authentication or session management behaves as expected.

---

## 7. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm that:

- All connection strings have been moved to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.Development.json` and `appsettings.Production.json`.
- Any remaining `.config` files are not being relied upon at runtime.

---

## 8. Validate Static Assets and Middleware (Bookstore.Web)

If the web project serves static files, confirm that the `wwwroot` folder is properly structured and that the ASP.NET Core static file middleware is configured in `Program.cs` or `Startup.cs`:

```csharp
app.UseStaticFiles();
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, assets, and dependencies are present before deploying to the target environment.