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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build output shows **0 Error(s)** for all three projects before moving forward.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and rebuild.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`System.Web` dependencies**: This namespace is not available in cross-platform .NET. If any code referenced it, confirm it has been replaced with ASP.NET Core equivalents.
- **`HttpContext` and related types**: Ensure these are injected via `IHttpContextAccessor` rather than accessed statically.
- **`ConfigurationManager`**: This should be replaced with `Microsoft.Extensions.Configuration`.
- **`BinaryFormatter`**: This has been disabled by default. Replace with a supported serialization mechanism if it was in use.

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify runtime behavior is consistent with the original application:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration rather than pre-existing failures.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, verify the following:

- The connection string format is compatible with the new configuration system (`appsettings.json` rather than `web.config` or `app.config`).
- If Entity Framework is used, confirm the version is EF Core and run a test query or migration:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If a different ORM or ADO.NET is used, run a basic connectivity test against the target database.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and check:

- Pages load without runtime exceptions.
- Data is read from and written to the database correctly.
- Authentication and authorization flows work as expected, if applicable.
- Static files (CSS, JavaScript, images) are served correctly.

---

## 8. Review Application Logs

While running locally, monitor the console output and any configured log sinks for warnings or errors that may not surface as build failures but indicate runtime issues, such as:

- Missing configuration keys.
- Middleware ordering problems.
- Unhandled exceptions in request pipelines.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets and configuration files are present before deploying to the target environment.