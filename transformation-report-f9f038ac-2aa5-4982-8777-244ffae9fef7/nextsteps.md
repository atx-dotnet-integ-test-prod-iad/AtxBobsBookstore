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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still within its support window.

---

## 4. Verify Configuration Files

- Confirm that `Web.config` has been replaced or supplemented by `appsettings.json` and `appsettings.{Environment}.json`.
- Ensure connection strings, application settings, and environment-specific values have been correctly migrated to the new configuration system.
- Verify that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) correctly register services, middleware, and configuration sources.

---

## 5. Check Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, verify the following:

- If using **Entity Framework Core**, confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If using a different data access strategy (e.g., Dapper, ADO.NET), confirm that connection handling and provider APIs are compatible with .NET.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

- Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.
- Pay particular attention to tests covering `Bookstore.Domain` logic and `Bookstore.Data` repository methods, as these are the most foundational layers.

---

## 8. Validate Static Assets and Razor Views

For `Bookstore.Web`, confirm the following:

- Razor views (`.cshtml`) render correctly and do not reference removed or renamed tag helpers.
- Static assets (CSS, JavaScript, images) are served correctly. In ASP.NET Core, static files must reside in the `wwwroot` folder and `UseStaticFiles()` middleware must be registered.
- Bundling and minification, if previously handled by `BundleConfig.cs`, has been replaced with an appropriate alternative such as `LibMan`, `npm`, or a build tool like `webpack`.

---

## 9. Review Authentication and Authorization

If the application uses authentication, verify the following:

- ASP.NET Membership or legacy `FormsAuthentication` has been replaced with ASP.NET Core Identity or an equivalent mechanism.
- Authorization policies, roles, and claims are correctly configured in the middleware pipeline.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is well-formed.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, assemblies, and assets are present before deploying to your target environment.