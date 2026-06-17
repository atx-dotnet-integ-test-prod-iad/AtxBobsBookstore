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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or `netstandard2.0`, evaluate whether it needs to be updated to a modern TFM.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs may only function correctly on Windows. Run the .NET Compatibility Analyzer to surface any platform-specific API usage.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in modern .NET)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core provider is installed and that migrations are up to date.

```bash
dotnet ef dbcontext info --project app/Bookstore.Data
dotnet ef migrations list --project app/Bookstore.Data
```

If migrations are missing or the schema is out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If the solution contains test projects, execute them to validate that business logic and data access behavior is consistent with the original application.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and modern .NET runtime.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the following areas specifically:
- Application startup and middleware configuration in `Program.cs`
- Authentication and authorization behavior
- Routing and controller/action resolution
- Static file serving
- Any configuration values previously stored in `Web.config` that should now be in `appsettings.json`

---

## 8. Validate Configuration Migration

Ensure that all values previously in `Web.config` or `App.config` have been correctly moved to `appsettings.json` or environment variables. Key areas to check:

- Connection strings
- Application settings keys
- Custom configuration sections

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "AppSettings": {
    "SomeKey": "SomeValue"
  }
}
```

---

## 9. Verify Logging

If the application previously used `System.Diagnostics` or a third-party logger like log4net, confirm that logging has been migrated to `Microsoft.Extensions.Logging` or a compatible provider such as Serilog or NLog, and that log output is appearing as expected during local runs.