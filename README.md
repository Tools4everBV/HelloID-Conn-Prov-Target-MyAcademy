# HelloID-Conn-Prov-Target-MyAcademy

<!--
** for extra information about alert syntax please refer to [Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts)
-->

> [!IMPORTANT]
> This repository contains the connector and configuration code only. The implementer is responsible to acquire the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements.

<p align="center">
  <img src="">
</p>

## Table of contents

- [HelloID-Conn-Prov-Target-MyAcademy](#helloid-conn-prov-target-connectorname)
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Supported features](#supported-features)
  - [Getting started](#getting-started)
    - [HelloID Icon URL](#helloid-icon-url)
    - [Requirements](#requirements)
    - [Connection settings](#connection-settings)
    - [Correlation configuration](#correlation-configuration)
    - [Field mapping](#field-mapping)
    - [Account Reference](#account-reference)
  - [Remarks](#remarks)
  - [Development resources](#development-resources)
    - [API endpoints](#api-endpoints)
  - [Getting help](#getting-help)
  - [HelloID docs](#helloid-docs)

## Introduction

_HelloID-Conn-Prov-Target-MyAcademy_ is a _target_ connector. _MyAcademy_ provides a set of REST APIs that allow you to programmatically interact with its data. Bascally a csv file is being posted as body of the request.

## Supported features

The following features are available:

| Feature                                   | Supported | Actions                                 | Remarks           |
| ----------------------------------------- | --------- | --------------------------------------- | ----------------- |
| **Account Lifecycle**                     | ✅         | Create, Update, Enable, Disable        |                   |
| **Permissions**                           | ❌         | -                                       |                  |
| **Resources**                             | ❌         | -                                       |                   |
| **Entitlement Import: Accounts**          | ❌         | -                                       |                   |
| **Entitlement Import: Permissions**       | ❌         | -                                       |                   |
| **Governance Reconciliation Resolutions** | ❌         | -                                       |                   |

<!-- 
Example
### ⚠️ Governance Reconciliation Resolutions
Governance reconciliation is supported for reporting purposes.
Resolutions are not possible because... 
-->

## Getting started

### HelloID Icon URL
URL of the icon used for the HelloID Provisioning target system.
```
https://raw.githubusercontent.com/Tools4everBV/HelloID-Conn-Prov-Target-MyAcademy/refs/heads/main/Icon.png
```

### Requirements


- **Authorization key**:<br>
  A valid authorization key must be available in order to connect to the API


### Connection settings

The following settings are required to connect to the API.

| Setting           | Description                               | Mandatory |
| ----------------- | ----------------------------------------- | --------- |
| BaseUrl           | The URL to the API                        | Yes       |
| AuthorizationKey  | The authoriazation key to connect the api | Yes       |

### Correlation configuration

Correlation is not supported for this connector as it isn't possible te retrieve existing accounts. The field UserID is the unique value of a user. If it doesn't exist, it will be created, otherwise it will be updated.

> [!TIP]
> _For more information on correlation, please refer to our correlation [documentation](https://docs.helloid.com/en/provisioning/target-systems/powershell-v2-target-systems/correlation.html) pages_.

### Field mapping

The field mapping can be imported by using the _fieldMapping.json_ file.

### Account Reference

The account reference is populated with the property `UserID` property from _MyAcademy_

## Remarks

### GET Account API Limitation
- **No GET Endpoint**: The API does not support a GET request to retrieve account details. If the provided UsersId does not exist, a new user will be created.

### Levels
- If Level1Code, Level2Code or Level3Code don't exist, a new level will be created. Otherwise, if the name differs, the name will be updated.

### Clearing fields
- The '*NONE*' value is used for clearing fields. An empty value will not update the current value of the field.

## Development resources

### API endpoints

The following endpoints are used by the connector

| Endpoint | HTTP Method      | Description                                  |
| -------- | ---------------- | -------------------------------------------- |
| /contentHandler/usersCsv   | POST | Create and update user information |

## Getting help

> [!TIP]
> _For more information on how to configure a HelloID PowerShell connector, please refer to our [documentation](https://docs.helloid.com/en/provisioning/target-systems/powershell-v2-target-systems.html) pages_.

## HelloID docs

The official HelloID documentation can be found at: https://docs.helloid.com/
