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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the code and project files for any remaining Windows-specific dependencies, such as:

- `Microsoft.Win32` namespace usage
- Windows registry access
- COM interop
- `System.Web` references (which are not available in .NET Core and later)

If `System.Web` types were used in `Bookstore.Web`, confirm they have been replaced with their `Microsoft.AspNetCore` equivalents.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related behavioral changes or pre-existing issues.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality such as browsing, searching, and any data-driven features.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Database connectivity**: Confirm that the connection string in `appsettings.json` is correct and that `Bookstore.Data` can connect to the database.
- **Entity Framework migrations**: If Entity Framework Core is used, verify that migrations are up to date.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- **Static files**: Confirm that CSS, JavaScript, and image assets are being served correctly.
- **Authentication/Authorization**: If the application uses authentication, verify that login and access control work as expected.

---

## 7. Review Configuration Files

Compare the old `Web.config` or `App.config` files (if they existed) with the new `appsettings.json` to ensure all configuration values such as connection strings, application settings, and logging configuration have been correctly migrated.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required files are present before deploying to the target environment.