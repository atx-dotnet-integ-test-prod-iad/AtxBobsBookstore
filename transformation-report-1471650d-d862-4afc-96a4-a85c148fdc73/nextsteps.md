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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure that `Bookstore.Data` and `Bookstore.Domain` are not referencing a newer or incompatible framework version than `Bookstore.Web`.

---

## 4. Verify Runtime Behavior

Run the web application locally to confirm it starts without errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:
- The application starts and listens on the expected port.
- Database connections (if applicable) are established correctly.
- Key pages or endpoints return expected responses.

---

## 5. Check Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, verify that migrations and the database schema are compatible with the new runtime.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 7. Validate Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain the correct configuration values. Legacy `Web.config` or `App.config` entries do not carry over automatically to .NET and must be manually migrated to `appsettings.json` or environment variables.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required files, static assets, and configuration files are present before deploying to the target environment.