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

If any project is still targeting `netcoreapp3.1`, `net5.0`, or `net6.0`, update it to a current long-term support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-only APIs or libraries remain in use. Common areas to inspect include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or NTLM-specific configurations
- **COM interop** references
- Any NuGet packages that only support `net4x` target frameworks

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to help identify these.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version in use is Entity Framework Core, not the legacy `EntityFramework` (EF6) package.

```bash
dotnet list package
```

If EF Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations against a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to confirm existing functionality is preserved.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code-level adjustments.

---

## 7. Run the Application Locally

Start the web application locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following manually:

- Application starts without runtime exceptions
- Database connectivity is functional
- Core application routes and pages load correctly
- Any authentication or authorization flows behave as expected

---

## 8. Review `appsettings.json` and Configuration

Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration
- Any environment-specific overrides (`appsettings.Development.json`, etc.)

---

## 9. Validate on Target Operating Systems

If cross-platform support is a goal, test the application on each intended operating system (e.g., Linux, macOS) to surface any remaining platform-specific issues before deploying to a production environment.

```bash
dotnet run --project Bookstore.Web
```

Run this on each target platform and compare behavior.