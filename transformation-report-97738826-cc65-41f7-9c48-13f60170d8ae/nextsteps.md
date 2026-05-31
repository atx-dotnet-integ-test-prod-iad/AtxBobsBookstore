# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` files accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1`, update it to a current supported target.

---

## 4. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were Windows-specific in the original project. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore` equivalents)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage (not available in ASP.NET Core)

Use the following command to search for potentially problematic namespaces:

```bash
grep -rn "System.Web" ./app
grep -rn "Microsoft.Win32" ./app
```

---

## 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- The connection string in `appsettings.json` is valid and accessible from the current environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the EF tools are not installed, install them first:

```bash
dotnet tool install --global dotnet-ef
```

---

## 6. Run the Application Locally

Start the web application to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify that core functionality works as expected, including:

- Page rendering
- Database read and write operations
- Authentication and authorization, if applicable

---

## 7. Review `appsettings.json` and Configuration

Confirm that all configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 8. Run Existing Tests

If the solution contains test projects, run them to validate that behavior has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 9. Manual Functional Testing

Perform manual testing of the key workflows in the Bookstore application, such as:

- Browsing and searching for books
- Adding, editing, and deleting records
- User login and role-based access, if applicable

Document any runtime errors or behavioral differences compared to the original application.

---

## 10. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Copy the contents of the `./publish` directory to the target server and configure the web server (IIS, Nginx, or Apache) to serve the application.