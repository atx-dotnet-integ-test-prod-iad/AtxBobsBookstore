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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still under active or LTS support.

---

## 4. Validate Runtime Behavior

### 4.1 Run Existing Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET (e.g., changes in `System.Web`, `HttpContext`, Entity Framework behavior, or serialization).

### 4.2 Manual Smoke Testing

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas at a minimum:

- Application startup and home page load
- Database connectivity via `Bookstore.Data`
- Domain logic execution through `Bookstore.Domain`
- Any authentication or session-related functionality
- Form submissions and data persistence

---

## 5. Check for Runtime-Only Issues

Some issues do not surface at compile time. Pay attention to the following areas during runtime testing:

- **Configuration**: Ensure `appsettings.json` contains all settings previously held in `Web.config` or `App.config`, including connection strings and application keys.
- **Entity Framework**: If using EF Core, verify that migrations are up to date and the database schema matches expectations. Run `dotnet ef database update` if needed.
- **Static Files and Routing**: Confirm that routes, static assets, and middleware are configured correctly in `Program.cs` or `Startup.cs`.
- **Globalization and Encoding**: Verify that any locale or encoding-specific behavior works as expected under modern .NET defaults.

---

## 6. Prepare for Deployment

Once local validation is complete:

1. Publish the application using the .NET CLI:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Confirm the output directory contains all required files, including static assets and configuration files.
3. Verify the target hosting environment has the correct .NET runtime installed. You can download the appropriate runtime from [https://dotnet.microsoft.com/en-us/download](https://dotnet.microsoft.com/en-us/download).
4. Deploy the contents of the `./publish` directory to your hosting environment and perform a final validation pass against the deployed instance.