# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding with any builds or tests.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no runtime or compile-time issues that were not caught during the initial transformation analysis.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any NuGet packages or APIs that are Windows-only. Common examples include:

- `System.Drawing.Common` (requires additional configuration on Linux/macOS)
- `Microsoft.Win32` namespace usage
- COM interop or registry access

If any are found, replace them with cross-platform alternatives or add the appropriate runtime guard using `RuntimeInformation.IsOSPlatform`.

---

## 5. Review `Bookstore.Data` for Database Configuration

Since `Bookstore.Data` is a data access layer, verify the following:

- The connection string is not hardcoded and is instead read from `appsettings.json` or environment variables.
- Entity Framework Core (if used) is configured correctly in `Program.cs` or `Startup.cs`.
- Any database migrations are up to date.

Run pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality such as navigation, data retrieval, and form submissions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for any runtime exceptions or middleware configuration issues.

---

## 8. Review `appsettings.json` and Environment Configuration

Confirm that `appsettings.json` contains all necessary configuration values previously held in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 9. Validate on Target Platforms

If cross-platform support is a goal, run the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that may not appear during a build.