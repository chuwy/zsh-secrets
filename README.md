# ZSH Secrets

A tiny plugin to store [GPG][gpg]-encrypted environment variables (or just plain shell 
scripts).

## Quickstart

Given, [Oh My ZSH][oh-my-zsh] is installed, 
`$ZSH_CUSTOM` is set and you know how to use GPG.

```sh
git clone https://github.com/chuwy/zsh-secrets.git $ZSH_CUSTOM/plugins/zsh-secrets
```

Then add `zsh-secrets` to your `plugins` section:

```sh
plugins=(
  ...
  zsh-secrets
)
```

## Usage

### Configuration

ZSH Secrets provides two configuration options:

1. `RECEPIENT` - an email to use, to encrypt the data
2. `SECRETS_STORAGE` - a place to store encrypted scripts (`$HOME/.secrets` by default)

### Encrypting data

```sh
echo "export MY_PASSWORD=qwerty" > supersecret
secrets encrypt supersecret
```

This will encrypt the `supersecret` file and place under you `$SECRETS_STORAGE`
path. The original `supersecret` file will be removed.

### Sourcing the data

When you need `$MY_PASSWORD` you can source it into current shell:

```sh
secrets source supersecret
```

### Decrypting

If you need to edit your secrets, you can decrypt it into a file.

```sh
secrets decrypt supersecret > supersecret
```

Then you can edit and encrypt it again:

```sh
echo "export ANOTHER_SECRET=42" >> supersecret 
secrets encrypt supersecret
```

### Other

In case of successful secret sourcing, `SESSION_SECRETS` environment variable 
get exported with `true` value. You can reflect the fact that you have an
unencrypted secret in your session via prompt. E.g. with [p10k][p10k] you can 
add:

```shell
function prompt_secrets() {
  if [[ -n "$SESSION_SECRETS" ]]; then
    p10k segment -f 3 -t "🔒"
  fi
}
```

This will show a lock sign on a right handside whenever you have an access to 
some secret.


## Motivation

It's a really bad idea to store credentials in plain text form, your computer 
can be stolen, you can accidentally push them to a public git repository,
you can accidentally show them on a video call etc.

A good solution for this problem is to use password managers and just copy-paste
passwords and credentials when necessary. However it doesn't solve problem of an
unexpected witness and also makes the process cumbersome. What is even worse,
if you paste your password as a plain-text on a shell - it gets stored in your 
shell history file for long time (a lifehack: add a whitespace before command to
not add it to the history file).

This plugin allows you to encrypt your shell script with GPG, as a result:

* secrets never stored as plain text
* no troubles if they got staged to git repository
* you can always refer to secrets as to environment variables
* process of sourcing is fast and secure

## License

ZSH Secrets is copyright 2020 Anton Parkhomenko.

Licensed under the **[Apache License, Version 2.0][license]** (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[gpg]: https://gnupg.org/
[oh-my-zsh]: https://github.com/ohmyzsh/ohmyzsh
[p10k]: https://github.com/romkatv/powerlevel10k
[license]: https://www.apache.org/licenses/LICENSE-2.0
