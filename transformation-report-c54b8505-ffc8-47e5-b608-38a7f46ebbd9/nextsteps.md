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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions are either end-of-life or approaching it.

---

## 4. Verify Runtime Behavior

Run the web application locally and navigate through its core functionality to confirm behavior matches the legacy application.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and home page load
- Database connectivity (if `Bookstore.Data` uses Entity Framework or another ORM, confirm migrations are applied and queries execute correctly)
- Any domain logic in `Bookstore.Domain` that involves calculations, validations, or business rules

---

## 5. Apply and Verify Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and can be applied cleanly.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.

---

## 6. Run Automated Tests

If the solution contains test projects, execute them to validate that existing logic behaves as expected.

```bash
dotnet test
```

Review any failing tests and determine whether they represent genuine regressions introduced during migration or tests that require updating due to API changes in the new target framework.

---

## 7. Check for Windows-Specific APIs

Even without build errors, certain APIs may compile successfully but fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer or review the code for usage of:

- `System.Web` (should be replaced with ASP.NET Core equivalents)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext.Current` (not available in ASP.NET Core)

Run the following to surface platform compatibility warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and deployable.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, configuration files, and binaries are present before deploying to the target environment.