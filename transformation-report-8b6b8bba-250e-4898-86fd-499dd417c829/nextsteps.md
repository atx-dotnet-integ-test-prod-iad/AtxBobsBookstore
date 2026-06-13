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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

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

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the chosen version is still under active support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the projects for any APIs or packages that are Windows-only. Common areas to check:

- `Bookstore.Data`: Verify the database provider (e.g., Entity Framework Core) is configured correctly and does not rely on Windows-specific connection mechanisms.
- `Bookstore.Web`: Confirm that no `System.Web` references remain. These are not available in .NET Core or later.
- Any use of the Windows Registry, COM interop, or Windows-specific file paths should be replaced with cross-platform alternatives.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

Review test results carefully. Failures may indicate behavioral differences between the legacy .NET Framework runtime and the current .NET runtime, even when the build succeeds.

If no test project exists, consider writing basic integration and unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 6. Validate the Web Application Locally

Run the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- Application starts without runtime exceptions.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Core application workflows such as browsing, searching, and any data entry forms operate as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 7. Validate Configuration Files

Ensure that configuration has been properly migrated from `Web.config` or `App.config` to `appsettings.json`. Key areas to verify:

- Database connection strings
- Application-specific settings
- Logging configuration
- Any authentication or authorization settings

The `appsettings.json` structure should follow the standard .NET configuration format:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present, including static assets and configuration files.