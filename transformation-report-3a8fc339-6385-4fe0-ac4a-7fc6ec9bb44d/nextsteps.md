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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all project references and NuGet packages for anything that is Windows-specific. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- Any use of the Windows registry (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- Any P/Invoke calls targeting Windows-only system libraries

Run the .NET Upgrade Assistant compatibility analyzer if any of these are suspected:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze .
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by behavioral differences in the new runtime or by environment-specific configuration.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correct and accessible from the new environment
- Entity Framework Core (or whichever ORM is in use) migrations are up to date by running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm end-to-end functionality.

---

## 8. Review Configuration Files

Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

Cross-platform .NET does not use `Web.config` for application configuration (though it may still be present for IIS hosting purposes).

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.