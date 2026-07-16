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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to the following areas:

- **`System.Web` dependencies**: This namespace is not available in cross-platform .NET. If any code references `System.Web`, it must be replaced with ASP.NET Core equivalents.
- **`HttpContext`**: Ensure it is accessed via dependency injection rather than `HttpContext.Current`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` if still in use.
- **Entity Framework**: If the project uses Entity Framework 6, consider migrating to Entity Framework Core for full cross-platform support.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior:

```bash
dotnet test
```

Review any failing tests and determine whether they indicate a behavioral regression introduced during the migration.

---

## 6. Validate Application Configuration

Check the following configuration-related items:

- Confirm that `appsettings.json` is present in `Bookstore.Web` and contains the necessary configuration values previously held in `Web.config` or `App.config`.
- Verify that connection strings in `appsettings.json` are correct and accessible from the target environment.
- Ensure that any environment-specific configuration (e.g., `appsettings.Development.json`) is in place.

---

## 7. Run the Application Locally

Start the web application locally to validate end-to-end behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following:

- Application startup without exceptions
- Database connectivity (if applicable)
- Core application workflows such as browsing, searching, and any data entry forms

Review the console output and application logs for runtime exceptions or warnings.

---

## 8. Verify Static Files and Middleware

In ASP.NET Core, static files and middleware must be explicitly configured. Open `Program.cs` or `Startup.cs` in `Bookstore.Web` and confirm the following middleware is present in the correct order:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication(); // if applicable
app.UseAuthorization();  // if applicable
app.MapControllers();    // or app.MapRazorPages(), depending on the project type
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.