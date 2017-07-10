# Proxygen
Proxygen is a simple proxy management wrapper around the Linode-CLI to mass manage simple squid proxy servers.

squid: http://www.squid-cache.org/

Linode: https://www.linode.com/

Linode-CLI: https://github.com/linode/cli

## Installation

### Ubuntu

1. Clone the repository
```bash
git@github.com:vanctran/proxygen.git
```

2. Give executable permissions
```bash
chmod u+x setup.sh
```

3. Run the setup
```bash
sudo ./setup.sh
```

## Changelog

### Version 1.1
Added the delete proxygen servers command.
Added the export IP/port list command.

### Version 1.0
Allows creation of proxy servers through Linode.
