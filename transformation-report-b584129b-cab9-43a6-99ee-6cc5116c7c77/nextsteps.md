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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework), verify the following:

- **Migrations**: If using Entity Framework Core, confirm that existing migrations are compatible. Run the following to check the current migration state:

  ```bash
  dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
  ```

- **Database Update**: Apply migrations to a development database to confirm schema compatibility:

  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```

- **Connection Strings**: Confirm that connection strings in `appsettings.json` are correctly configured for the target environment, as the configuration system may differ from the legacy `Web.config` or `App.config` approach.

---

## 5. Validate the Web Layer

Run the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes resolve correctly.
- Static files (CSS, JS, images) are served as expected.
- Authentication and authorization flows work if applicable.
- Any middleware previously configured in `Global.asax` or `Startup.cs` (legacy OWIN) has been correctly migrated to the ASP.NET Core middleware pipeline.

---

## 6. Review Configuration Files

Compare the new `appsettings.json` against the legacy `Web.config` or `App.config` to ensure all application settings, connection strings, and environment-specific values have been carried over. Pay particular attention to:

- Logging configuration
- Custom application settings
- Any third-party library configuration sections

---

## 7. Test on Target Operating Systems

Since the goal of the migration is cross-platform support, run the application on each intended target OS (e.g., Linux, macOS) to surface any platform-specific issues such as:

- File path casing sensitivity
- Platform-specific API usage that may have been retained from the legacy codebase
- Differences in default encoding or culture settings

---

## 8. Publish the Application

Once validation is complete, publish the application for the target runtime:

```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false --output ./publish
```

Adjust the `--runtime` flag to match your deployment target (e.g., `win-x64`, `osx-x64`). Review the contents of the output directory to confirm all required files are present.