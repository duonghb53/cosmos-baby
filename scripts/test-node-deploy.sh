#!/bin/bash

KEY="test"
CHAINID="baby-1"
KEYRING="test"
MONIKER="localtestnet"
KEYALGO="secp256k1"
LOGLEVEL="info"

# retrieve all args
WILL_RECOVER=0
WILL_INSTALL=0
WILL_CONTINUE=0
# $# is to check number of arguments
if [ $# -gt 0 ];
then
    # $@ is for getting list of arguments
    for arg in "$@"; do
        case $arg in
        --recover)
            WILL_RECOVER=1
            shift
            ;;
        --install)
            WILL_INSTALL=1
            shift
            ;;
        --continue)
            WILL_CONTINUE=1
            shift
            ;;
        *)
            printf >&2 "wrong argument somewhere"; exit 1;
            ;;
        esac
    done
fi

# continue running if everything is configured
if [ $WILL_CONTINUE -eq 1 ];
then
    # Start the node (remove the --pruning=nothing flag if historical queries are not needed)
    ~/go/bin/lesson_1d start --pruning=nothing --log_level $LOGLEVEL --minimum-gas-prices=0.0001ubaby --p2p.laddr tcp://0.0.0.0:2280 --grpc.address 0.0.0.0:2282 --grpc-web.address 0.0.0.0:2283
    exit 1;
fi

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }
command -v toml > /dev/null 2>&1 || { echo >&2 "toml not installed. More info: https://github.com/mrijken/toml-cli"; exit 1; }

# install ~/go/bin/lesson_1d if not exist
if [ $WILL_INSTALL -eq 0 ];
then 
    command -v ~/go/bin/lesson_1d > /dev/null 2>&1 || { echo >&1 "installing ~/go/bin/lesson_1d"; make install; }
else
    echo >&1 "installing ~/go/bin/lesson_1d"
    rm -rf $HOME/.lesson_1d*
    rm client/.env
    rm scripts/mnemonic.txt
    make install
fi

~/go/bin/lesson_1d config keyring-backend $KEYRING
~/go/bin/lesson_1d config chain-id $CHAINID

# determine if user wants to recorver or create new
MNEMONIC=""
if [ $WILL_RECOVER -eq 0 ];
then
    MNEMONIC=$(~/go/bin/lesson_1d keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --output json | jq -r '.mnemonic')
else
    MNEMONIC=$(~/go/bin/lesson_1d keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --recover --output json | jq -r '.mnemonic')
fi

echo "MNEMONIC=$MNEMONIC" >> client/.env
echo "MNEMONIC for $(~/go/bin/lesson_1d keys show $KEY -a --keyring-backend $KEYRING) = $MNEMONIC" >> scripts/mnemonic.txt

echo >&1 "\n"

# init chain
~/go/bin/lesson_1d init $MONIKER --chain-id $CHAINID

# Change parameter token denominations to ubaby
cat $HOME/.lesson_1d/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="ubaby"' > $HOME/.lesson_1d/config/tmp_genesis.json && mv $HOME/.lesson_1d/config/tmp_genesis.json $HOME/.lesson_1d/config/genesis.json
cat $HOME/.lesson_1d/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="ubaby"' > $HOME/.lesson_1d/config/tmp_genesis.json && mv $HOME/.lesson_1d/config/tmp_genesis.json $HOME/.lesson_1d/config/genesis.json
cat $HOME/.lesson_1d/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="ubaby"' > $HOME/.lesson_1d/config/tmp_genesis.json && mv $HOME/.lesson_1d/config/tmp_genesis.json $HOME/.lesson_1d/config/genesis.json
cat $HOME/.lesson_1d/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="ubaby"' > $HOME/.lesson_1d/config/tmp_genesis.json && mv $HOME/.lesson_1d/config/tmp_genesis.json $HOME/.lesson_1d/config/genesis.json

# Set gas limit in genesis
# cat $HOME/.lesson_1d/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="10000000"' > $HOME/.lesson_1d/config/tmp_genesis.json && mv $HOME/.lesson_1d/config/tmp_genesis.json $HOME/.lesson_1d/config/genesis.json

# enable rest server and swagger
toml set --toml-path $HOME/.lesson_1d/config/app.toml api.swagger true
toml set --toml-path $HOME/.lesson_1d/config/app.toml api.enable true
toml set --toml-path $HOME/.lesson_1d/config/app.toml api.address tcp://0.0.0.0:1310
toml set --toml-path $HOME/.lesson_1d/config/client.toml node tcp://0.0.0.0:2281

# create more test key
MNEMONIC_1=$(~/go/bin/lesson_1d keys add test1 --keyring-backend $KEYRING --algo $KEYALGO --output json | jq -r '.mnemonic')
TO_ADDRESS=$(~/go/bin/lesson_1d keys show test1 -a --keyring-backend $KEYRING)
echo "MNEMONIC for $TO_ADDRESS = $MNEMONIC_1" >> scripts/mnemonic.txt
echo "TO_ADDRESS=$TO_ADDRESS" >> client/.env

# Allocate genesis accounts (cosmos formatted addresses)
~/go/bin/lesson_1d add-genesis-account $KEY 1000000000000ubaby --keyring-backend $KEYRING
~/go/bin/lesson_1d add-genesis-account test1 1000000000000ubaby --keyring-backend $KEYRING

# Sign genesis transaction
~/go/bin/lesson_1d gentx $KEY 1000000ubaby --keyring-backend $KEYRING --chain-id $CHAINID

# Collect genesis tx
~/go/bin/lesson_1d collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
~/go/bin/lesson_1d validate-genesis

# Start the node (remove the --pruning=nothing flag if historical queries are not needed)
~/go/bin/lesson_1d start --pruning=nothing --log_level $LOGLEVEL --minimum-gas-prices=0.0001ubaby --p2p.laddr tcp://0.0.0.0:2280 --rpc.laddr tcp://0.0.0.0:2281 --grpc.address 0.0.0.0:2282 --grpc-web.address 0.0.0.0:2283