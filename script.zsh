_=${1:?Subcommand must be specified}
FILE_NAME=${2:?The secret must be specified}
SECRET_NAME=$FILE_NAME:t
RECEPIENT=${RECEPIENT:?GPG recepient must be specified through RECEPIENT env var}

DEFAULT_SECRETS_STORAGE="$HOME/.secrets"

SECRETS_STORAGE=${SECRETS_STORAGE:-$DEFAULT_SECRETS_STORAGE}
SECRET_FILENAME="$SECRETS_STORAGE/$SECRET_NAME.gpg"

function realpath {
    echo $(cd $(dirname $1); pwd)/$(basename $1);
}

function decrypt_to_out {
    gpg --decrypt $SECRET_FILENAME
}

function _source_secrets {
    {source $file} 3<> ${file::==(decrypt_to_out)}
    export SESSION_SECRETS=true
}

function _decrypt {
    gpg -q --decrypt $SECRET_FILENAME
}

function _encrypt {
    echo "Encrypting $SECRET_NAME as $SECRET_FILENAME"
    local file=$(realpath $FILE_NAME)
    gpg --batch --yes --output $SECRET_FILENAME --encrypt --recipient $RECEPIENT $file
    echo "Removing $file"
    rm $file
}

function _remove_file {
    rm $SECRET_FILENAME
}

case $1 in
    source)
        _source_secrets
        ;;
    decrypt)
        _decrypt
        ;;
    encrypt)
        _encrypt
        ;;
    rm)
        _remove_file
        ;;
    *)
        echo "Unknown subcommand $1. source, decrypt or encrypt must be used"
        ;;
esac

unfunction _decrypt
unfunction _source_secrets
unfunction _remove_file
unfunction decrypt_to_out
unfunction realpath
