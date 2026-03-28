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

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, even if they do not prevent a successful build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review each project for any remaining dependencies or API calls that are Windows-specific, such as:

- `System.Web` references
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)
- Any P/Invoke calls targeting Windows-only libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code paths.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is correctly configured.
- If migrating from Entity Framework 6, verify that EF Core equivalents are in place for any EF6-specific APIs that were removed.
- Run any pending database migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally to confirm it starts without errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application's primary workflows to verify that pages render correctly and data operations function as expected.
- Check that middleware configuration in `Program.cs` or `Startup.cs` is consistent with ASP.NET Core conventions.

---

## 8. Review Configuration Files

- Confirm that `appsettings.json` contains all necessary configuration values that may have previously resided in `Web.config` or `App.config`.
- Verify that connection strings, logging settings, and any environment-specific configuration are correctly structured for the .NET configuration system.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no hidden platform-specific dependencies:

```bash
dotnet run --project Bookstore.Web
```

Observe any runtime exceptions that did not surface during the Windows build and address them accordingly.