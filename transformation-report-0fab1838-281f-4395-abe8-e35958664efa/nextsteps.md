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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still actively supported.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check:

- `Bookstore.Data`: Confirm the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server is used, verify the connection string and driver are compatible.
- `Bookstore.Web`: Check for any usage of `System.Web`, Windows Authentication, or IIS-specific configuration that may not translate directly to ASP.NET Core middleware.
- `Bookstore.Domain`: Check for any use of Windows registry, file path separators, or platform-specific types.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic unit tests for the domain and data layers to verify expected behavior after migration.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following:

- Application startup with no exceptions
- Database connectivity (if applicable)
- Core user-facing pages and features load correctly
- Any authentication or authorization flows behave as expected

---

## 7. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) are correctly configured. Pay particular attention to:

- Connection strings
- Logging configuration
- Any settings that were previously stored in `Web.config` or `App.config`, which should now be represented in the JSON-based configuration system

---

## 8. Validate Data Layer

If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or outdated, generate a new migration and apply it to the database:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.