# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements targeting .NET 6/7/8 (whichever version was targeted during transformation).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what the error report captured:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3a. Run the Web Project Locally

Start the `Bookstore.Web` project and confirm the application launches without runtime exceptions:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application's key pages and features to confirm they behave as expected.

### 3b. Check Data Layer Connectivity

Confirm that `Bookstore.Data` connects to its data source correctly. Verify the connection string in `appsettings.json` (or `appsettings.Development.json`) is accurate for your environment.

If the project uses Entity Framework Core, apply or verify migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 4. Run Existing Tests

If the solution contains test projects, execute them to validate that the domain logic and data access behave correctly after migration:

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences between the legacy .NET Framework APIs and their .NET equivalents.

---

## 5. Review `Bookstore.Domain` Logic

Since `Bookstore.Domain` is the most foundational project, manually review its core models and business logic for any reliance on APIs that behave differently in cross-platform .NET. Pay particular attention to:

- `System.Configuration` usage (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` or `HttpRequest` usage outside of ASP.NET Core's request pipeline
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET

---

## 6. Check for Platform-Specific Code

Run the .NET Upgrade Assistant compatibility analyzer or the Platform Compatibility Analyzer to surface any remaining Windows-specific API calls that may fail on non-Windows environments:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review any `CA1416` warnings, which indicate platform-specific API usage.

---

## 7. Publish the Application

Once validation is complete, publish the application for your target environment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Confirm the contents of the `./publish` directory are complete and that the application runs correctly from the published output:

```bash
dotnet ./publish/Bookstore.Web.dll
```