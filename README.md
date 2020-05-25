# ZSH Secrets

A tiny plugin to store GPG-encrypted environment variables (or other just shell scripts).

## Quickstart

Given, [Oh My ZSH](https://github.com/ohmyzsh/ohmyzsh) is installed, 
`ZSH_CUSTOM` is set and you know how to use GPG.

```sh
$ git clone https://github.com/chuwy/zsh-secrets.git $ZSH_CUSTOM/plugins/zsh-secrets
```

Then add `zsh-secrets` to your `plugins` section:

```sh
plugins=(
  ...
  zsh-secrets
)

## Usage

### Configuration

ZSH Secrets provides two configuration options:

1. `RECEPIENT` - an email to use, to encrypt the data
2. `SECRETS_STORAGE` - a place to store encrypted scripts (`$HOME/.zsh` by default)

### Encrypting data

```sh
$ echo "export MY_PASSWORD=qwerty" > supersecret
$ secrets encrypt supersecret
```

This will encrypt the `supersecret` file and place under you `$SECRETS_STORAGE`
path. The original `supersecret` file will be removed.

### Sourcing the data

When you need `$MY_PASSWORD` you can source it into current shell:

```sh
$ secrets source supersecret
```

### Decrypting

If you need to edit your secrets, you can decrypt it into a file.

```sh
$ secrets decrypt supersecret > supersecret
```

Then you can edit and encrypt it again:

```sh
echo "export ANOTHER_SECRET=42" >> supersecret 
$ secrets encrypt supersecret
```
