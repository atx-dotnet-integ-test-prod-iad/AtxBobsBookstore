# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects (`Bookstore.Data`, `Bookstore.Web`, or `Bookstore.Domain`). The solution compiled cleanly across all projects.

## Validation

### 1. Verify Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net6.0`, `net7.0`, or `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Do this for:
- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

### 2. Restore and Build the Solution

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build
```

Ensure there are no warnings that could indicate deprecated APIs or compatibility issues.

### 3. Run Unit Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior remain intact:

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced during migration.

### 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Review Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all required configuration entries, such as connection strings and any application-specific settings that may have previously resided in `Web.config` or `App.config`.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

### 6. Run the Web Application Locally

Start the application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the displayed local URL and manually exercise the core functionality, including:
- Browsing and searching for books
- Any authentication or authorization flows
- Data creation, update, and deletion operations

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently on non-Windows platforms. Review the code for any usage of:
- `System.Drawing` (not fully supported cross-platform without additional packages)
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

### 8. Review NuGet Package Compatibility

Run the following to check for any outdated or deprecated packages:

```bash
dotnet list package --outdated
dotnet list package --deprecated
```

Update packages where appropriate, and verify that no packages still target `net4x` exclusively.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application for your target environment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj -c Release -o ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.

### 3. Test the Published Output

Run the published output directly to confirm it behaves the same as the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```