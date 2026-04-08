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

- **`Bookstore.Data`**: Verify that Entity Framework usage has been updated to EF Core. Confirm that database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced and configured correctly.
- **`Bookstore.Web`**: Confirm that any previously used `System.Web` APIs have been replaced with their ASP.NET Core equivalents. Check areas such as authentication, session management, HTTP context access, and routing.
- **`Bookstore.Domain`**: Verify that any serialization, configuration, or reflection-based code behaves as expected under cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data layer behavior.

```bash
dotnet test
```

If no test project currently exists, consider writing tests that cover the core domain logic in `Bookstore.Domain` and data access patterns in `Bookstore.Data` before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas:

- Application startup without exceptions
- Database connectivity and data retrieval through `Bookstore.Data`
- Page rendering and navigation in `Bookstore.Web`
- Any authentication or authorization flows

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are properly configured. Legacy projects often stored configuration in `Web.config` or `App.config`, which are not used the same way in cross-platform .NET.

- Connection strings should be present in `appsettings.json` under the `ConnectionStrings` section.
- Any environment-specific values should be managed through environment variables or `appsettings.{Environment}.json` files.

---

## 8. Validate Static Assets and Middleware

If `Bookstore.Web` serves static files (CSS, JavaScript, images), confirm that the following middleware is present in `Program.cs` or `Startup.cs`:

```csharp
app.UseStaticFiles();
```

Also confirm that middleware ordering is correct, particularly for authentication and routing.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all necessary files are present, including configuration files and static assets.