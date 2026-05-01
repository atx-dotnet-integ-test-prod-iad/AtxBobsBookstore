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

Review the output for any warnings related to deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the chosen version is still under active or LTS support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a Bookstore application that likely originated from a .NET Framework project, audit the code for any remaining Windows-specific APIs, such as:

- `System.Web` references
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)
- `App.config` or `Web.config` configurations that should be migrated to `appsettings.json`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if needed.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, adding items, and any authentication flows if present.

---

## 6. Validate the Data Layer

Confirm that `Bookstore.Data` connects to the database correctly. If the project uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for the target environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code-level adjustments.

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all expected files, static assets, and configuration files are present before deploying to the target environment.