# Remote Server Cert Import

This action will install a certificate on a remote windows server.

## Index <!-- omit in toc -->

- [Inputs](#inputs)
- [Examples](#examples)
  - [Simple](#simple)
  - [Password Protected](#password-protected)
- [Contributing](#contributing)
  - [Incrementing the Version](#incrementing-the-version)
- [Code of Conduct](#code-of-conduct)
- [License](#license)

## Inputs

| Parameter              | Is Required | Description                                                                                                         |
| ---------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------- |
| `remote-server`        | true        | The fully qualified domain name or IP address of the remote server, for example "aserver.domain.com" or "127.0.0.1" |
| `remote-user-name`     | true        | The service account user name with permissions to install the certificate                                           |
| `remote-user-password` | true        | The service account user password with permissions to install the certificate                                       |
| `cert-path`            | true        | Import cert path, for example "./certs/cert.pfx"                                                                    |
| `cert-store`           | true        | Cert store import location, for example "Cert:\LocalMachine\My"                                                     |
| `cert-password`        | false       | The key value to use if the cert is locked                                                                          |
| `is-pfx-cert`          | false       | Specifies if a cert is contains a private key, expects true or false, if true, cert-password must be specified      |


## Examples

### Simple

```yml
jobs:
  import-cert-on-runner:
    runs-on: [windows-2019]
    steps:
      - uses: actions/checkout@v2

      - name: Import Runner Cert
        uses: im-open/remote-server-cert-importt@v1.0.0
        with:
          remote-server: 'remote-server.my-domain.com'
          remote-user-name: 'cert-admin'
          remote-user-password: '${{ secrets.remote-user-password }}'
          cert-path: './certs/cert.cer'
          cert-store: 'Cert:\LocalMachine\My'
```

### Password Protected

```yml
jobs:
  import-cert-on-runner:
    runs-on: [windows-2019]
    steps:
      - uses: actions/checkout@v2

      - name: Import Runner Cert
        uses: im-open/remote-server-cert-import@v1.0.0
        with:
          remote-server: 'remote-server.my-domain.com'
          remote-user-name: 'cert-admin'
          remote-user-password: '${{ secrets.remote-user-password }}'
          cert-path: './certs/cert.pfx'
          cert-store: 'Cert:\LocalMachine\Root'
          cert-password: '${{ secrets.cert_password }}'
          is-pfx-cert: true
```

## Contributing

When creating new PRs please ensure:
1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
2. The `README.md` example has been updated with the new version.  See [Incrementing the Version](#incrementing-the-version).
3. The action code does not contain sensitive information.

### Incrementing the Version

This action uses [git-version-lite] to examine commit messages to determine whether to perform a major, minor or patch increment on merge.  The following table provides the fragment that should be included in a commit message to active different increment strategies.
| Increment Type | Commit Message Fragment                     |
| -------------- | ------------------------------------------- |
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).

[git-version-lite]: https://github.com/im-open/git-version-lite