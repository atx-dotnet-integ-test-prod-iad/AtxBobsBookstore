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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to ensure you are targeting a version that is currently supported.

---

## 4. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and manually verify the following:

- Pages load without errors
- Data is retrieved and displayed correctly from `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves as expected

---

## 5. Check Database Connectivity

If the application uses Entity Framework Core or another data access layer, verify the database connection string in your configuration file (e.g., `appsettings.json`) is correct for your target environment.

If migrations are involved, apply them with:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 6. Execute Automated Tests

If the solution contains test projects, run them to validate correctness:

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests covering data access and domain logic, as these layers are most likely to be affected by a framework migration.

---

## 7. Verify Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm:

- Middleware is registered in the correct order
- Services are registered in the dependency injection container
- Configuration providers (e.g., `appsettings.json`, environment variables) are set up correctly

Legacy patterns such as `HttpContext.Current` or `System.Web` references are not available in modern .NET and must be replaced with their ASP.NET Core equivalents.

---

## 8. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to your target environment.