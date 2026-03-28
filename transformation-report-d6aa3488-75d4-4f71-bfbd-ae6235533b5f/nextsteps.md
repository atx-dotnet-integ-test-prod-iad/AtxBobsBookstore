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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows Authentication configurations in `Bookstore.Web`
- Any P/Invoke calls or `[DllImport]` attributes referencing Windows DLLs
- File path separators hardcoded as `\` instead of using `Path.Combine` or `Path.DirectorySeparatorChar`

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider (e.g., Entity Framework Core) is correctly configured for cross-platform use.
- Connection strings in `appsettings.json` do not rely on Windows-specific formats or integrated security settings that are unavailable on Linux/macOS.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output and manually verify core functionality such as browsing, searching, and any data-driven pages.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to confirm existing behavior is preserved.

```bash
dotnet test
```

Review any failing tests. Failures may indicate runtime behavioral differences between .NET Framework and modern .NET that were not caught at compile time.

---

## 8. Review Middleware and Configuration in Bookstore.Web

If the project was migrated from an ASP.NET (System.Web) application, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core. Key areas to verify:

- Authentication and authorization middleware order
- Static file serving
- Session and cookie configuration
- Any HTTP module or HTTP handler logic that needed to be rewritten as middleware

---

## 9. Validate on a Non-Windows Environment (Optional but Recommended)

If cross-platform support is a goal, run the application on Linux or macOS to surface any remaining platform-specific issues that would not appear on Windows.

```bash
dotnet run --project Bookstore.Web
```

---

## 10. Review Published Output

Publish the application and inspect the output to ensure all required files are present.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify that the `./publish` directory contains the expected binaries, static assets, and configuration files.