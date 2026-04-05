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

Review the output for any warnings related to package version mismatches or deprecated packages. If any packages reference old .NET Framework-specific libraries, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org/).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to the current LTS release.

---

## 4. Verify Database Configuration

Since `Bookstore.Data` is present, confirm that the database connection strings and any Entity Framework Core configuration have been updated correctly.

- Check `appsettings.json` in `Bookstore.Web` for valid connection strings.
- If Entity Framework Core is used, run the following to verify migrations are in order:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify that core functionality works as expected, including:

- Page rendering
- Database read/write operations
- Any authentication or authorization flows

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate runtime behavioral differences between .NET Framework and modern .NET that were not caught at compile time.

---

## 7. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining Windows-specific API calls that may cause issues on Linux or macOS.

```bash
dotnet add package Microsoft.Windows.Compatibility
```

This package can serve as a temporary bridge, but any usage of Windows-only APIs should be reviewed and replaced with cross-platform alternatives where possible.

---

## 8. Review Middleware and Configuration in `Bookstore.Web`

Confirm that the `Program.cs` or `Startup.cs` file follows the modern .NET hosting model. Legacy patterns such as `WebHostBuilder` should be replaced with the minimal hosting model using `WebApplication.CreateBuilder`.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.Run();
```

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is clean and self-contained.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all necessary files are present before deploying to the target environment.