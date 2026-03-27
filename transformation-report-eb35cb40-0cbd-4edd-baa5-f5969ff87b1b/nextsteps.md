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

Run a NuGet restore to confirm all packages resolve correctly against the new target framework:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages. If any packages target `net4x` exclusively, locate replacements on [NuGet.org](https://www.nuget.org) that support `netstandard2.0` or `net6.0`/`net8.0`.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- Any `<system.web>` or `<system.webServer>` configuration entries have been migrated to the appropriate middleware or configuration in `Program.cs` / `Startup.cs`.
- Environment-specific configuration files (e.g., `appsettings.Development.json`) are in place.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` handles data access, confirm the following:

- If Entity Framework is used, verify the version. EF Core behaves differently from EF6. Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` points to the correct database instance.
- Check that any raw SQL queries or stored procedure calls are compatible with EF Core syntax.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test
```

If no test projects exist, consider writing basic integration tests that cover:
- Database connectivity from `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Key HTTP endpoints in `Bookstore.Web`

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Check the following at runtime:
- Application starts without exceptions in the console output.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.

---

## 7. Check for Windows-Specific API Usage

Even with a successful build, some APIs may only fail at runtime on non-Windows platforms. Search the codebase for usage of:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (use `Path.Combine` consistently)
- `HttpContext.Current` (not available in ASP.NET Core; use dependency-injected `IHttpContextAccessor`)

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all static assets, configuration files, and binaries are present before deploying to the target environment.