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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net472` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining Windows-specific APIs or libraries, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Replace or refactor any such dependencies with cross-platform alternatives available in .NET.

---

## 5. Database and Data Layer Validation

In `Bookstore.Data`, verify the following:

- The Entity Framework (or other ORM) version in use is compatible with .NET (e.g., EF Core 7 or 8, not EF 6).
- Connection strings in `appsettings.json` are correctly configured.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they indicate regressions introduced during migration or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following manually:

- Application starts without runtime exceptions.
- All routes and pages load correctly.
- Data is retrieved and displayed as expected from `Bookstore.Data` and `Bookstore.Domain`.
- Any authentication or authorization flows function correctly.

---

## 8. Review Configuration Files

Confirm that configuration has been fully migrated from any legacy formats:

- `Web.config` and `App.config` settings should be moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Middleware previously configured via `Web.config` (e.g., HTTP handlers, modules) should be re-implemented using ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

---

## 9. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present before deploying to the target environment.