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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for their cross-platform compatible replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `net48`, `netcoreapp3.1`, or another EOL framework, update it accordingly and re-run `dotnet restore` and `dotnet build`.

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, certain APIs or packages may only function correctly on Windows. Search the codebase for the following:

- Usage of `Microsoft.Win32` namespaces
- References to `System.Web` (not supported on cross-platform .NET)
- Any P/Invoke calls to Windows-native DLLs
- Packages that have a `[SupportedOSPlatform("windows")]` annotation

If any are found, evaluate whether a cross-platform alternative exists or whether a runtime OS guard is appropriate.

---

## 5. Database Migration Verification (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that all migrations are up to date and compatible with the new framework version.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the schema has changed or migrations are missing, create a new migration:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed in the application code.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without exceptions
- Key pages and routes load correctly
- Database reads and writes function as expected
- Authentication and authorization behave correctly if applicable

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration values. Legacy `Web.config` or `App.config` settings should have been migrated to `appsettings.json`. Confirm that:

- Connection strings are present and correct
- Any environment-specific values are externalized appropriately using environment variables or secrets management

---

## 9. Validate Logging and Error Handling

Confirm that the logging framework (e.g., `Microsoft.Extensions.Logging`, Serilog, NLog) is correctly configured in `Program.cs` or `Startup.cs`. Run the application and intentionally trigger an error to verify that exceptions are logged and handled as expected.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to confirm a clean release output.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.