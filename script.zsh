_=${1:?Subcommand must be specified}
SECRET_NAME=${2:?The secret must be specified}
RECEPIENT=${RECEPIENT:?GPG recepient must be specified through RECEPIENT env var}

DEFAULT_SECRETS_STORAGE="$HOME/.secrets"

SECRETS_STORAGE=${SECRETS_STORAGE:-$DEFAULT_SECRETS_STORAGE}
SECRET_FILENAME="$SECRETS_STORAGE/$SECRET_NAME.gpg"

function decrypt_to_out {
    gpg --decrypt $SECRET_FILENAME
}

function source_secrets {
    {source $file} 3<> ${file::==(decrypt_to_out)}
    export SESSION_SECRETS=true
}

function decrypt {
    gpg -q --decrypt $SECRET_FILENAME
}

function encrypt {
    echo "Encrypting $SECRET_NAME as $SECRET_FILENAME"
    gpg --batch --yes --output $SECRET_FILENAME --encrypt --recipient $RECEPIENT $SECRET_NAME
    echo "Removing $SECRET_NAME"
    rm $SECRET_NAME
}

case $1 in
    source)
        source_secrets
        ;;
    decrypt)
        decrypt
        ;;
    encrypt)
        encrypt
        ;;
    *)
        echo "Unknown subcommand $1. source, decrypt or encrypt must be used"
        ;;
esac

unfunction decrypt
unfunction source_secrets
unfunction decrypt_to_out
