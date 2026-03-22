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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Ensure any settings previously stored in `Web.config` or `App.config` have been migrated to the appropriate `appsettings.json` sections or environment variables.

### 3.2 Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify the database context and migrations are functional:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run the Application Locally

Start the web application and confirm it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any unhandled exceptions or warnings.

---

## 5. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether they indicate a real regression or a test that requires updating due to API changes in the new target framework.

---

## 6. Review Platform-Specific Code

Search the solution for any code that may have been valid under .NET Framework but is not fully supported under cross-platform .NET:

- **Windows Registry access** (`Microsoft.Win32.Registry`)
- **`System.Web` references** — these are not available in cross-platform .NET and should have been replaced during transformation
- **`HttpContext.Current`** — replace with injected `IHttpContextAccessor`
- **`Thread.CurrentThread.CurrentCulture`** changes — prefer `CultureInfo` with explicit scoping

Run the following to check for any remaining `System.Web` references:

```bash
grep -r "System.Web" --include="*.cs" .
```

---

## 7. Validate Publish Output

Publish the application to confirm the output is complete and self-contained:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required assets, static files, and configuration files are present.

---

## 8. Smoke Test the Published Output

Run the published output directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Verify the application starts and responds to requests as expected before moving it to any target environment.