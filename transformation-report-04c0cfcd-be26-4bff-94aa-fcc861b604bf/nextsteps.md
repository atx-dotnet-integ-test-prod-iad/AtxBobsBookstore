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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors. Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or `netstandard2.0`, evaluate whether it needs to be updated to a current .NET target.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs that are Windows-only and will not function on Linux or macOS. Common examples include:

- `Microsoft.Win32` registry access
- `System.Drawing` (GDI+)
- Windows Communication Foundation (WCF) server-side components
- `HttpContext.Current` from `System.Web`

If any are found, replace them with cross-platform alternatives or annotate them with `[SupportedOSPlatform("windows")]` if cross-platform support is not required.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is correctly referenced.
- Run any pending Entity Framework Core migrations or verify the schema is up to date.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the console output and exercise the primary workflows, such as browsing, searching, and any data entry forms.

---

## 7. Execute Automated Tests

If a test project exists in the solution, run all tests to confirm existing behavior is preserved.

```bash
dotnet test --configuration Release
```

Review the results for any failures that may have been introduced during the migration. Pay particular attention to tests that cover the domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

---

## 8. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings, replacing any values that were previously stored in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`) are in place.
- Ensure secrets such as connection strings are not committed to source control. Use `dotnet user-secrets` for local development.

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application starts correctly from the published output before deploying to the target environment.