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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review all project references and NuGet packages for any libraries that are Windows-only. Common examples include:

- `System.Web`
- `Microsoft.Web.Infrastructure`
- `System.Drawing.Common` (requires additional configuration on Linux/macOS)

If any are found, replace them with cross-platform alternatives or add the appropriate runtime guard using `RuntimeInformation.IsOSPlatform`.

---

## 5. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and verify that core functionality such as page rendering, data access, and navigation works correctly.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that any pending migrations are applied and the database schema is correct:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using Entity Framework 6, confirm the migration to Entity Framework Core was completed and that all `DbContext` configurations, relationships, and queries behave as expected.

---

## 7. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review the results and investigate any failing tests, as they may indicate behavioral differences introduced during the migration.

---

## 8. Test on Target Platforms

Since the goal is cross-platform compatibility, run and validate the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear at build time.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.