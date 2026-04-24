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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects in the same solution can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Check any database access code (e.g., Entity Framework). Ensure you are using `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Verify connection strings and database provider packages are configured correctly for the target environment.
- **`Bookstore.Web`**: If the project was previously ASP.NET Web Forms or ASP.NET MVC on .NET Framework, confirm it has been migrated to ASP.NET Core. Web Forms is not supported on cross-platform .NET.
- **`Bookstore.Domain`**: Check for any use of `System.Configuration.ConfigurationManager`. This requires the `System.Configuration.ConfigurationManager` NuGet package on cross-platform .NET, or should be replaced with `Microsoft.Extensions.Configuration`.

---

## 5. Run Unit Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

If no test projects exist, consider manually testing the critical paths of the application, particularly around data retrieval and any domain logic.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm the following:

- The application starts without exceptions.
- Pages or API endpoints load correctly.
- Database connectivity is functioning as expected.
- Any authentication or session handling works correctly, as these subsystems changed significantly between .NET Framework and ASP.NET Core.

---

## 7. Validate Configuration Files

Cross-platform .NET uses `appsettings.json` instead of `Web.config` or `App.config` for most configuration. Confirm that:

- Connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or similar environment-specific files.
- `Web.config` is only present if it is needed for IIS-specific settings (e.g., URL rewrite rules), and it is not being relied upon for application configuration at runtime.

---

## 8. Verify Static Files and Middleware

In ASP.NET Core, static file serving and middleware must be explicitly configured in `Program.cs` or `Startup.cs`. Confirm that the following are present where applicable:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
```

---

## 9. Deploy to Target Environment

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server. Ensure the target server has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value.