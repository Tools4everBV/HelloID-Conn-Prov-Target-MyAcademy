# HelloID-Conn-Prov-Target-V2Template

## Table of contents

- [HelloID-Conn-Prov-Target-V2Template](#helloid-conn-prov-target-v2template)
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [What's in this repository](#whats-in-this-repository)
  - [How to use this repository](#how-to-use-this-repository)
    - [Using the _ConnectorGenerator_ VSCode extension](#using-the-connectorgenerator-vscode-extension)
      - [Install the extension](#install-the-extension)
      - [Create a new connector](#create-a-new-connector)
        - [From the command palette](#from-the-command-palette)
        - [From the context menu](#from-the-context-menu)
  - [Best practices](#best-practices)
    - [Keep it simple](#keep-it-simple)
    - [Fit-For-Purpose](#fit-for-purpose)
    - [__Test__ and __Production__ mode](#test-and-production-mode)
    - [Logging](#logging)
    - [Do not retrieve all users within a lifecycle action](#do-not-retrieve-all-users-within-a-lifecycle-action)
    - [Always GET the account](#always-get-the-account)
      - [Action logic example](#action-logic-example)
      - [If the managed account does not exist](#if-the-managed-account-does-not-exist)
    - [Updating accounts](#updating-accounts)
  - [Debugging](#debugging)
    - [When performance matters](#when-performance-matters)
      - [Profiler](#profiler)
      - [SpeedScope](#speedscope)
  - [Understanding Semantic Versioning (MAJOR.MINOR.PATCH)](#understanding-semantic-versioning-majorminorpatch)
    - [1. Major Version (`MAJOR`)](#1-major-version-major)
    - [2. Minor Version (`MINOR`)](#2-minor-version-minor)
    - [3. Patch Version (`PATCH`)](#3-patch-version-patch)
    - [(MAJOR.MINOR.PATCH) Summary](#majorminorpatch-summary)
  - [Security and compliance](#security-and-compliance)
  - [Other useful VSCode extensions](#other-useful-vscode-extensions)
  - [Contributing](#contributing)

## Introduction

Hi 👋

If you're looking to create a new target connector for HelloID provisioning and don't know where to start, you're in the right place.

This GitHub repository is the perfect starting point for building out your new connector, with all the essential resources you'll need to get started.

> [!NOTE]
> The templates in this repository are designed for the _V2_ target system. For more information on how to configure a __HelloID__ PowerShell _V2_ target system, please refer to our [documentation](https://docs.helloid.com/en/provisioning/target-systems/powershell-v2-target-systems.html) pages.

We can't wait to see the amazing PowerShell connectors you'll build with these templates.🔨

## What's in this repository

| FileName                                     | Description                                                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------------------ |
| ./.github/ISSUE_TEMPLATE/bugReport.yaml      | YAML template for submitting bug reports                                                   |
| ./.github/ISSUE_TEMPLATE/featureRequest.yaml | YAML template for feature request submissions                                              |
| ./.github/workflows/createRelease.yaml       | GitHub Action to automate release creation                                                 |
| ./.github/workflows/verifyChangelog.yaml     | GitHub Action to verify the changelog structure and if the changelog is included in the PR |
| ./permissions/groups/grantPermission.ps1     | PowerShell _grant_ lifecycle action                                                        |
| ./permissions/groups/revokePermission.ps1    | PowerShell _revoke_ lifecycle action                                                       |
| ./permissions/groups/permissions.ps1         | PowerShell _permissions_ lifecycle action                                                  |
| ./permissions/groups/import.ps1              | PowerShell _importPermission_ lifecycle action                                                       |
| ./resources/groups/resources.ps1             | PowerShell _resources_ lifecycle action                                                    |
| ./test/config.json                           | Prefilled _config.json_ file for easy debugging                                            |
| ./test/actionContext.json                    | Prefilled _actionContext.json_ file for easy debugging                                     |
| ./test/demoPerson.json                       | Prefilled _demoPerson.json_ for easy debugging                                             |
| ./test/debugStart.ps1                        | Default _debugStart.ps1_ for easy debugging                                                |
| .gitignore                                   | `gitignore` excluding the `test` folder when pushing commits to GitHub                     |
| create.ps1                                   | PowerShell _create_ lifecycle action                                                       |
| delete.ps1                                   | PowerShell _delete_ lifecycle action                                                       |
| disable.ps1                                  | PowerShell _disable_ lifecycle action                                                      |
| enable.ps1                                   | PowerShell _enable_ lifecycle action                                                       |
| update.ps1                                   | PowerShell _update_ lifecycle action                                                       |
| import.ps1                                   | PowerShell _import_ lifecycle action                                                       |
| configuration.json                           | Default _configuration.json_                                                               |
| fieldMapping.json                            | Default _fieldMapping.json_                                                                |
| README.md                                    | A prefilled _readme.md_                                                                    |
| CHANGELOG.md                                 | CHANGELOG.md to track changes made to the connector                                        |

## How to use this repository

-  Download _or clone_ the content of this repo.
-  Use the [ConnectorGenerator VSCode extension](#using-the-connectorgenerator-vscode-extension).

> [!NOTE]
> Downloading _or cloning_ the contents of this repo does require some manuel changes to be made __after__ you've downloaded the contents to your computer.
> - Make sure the `{connectorName}` property in all life cycle actions and __README.md__ alligns with the name of the _target_ system.
>
> - Make sure the `{templateVersion}` setting in the __CHANGELOG.md__ alligns with the latest version in the _CHANGELOG.md_ in the root folder of this repository.
>
> - Make sure the `{currentDate}` matches with the date of today. Or, the date on which your connector will be published to the _Tools4ever_ GitHub repository.

### Using the _ConnectorGenerator_ VSCode extension

#### Install the extension

1. Download the extension from: https://github.com/JeroenBL/ConnectorGenerator/releases/latest
2. Make sure to download the __ConnectorGenerator-[version].VSIX__ file.
3. Go to VSCode.
4. Click on the extensions icon or press `ctrl+shift+x` (`cmd+shift+x` on mac).
5. Click on the three dots ... and select `Install from VSIX`.
6. Browse to the folder where the __ConnectorGenerator-[version].VSIX__ file is downloaded.

#### Create a new connector

##### From the command palette

1. Open the command palette by clicking on `View -> Command palette` or press `ctrl+shift+p` (`cmd+shift+p` on mac).
2. Search for `Create new HelloID connector project scaffolding`.
3. Select the connector type `target`.
4. Enter a name for the connector.
5. Browse to the location where you want the files to be created and press `enter`.

##### From the context menu

1. Right click to open the context menu.
2. Click on `ConnectorGenerator -> Create new HelloID connector project scaffolding`.
3. Select the connector type `target`.
4. Enter a name for the connector.
5. Browse to the location where you want the files to be created and press `enter`

> [!IMPORTANT]
> Source connector templates are currently not available.

## Best practices

Best practices not only ensure the quality of your code, but also helps to improve the efficiency and effectiveness of your development processes.
By adhering to these best practices, you will develop a PowerShell connector that is reliable, efficient, and easy to maintain.

### Keep it simple
Write code that is easy to read and maintain. This means:

-  Use clear and concise variable names.
-  Use consistent formatting throughout your scripts.
-  Avoid unnecessary loops and other code constructs that can slow down your script.

### Fit-For-Purpose

We believe in a _Fit for Purpose_ (FFP) approach to development, which means that we only build what is needed and nothing more.

There are several compelling reasons why we encourage __you__ to adopt a _Fit for Purpose_ approach to development:

1. __Greater efficiency and effectiveness__ <br> By focusing only on the features and functions that are necessary for a given implementation, you can create connectors that are highly efficient and effective, without having to deal with unnecessary complexity or overhead.

2. __Increased customer satisfaction__ <br> By tailoring connectors to the specific needs of each customer, you can create solutions that better meet their expectations and requirements. This can lead to increased customer satisfaction and a better overall customer experience.

3. __Lower costs__ <br> By building only what is needed, you can avoid unnecessary development costs and reduce the time and effort required to create a connector.

4. __Improved scalability__ <br> By taking a modular approach to development, you can create connectors that are easily modified or expanded as needed. This can make it easier to scale the connector as the customer's needs change over time.

5. __Reduced risk__ <br> By focusing only on the features and functions that are necessary, you can reduce the risk of introducing bugs or other issues into the connector. This can lead to greater stability and reliability.

### __Test__ and __Production__ mode

The `$actionContext.DryRun` variable is used to distinguish between a provisioning job running in __test__ (commonly referred to as __Preview__ mode), or __production__ mode.

We consider it a good practice, to _only_ use the test mode, to validate an account, generate names and perform contract calculations.

In other words, when running in __test__ mode, you will see what would happen with a _person account_ during an actual enforcement.

### Logging

With provisioning connectors, we typically differentiate between __verbose__ logging, which contains the full error returned by the API, and __audit__ logging, which contains a more user-friendly response.

| Cmdlet / HelloID variable  | Description                                                                                                                                          |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Write-Warning`            | - Use in case of an error.<br> - Include the script line number and code where the error has occurred. <br> - Must contain the complete error record |
| `Write-Information`        | - Debug logging only.                                                                                                                                |
| `$outputContext.AuditLogs` | - Must contain a more __user-friendly__ error message                                                                                                |

>[!TIP]
Don’t use the audit logging for verbose or debugging logging. Only write an audit log if the lifecycle action itself has failed.

### Do not retrieve all users within a lifecycle action

Some APIs do not provide the option to retrieve a single object, but instead only offer an __HTTP.GET__ endpoint that retrieves all objects.

When the target application contains a large number of records, operations like these can take a considerable amount of time and are not well-suited for any of the lifecycle actions. In such cases, it is preferable to use a resource script instead.

### Always GET the account

In all life cycle actions, the initial step is to validate whether the account exists. Depending on the outcome of this validation, the appropriate action will be executed.

Please refer to the code following [action logic code example](#action-logic-example) for an example on how this is implemented in the `create` lifecycle action.

#### Action logic example

```powershell
 # Verify if a user must be either [created and correlated] or just [correlated]
$outputContext.AccountReference = 'Currently not available'
$correlatedAccount = 'The user object from the target system'
if ($correlatedAccount.Count -eq 0) {
    $lifecycleProcess = 'CreateAccount'
} elseif ($correlatedAccount.Count -eq 1) {
    $lifecycleProcess = 'CorrelateAccount'
} elseif ($correlatedAccount.Count -gt 1) {
    throw "Multiple accounts found for person where $correlationField is: [$correlationValue]"
}

# Process
  switch ($lifecycleProcess) {
      'CreateAccount' {
          Write-Information 'Creating and correlating {connectorName} account'

          # Make sure to test with special characters and if needed; add utf8 encoding.
          if (-not($actionContext.DryRun -eq $true)) {
              # Write Create logic here
              # $createdAccount = Invoke-RestMethod @splatParams
              $outputContext.Data = $createdAccount
              $outputContext.AccountReference = ''
          }

          $outputContext.AccountReference = ''
          $outputContext.AccountCorrelated = $true
          $auditLogMessage = "Create account was successful. AccountReference is: [$($outputContext.AccountReference)"
          break
      }

      'CorrelateAccount' {
          Write-Information 'Correlating {connectorName} account'
          $outputContext.AccountReference = ''
          $outputContext.AccountCorrelated = $true
          $auditLogMessage = "Correlated account: [$($correlatedAccount.ExternalId)] on field: [$($correlationField)] with value: [$($correlationValue)]"
          break
      }
  }

  $outputContext.success = $true
  $outputContext.AuditLogs.Add([PSCustomObject]@{
      Action  = $lifecycleProcess
      Message = $auditLogMessage
      IsError = $false
  })
```

#### If the managed account does not exist

On certain occasions, the managed account may inadvertently be removed from the target system, resulting in a failure of the lifecycle action. To ensure that the lifecycle action always continues, it is necessary to validate if the target account is present. Nevertheless, in some scenarios, even if the account cannot be found, the result of the action __will__ be flagged as `success`.

The table below provides an overview of the results when the target account may inadvertently be removed from the target system.

| Lifecycle action | Result  | Description                                                                                                                                                           |
| ---------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Delete           | Success | The target account may inadvertently be removed, however, this is considered a successful outcome by HelloID.                                                         |
| Disable          | Success | The target account may have been inadvertently removed; consequently, it is no longer active. HelloID considers this to be an acceptable outcome.                     |
| Enable           | Fail    | The target account has been deleted; however, this was not the anticipated outcome for HelloID.                                                                       |
| Update           | Fail    | The target account has been deleted; however, this was not the anticipated outcome for HelloID.                                                                       |
| Grant            | Fail    | The target account has been deleted; however, this was not the anticipated outcome for HelloID.                                                                       |
| Revoke           | Success | Due to the account not existing anymore, the right is no longer granted. This is in accordance with the request by HelloID, and therefore it is recorded as a success |

### Updating accounts

When it comes to updating accounts in the target system, we take a careful and methodical approach. One of our key best practices is to always compare the target system account with the HelloID account object before making any updates. This allows us to ensure that we're only updating the necessary fields.

It's worth noting that the underlying data types for the account object in the target system may differ from the account object in HelloID. This can make it challenging to perform an accurate comparison between the two. If the data types are not aligned, it may be necessary to perform additional steps to ensure that the comparison is meaningful and that the appropriate actions are taken.

> [!NOTE]
> It's important to note that the current compare logic only works for flat objects, and not for complex objects that, for example, contain nested arrays. This means that you will need to make adjustments to this logic depending on the specific requirements of the target system.

## Debugging

Debugging is _arguably_ one of the most complex topics in any programming / scripting language.

The templates also comes with a __debugStart.ps1__, __actionContext.json__ and __demoPerson.json__ in the _test_ folder. They allow you to easily debug your scripts. You can _mock_ variables such as the `$personContext`, `$actionContext` and all built-in variables in HelloID you need. By mocking these variables, you can easily test your scripts under a variety of conditions, without having to worry about external dependencies or data sources.

To mock a variable in `debugStart.ps1`, simply specify the value you want to use for that variable in the mock object at the top of the script.

> [!NOTE]
> Note that, most variables are already specified with a default value.

To start debugging your code from VSCode:

1. Select the code in the: `debugStart.ps1` and press: `F8` - _Run selection_ to add the variables to your PowerShell session.
2. Open up a lifecycle action and set a breakpoint somewhere in your code.
3. Press: `F5` or click: `Run -> Start Debugging` to start a new debugging session.

> [!CAUTION]
> Never hardcode sensitive information like usernames, passwords, or API keys directly in your code. Instead, use secure methods for storing and retrieving these credentials.

### When performance matters

#### Profiler

_Profiler_ is a PowerShell module that originated from `Measure-Script`. _Profiler_ can be installed directly from the PSGallery by running: `Install-Module profiler` directly in your PowerShell console.

#### SpeedScope

SpeedScope is a web viewer for performance profiles and can be downloaded from: https://github.com/jlfwong/speedscope/releases

_Profiler_ can generate flame graphs that can be viewed using _SpeedScope_.

## Understanding Semantic Versioning (MAJOR.MINOR.PATCH)
By following `major.minor.patch`, developers communicate clearly **how risky an upgrade is** and what kind of changes users can expect.
Version numbers in GitHub projects (and most software) usually follow **Semantic Versioning (SemVer)**.  
A version looks like this:

### 1. Major Version (`MAJOR`)
- **Format:** `X.0.0`
- **When to increment:**  
  - You make **breaking changes** to the connector API or behavior.  
  - Users may need to **update their scripts or configurations**.  
- **Example in HelloID connector:**
  - The displayName is removed from the permission.Reference resulting in entitlement issues.
  - You change the fieldMapping or configuration because the API requirements change. This is a major change because something needs to be adjusted in HelloID.
  - If there is a change in HelloID which results in an error in the connector.
  - Version change: `1.2.3 → 2.0.0`

### 2. Minor Version (`MINOR`)
- **Format:** `0.X.0`
- **When to increment:**  
  - You add **new features** or actions that are **backwards-compatible**.  
  - Existing configurations still work without changes.  
- **Example in HelloID connector:**  
  - You change an endpoint from /user to /account where the body of the API request stays the same. 
  - You add the import scripts to an existing connector.
  - Version change: `2.0.0 → 2.1.0`

### 3. Patch Version (`PATCH`)
- **Format:** `0.0.X`
- **When to increment:**  
  - You fix **bugs** or make **small improvements** without changing the API.  
- **Example in HelloID connector:**  
  - An API request fails because the auth header was missing.
  - You change the auditLogMessages to keep them consistent between scripts.
  - You correct a spelling mistake.
  - Version change: `2.1.0 → 2.1.1`

### (MAJOR.MINOR.PATCH) Summary
| Type | Example Change | Backward Compatible? | Example Version Change |
|------|----------------|----------------------|------------------------|
| **MAJOR** | Breaking changes | ❌ No | `1.0.0 → 2.0.0` |
| **MINOR** | New features | ✅ Yes | `1.1.0 → 1.2.0` |
| **PATCH** | Bug fixes | ✅ Yes | `1.1.1 → 1.1.2` |

## Security and compliance

- __Avoid Hardcoding Credentials__<br>
Never hardcode sensitive information like usernames, passwords, or API keys directly in your code. Instead, use secure methods for storing and retrieving these credentials.

- __Minimize Exposure__<br>
Implement robust error handling to minimize the exposure of sensitive information in error messages or logs.

- __Peer Reviews__<br>
Conduct thorough code reviews, especially focusing on areas where sensitive information is handled. Multiple sets of eyes can help identify potential security risks.

- __Have a Plan__<br>
Develop an incident response plan in case of a security breach. Be prepared to notify users and take necessary actions promptly.

## Other useful VSCode extensions

There are several useful VSCode extensions that can be helpful when building PowerShell connectors. Here are a few examples:

- __PowerShell__<br>https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell<br>
The PowerShell extension provides a rich set of features for PowerShell development, including syntax highlighting, code snippets, IntelliSense, and more. This extension can be incredibly helpful when building PowerShell connectors, as it provides an efficient and intuitive environment for writing, testing, and debugging PowerShell code.

- __Code Spell Checker__<br>https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker<br>
This extension checks the spelling of words in your code and comments, ensuring that everything is spelled correctly and improving the readability and professionalism of your code.

- __GitHub Markdown Preview__<br>https://marketplace.visualstudio.com/items?itemName=bierner.github-markdown-preview<br>
With GitHub Markdown Preview, you can see exactly how your documentation will look when published to GitHub, ensuring that it is clear, concise, and easy to read. This can be particularly useful when documenting your PowerShell connector code, as it allows you to create professional-looking documentation that is easy to understand and follow.

## Contributing

Please consult our [contributing guidelines](https://github.com/Tools4everBV/HelloID-Conn-Prov-Target-V2-Template/blob/main/CONTRIBUTING.md) for more information.
