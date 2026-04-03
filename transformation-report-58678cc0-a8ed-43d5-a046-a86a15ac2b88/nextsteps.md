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

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project references for any APIs or libraries that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)**
- **System.Drawing** (use `System.Drawing.Common` with caution, or migrate to an alternative like `SkiaSharp`)
- **Web.config** transformations (these should be replaced with `appsettings.json`)

Run the .NET Upgrade Assistant compatibility analyzer if further analysis is needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze ./Bookstore.sln
```

---

## 5. Validate Configuration Files

Ensure that `Web.config` or `App.config` settings have been properly migrated to `appsettings.json` and that the application reads configuration using `IConfiguration` from `Microsoft.Extensions.Configuration`.

Verify the following in `Bookstore.Web`:

- `appsettings.json` exists and contains the necessary settings (connection strings, app settings, etc.)
- `Program.cs` or `Startup.cs` correctly wires up configuration, logging, and dependency injection

---

## 6. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify it has been migrated to **Entity Framework Core**.
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the connection string in `appsettings.json` is correct for your target database.

---

## 7. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior is preserved after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET.

---

## 8. Run the Application Locally

Start the web application locally and perform manual validation of key functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:

- Application startup with no unhandled exceptions
- Database connectivity and data retrieval
- Core user-facing features (browsing, searching, purchasing books, etc.)
- Authentication and authorization flows, if applicable

---

## 9. Publish the Application

Once validation is complete, publish the application to a folder for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 10. Verify on Target Operating System

If the goal is cross-platform deployment (e.g., Linux), copy the published output to the target machine and run it there to confirm no platform-specific issues exist at runtime.

```bash
dotnet ./publish/Bookstore.Web.dll
```

Monitor application logs for any runtime errors that did not appear during local development on Windows.