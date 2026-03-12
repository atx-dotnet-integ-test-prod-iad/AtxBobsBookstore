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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these can indicate subtle issues introduced during migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages and any direct API usage across all three projects for dependencies that are Windows-only. Common examples include:

- `Microsoft.Win32` registry APIs
- `System.Drawing.Common` (requires additional configuration on Linux/macOS)
- Any COM interop references

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific code paths.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Failures that did not exist prior to migration may indicate behavioral differences between .NET Framework and modern .NET (e.g., changes in `HttpContext`, `System.Text.Json` vs `Newtonsoft.Json`, or Entity Framework Core differences).

---

## 6. Validate the Data Layer (`Bookstore.Data`)

Since `Bookstore.Data` likely contains database access logic, verify the following:

- The correct version of Entity Framework Core is referenced if EF was used in the original project.
- Connection strings in `appsettings.json` are correctly configured.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

Start the web application locally and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- The application starts without runtime exceptions.
- Routing, middleware, and authentication (if applicable) behave as expected.
- Static files, views, or Razor Pages render correctly.
- Any configuration previously in `Web.config` has been correctly moved to `appsettings.json` and the `Program.cs` / `Startup.cs` setup.

---

## 8. Review Logging and Configuration

Confirm that the application's configuration system has been fully migrated from `Web.config` / `App.config` to the `Microsoft.Extensions.Configuration` model. Verify that environment-specific settings (e.g., development vs. production connection strings) are handled via `appsettings.{Environment}.json` or environment variables.

---

## 9. Test on Target Platforms

Since the goal of this migration is cross-platform support, run and validate the application on each intended target operating system (Windows, Linux, macOS) to surface any remaining platform-specific issues before deploying to a production environment.