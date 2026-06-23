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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Verify that the output confirms zero errors and review any warnings that may indicate compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to validate that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results carefully. Any failing tests should be investigated as they may indicate behavioral differences introduced by the framework migration.

### 4. Verify Entity Framework or Data Layer Functionality

Since the solution includes a `Bookstore.Data` project, verify the data layer is functioning correctly:

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target .NET version.
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- Core routes and pages load as expected.
- Any authentication, session, or middleware behavior works correctly.
- Database reads and writes function as intended.

### 6. Review `Bookstore.Web` Configuration

Cross-platform .NET handles configuration differently than .NET Framework. Verify the following in `Bookstore.Web`:

- `appsettings.json` contains the correct connection strings and application settings that were previously in `web.config`.
- Any remaining `web.config` entries that are still relevant (e.g., IIS-specific settings) have been accounted for.
- Middleware registration in `Program.cs` or `Startup.cs` reflects all previously configured HTTP modules and handlers.

### 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET:

- `System.Web` references should no longer be present.
- Any use of the Windows registry, Windows-specific file paths, or COM interop should be identified and addressed if cross-platform support is required.

### 8. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy to your target environment according to your hosting setup (e.g., IIS on Windows, or a Linux host using Kestrel behind a reverse proxy such as Nginx).

For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed on the target server and that the `web.config` generated in the publish output is correctly configured for the in-process or out-of-process hosting model.