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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs or libraries may only function correctly on Windows. Run the .NET Compatibility Analyzer or review the code manually for usages of:

- `Microsoft.Win32` namespaces
- Windows registry access
- COM interop
- `System.Windows.Forms` or `System.Drawing` (GDI+)

If any are found, determine whether a cross-platform alternative exists or whether a runtime guard (`OperatingSystem.IsWindows()`) is appropriate.

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify:

- Pages load without runtime exceptions
- Database connectivity functions correctly (if applicable)
- Any authentication or session handling behaves as expected

---

## 6. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the database context and migrations are compatible with the new runtime.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If migrations are present, apply them to a test database to verify schema compatibility.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 7. Execute Any Existing Tests

If the solution contains test projects, run them to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that may have been passing under .NET Framework due to platform-specific behavior that no longer applies.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to the target environment.