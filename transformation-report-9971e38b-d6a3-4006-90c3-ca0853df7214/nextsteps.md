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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is an explicit reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- Windows Registry access via `Microsoft.Win32`
- Any remaining references to `System.Drawing` without the `System.Drawing.Common` NuGet package, which has platform-specific limitations as of .NET 6+

In `Bookstore.Web`, verify that the web framework has been migrated from ASP.NET (System.Web) to ASP.NET Core if applicable.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework 6 was used previously, verify whether it has been migrated to Entity Framework Core, as EF6 has limited support on cross-platform .NET.
- Run any pending migrations or verify the database schema is compatible:

```bash
dotnet ef migrations list --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

- Confirm the connection string in `appsettings.json` or equivalent configuration is correct for the target environment.

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between the legacy framework and the new cross-platform .NET runtime.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions
- Core application routes and pages load correctly
- Database read and write operations function as expected
- Authentication and authorization flows work if applicable

---

## 8. Review Configuration and Environment Settings

Confirm that configuration files have been properly migrated:

- `Web.config` values should be moved to `appsettings.json` or `appsettings.{Environment}.json`
- Environment-specific settings such as connection strings and API keys should be externalized using environment variables or a secrets manager
- Verify that `Program.cs` and `Startup.cs` (or the minimal hosting model in `Program.cs` for .NET 6+) correctly registers all required services

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.