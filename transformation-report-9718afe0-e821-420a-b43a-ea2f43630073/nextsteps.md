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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining Windows-specific APIs or packages. Common areas to review:

- **`Bookstore.Data`**: Verify the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server is used, confirm `Microsoft.EntityFrameworkCore.SqlServer` is referenced rather than any legacy `System.Data` components.
- **`Bookstore.Web`**: Confirm there are no references to `System.Web`, `HttpContext` from the old ASP.NET stack, or Windows Registry APIs.
- **`Bookstore.Domain`**: Check for any use of `System.Drawing` or other Windows-bound namespaces.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to surface platform-specific calls.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs correctly on the new runtime:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following manually:
- The application starts without runtime exceptions.
- Database connections (if applicable) are established correctly.
- Core application routes and pages load as expected.

---

## 7. Validate Configuration Files

Review `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are correct and use the appropriate format for the target database.
- Any configuration keys previously stored in `Web.config` or `App.config` have been migrated to the `appsettings.json` structure.
- Secrets are not hardcoded; use `dotnet user-secrets` for local development:

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.