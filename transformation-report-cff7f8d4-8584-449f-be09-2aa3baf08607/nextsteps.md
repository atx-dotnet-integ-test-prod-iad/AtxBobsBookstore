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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the chosen version is still under active or LTS support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured correctly and connection strings are environment-agnostic.
- **`Bookstore.Web`**: Check for any use of `System.Web`, Windows Authentication, or MSMQ, which do not have direct cross-platform equivalents.
- **`Bookstore.Domain`**: Verify no platform-specific serialization or file path logic is present.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to surface compatibility issues.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic integration tests for the data layer and smoke tests for the web layer before deploying.

---

## 6. Validate the Data Layer

- Apply any pending Entity Framework Core migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema matches expectations after migration.
- Test basic CRUD operations against a local or staging database instance.

---

## 7. Run the Web Application Locally

Start the web application and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the primary user flows (e.g., browsing books, user authentication if applicable).
- Check application logs for runtime exceptions that would not surface at build time.
- Verify that configuration values (e.g., connection strings, API keys) are being read correctly from `appsettings.json` or environment variables.

---

## 8. Review Configuration and Secrets

Ensure that sensitive configuration values are not hardcoded. The recommended approach for .NET is:

- Use `appsettings.json` for non-sensitive settings.
- Use `dotnet user-secrets` for local development secrets.
- Use environment variables or a secrets manager for production.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and dependencies are present before deploying to the target environment.