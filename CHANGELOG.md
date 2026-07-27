# Change Log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com), and this project adheres to [Semantic Versioning](https://semver.org).

## [4.1.1] - 20-03-2026

### Changed
- Fixed LookupKeys do not resolve correctly in `subPermissions.ps1`

## [4.1.0] - 26-02-2026

### Added
- Account `UpdateResource` example in `resources.ps1` script

## [4.0.0] - 19-02-2026

### Added
- Account reference to audit logs in disable, delete and revoke scripts for reconciliation
- NotFound processAction for subPermission script

### Changed
- Commented example code in the Import script
- DisplayName now starts with capital letter
- Code formatting in files
- Changed comment with aRef to accountReference
- Renamed action to processAction
- Changed batchsize calculation in Import script

### Removed
- Forum link in the README.md
- Issue template from .github folder

## [3.3.0] - 09-01-2026

### Added
- Additional log message during correlation
- HTTP method to endpoint table in the readme
- Missing break statement
- Import script for subPermissions
- AuditLog message in noChanges action in the update

### Changed
- Change icon URL in the readme
- Typo's in the readme
- SubPermission logging to be more generic

# Removed
- Double [Error:] in error handling
- Permisison displayName in dryRun

## [3.2.0] - 10-11-2025

### Added
- Added extra tools in the connector readme to avalaible features table for remarks.
- Added a placeholder icon url to connector readme.
- Added a template script for subPermissions.

### Changed
- Move account processing in import script to paging loop.
- Update global Readme to include semantic versioning explanation.
- Update global Readme to correctly state the latest information about governance and what that implies for the connector.
- Change $importedAccount[$field] to $importedAccount.$field in import script.
- Check on username in import script is more strict.
- Change all auditLog variables to auditLogMessage to be consistent across all scripts.
- Fixed a bug in reconciliation logic in delete, disable and revoke.
- Fixed a bug in create where it defaults to the throw in the if statement that determines the action.
- Renamed prerequisites to requirements in the connector readme.

# Removed
- remove auditLog from no changes in the update script.


## [3.1.0] - 02-06-2025

### Added

- Import template for account entitlements.
- Import template for group entitlements.
- Added code flow for reconciliation resolutions based on `$actionContext.Origin`.

## [3.0.0] - 24-04-2025

### Added
- Introduced release workflows and issue templates in the `.github` directory. Publishing this folder triggers **two** GitHub Actions that will _automatically_ create a new release upon PR completion.
- Added an `AddRange` method to the `customList` class in `debugStart.ps1`, enabling the addition of multiple `auditLogs` to `$outputContext` during debugging sessions.
- Introduced an `email` property to `fieldMapping.json`, which defaults to `MicrosoftActiveDirectory.mail`.
- Included an example for `AccountReference` in the README.
- Implemented a **MultipleFound** validation for `$correlatedAccount` in `create.ps1`.

### Changed
- Updated the message shown when an account cannot be located.
- Revised the features table in the README for improved clarity on the connector's capabilities.
- Adjusted the default value of `retrievedPermission` in the permission script to better align with HelloID behavior.
- Updated auditLogs in the grant and revoke scripts to use `$actionContext.PermissionDisplayName`.

### Removed
- Removed the `displayName` field from the permission reference in the permission script.

## [2.0.1] - 27-10-2024

### Changed

- Updated the correlation values in the _create_ script.

## [2.0.0] - 25-07-2024

### Added
 - Added a default ActionContext.json to use in the DebugStart script. This provides test data for local debugging and can be directly extracted from HelloID, ensuring consistent object handling locally and in HelloID

### Changed
 - Moved the processing DryRun block one level closer to the actual web call. To skip only the web call in the target system in preview mode. To remove the difference between a preview run and actual enforcement. And test more connector code in Preview mode.
 - Changed the debugStart to use ActionContext.json instead of Powershell Object.
 - Some textual improvements.
 - Moved explicit DryRun messages for preview mode, to the `else` condition after the (-not dryrun block).

### Removed
- Removed the Invoke-<connectorName>RestMethod from the template.
- Removed Person.DisplayName from logging.
- Removed Start EndDate from FieldMapping.

## [1.2.0] - 18-04-2024

### Added

- Created new subfolders:
  - permissions/groups
  - resources/groups

### Changed

- Renamed the header in file `grantPermission.ps1` from 'Grant' to  'GrantPermission-Group' to match the file name and folder change.
- Renamed the header in file `revokePermission.ps1` from 'Revoke' to  'RevokePermission-Group' to match the file name and folder change.
- Renamed the header in file `permissions.ps1` from 'Permissions' to  'Permissions-Group' to match the file name and folder change.
- Renamed the header in file `resources.ps1` from 'Resources' to  'Resources-Group' to match the file name and folder change.

- Moved the following files to the _permissions/groups_ folder:
  - grantPermission.ps1
  - revokePermission.ps1
  - permissions.ps1

- Moved the following file to the _resources/groups_ folder:
  - resources.ps1

- Converted the properties of both `$correlatedAccount` and `$desiredAccount` in the `update.ps1` lifecycle action to arrays _@()_ for consistent handling.

- Changed logic and flow in both `grantPermission.ps1` and `revokePermission.ps1` lifecycle actions.
  - Modified the condition to check if `$correlatedAccount` is not null before determining the action _GrantPermission_ or _NotFound_ and constructing the corresponding message.
  - Added `switch` statement to handle the different actions.
  - Adjusted the log message inside the `$actionContext.DryRun -eq $true` block to use the constructed `$dryRunMessage`.
  - Adjusted the dryRun information message to display `$actionContext.References.Permission.DisplayName` instead of `$actionContext.References.Permission.Reference`.
  - Adjusted the information message inside the `if (-not($actionContext.DryRun -eq $true))` block to display both the `$actionContext.References.Permission.DisplayName` and `$actionContext.References.Permission.Reference`.
  - Renamed 'entitlement' to 'permission' to be consistent in all informational and audit messages.

### Removed

- Removed line `Write-Information 'Adding body to request'` from the `Invoke-{connectorName}RestMethod` function in each of the __*ps1*__ files.

## [1.1.0] - 22-03-2024

### Added
- Added start and end date in the field mapping as complex mapping
- Added vscode AuditLogs integration in DebugStart
- Added Quick start

### Changed
- Replaced Write-Verbose with Write-Information
- Fixed Empty $action variable in the create script
- Added Links to configuration and field mapping in the README
- Other small textual changes

## [1.0.1] - 22-02-2024

### Added

### Changed
- Commented out the PreviousData assignment, which causes an error in HelloId Preview
- Changed Outdated `$p.` reference to `$personContext`

### Removed
 - Removed incorrect compare condition.

## [1.0.0] - 05-02-2024

### Added

- Added: _resource_ script.
- Added: default value for _accountReference_ to `create` lifecycle action.
- Added: 'ToDo' in all lifecycle actions indicating that each 'POST, PUT or PATCH' call must be tested using diacritical characters.
- Added: _fieldMapping.json_.

### Changed

- In case of an error, changed `Write-Verbose` to `Write-Warning`.
- Updated correlation configuration so that the account will always be created if the correlation configuration is not enabled.
- Improved error handling function.

### Removed

- Removed: `IsDebug` switch from configuration.
- Removed: `auditlog.Action` in situations where its does not reflect the value from the enum.

## [0.0.2] - 13-01-2024

### Added

- Added: _delete_ lifecycle action.
- Added: `$outputContext.AccountCorrelated = $true` to _create_ lifecycle action.

### Changed

### Deprecated

### Removed

## [0.0.1] - 10-12-2023

Initial alpha release.

### Added

- The following life cycle actions have been added:
  - create
  - update
  - enable
  - disable
  - grant
  - revoke
  - permissions

All actions are primarily based on the _V1_ target connector. For the most part, the same logic is being used.

### Changed

### Deprecated

### Removed
