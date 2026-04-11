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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, scan each project for APIs or packages that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or IIS-specific middleware
- **System.Drawing** (requires `System.Drawing.Common` which has platform restrictions on non-Windows)
- Any use of `[SupportedOSPlatform("windows")]`-attributed APIs

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

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- `HttpContext` and request/response handling
- Entity Framework query translation differences
- Serialization behavior (`System.Text.Json` vs `Newtonsoft.Json`)

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core is being used rather than the legacy Entity Framework 6.
- Verify that the `DbContext` configuration uses `OnConfiguring` or dependency injection correctly.
- Run any pending migrations or verify the schema against the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` follows the minimal hosting model introduced in .NET 6+, replacing the legacy `Startup.cs` pattern if it has not been updated already.
- Verify middleware registration order, particularly for authentication, authorization, routing, and static files.
- Start the application locally and navigate through core workflows:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the application at `https://localhost:{port}` and review the console output for runtime exceptions or middleware configuration warnings.

---

## 8. Review Configuration Files

- Ensure `appsettings.json` contains the correct connection strings and application settings previously held in `Web.config` or `App.config`.
- Confirm that environment-specific overrides are in place using `appsettings.Development.json` and `appsettings.Production.json` as appropriate.
- Verify that secrets (connection strings, API keys) are not committed to source control. Use `dotnet user-secrets` for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm a clean release output.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.