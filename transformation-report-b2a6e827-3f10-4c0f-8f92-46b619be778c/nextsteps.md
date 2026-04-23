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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime, such as changes in:

- `System.Configuration` usage
- `HttpContext` behavior
- Entity Framework query translation differences

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that the database connection is functioning correctly:

- Check that the connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- If Entity Framework is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that EF Core is being used rather than EF 6, as EF 6 has limited support on cross-platform .NET.

---

## 5. Validate Domain Logic (Bookstore.Domain)

Manually review `Bookstore.Domain` for any dependencies that were previously satisfied by .NET Framework-specific libraries. Common areas to check include:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Serialization attributes from `System.Runtime.Serialization` or `Newtonsoft.Json` that may behave differently.
- Any reflection-based code that may be affected by changes in .NET's type system.

---

## 6. Test the Web Application (Bookstore.Web)

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas specifically:

- Authentication and authorization middleware is correctly configured for ASP.NET Core.
- Any `Web.config` settings have been migrated to `appsettings.json` and are being read correctly.
- Static files, routing, and model binding behave as expected.
- Any HTTP handlers or modules from the legacy project have been replaced with the equivalent ASP.NET Core middleware.

---

## 7. Review Removed or Changed APIs

Cross-reference the migrated code against the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [.NET API compatibility documentation](https://learn.microsoft.com/en-us/dotnet/core/compatibility/) to identify any APIs that were silently replaced or stubbed during transformation and may require manual attention.

---

## 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same major version to avoid cross-framework compatibility issues.

---

## 9. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the output directory contains all necessary files, including static assets and configuration files, before deploying to the target server or hosting environment.