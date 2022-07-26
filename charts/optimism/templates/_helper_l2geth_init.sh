#!/bin/sh
set -exu

echo running "${0}"
if [[ -z $DATADIR ]]; then
    echo "Must pass DATADIR"
    exit 1
fi

GETH_CHAINDATA_DIR=$DATADIR/geth/chaindata
GETH_KEYSTORE_DIR=$DATADIR/keystore
if [ ! -d "$GETH_KEYSTORE_DIR" ]; then
    echo "$GETH_KEYSTORE_DIR missing, running account import"
    echo -n "$BLOCK_SIGNER_PRIVATE_KEY_PASSWORD" > "$DATADIR"/password
    echo -n "$BLOCK_SIGNER_PRIVATE_KEY" > "$DATADIR"/block-signer-key
    geth account import \
        --datadir="$DATADIR" \
        --password="$DATADIR"/password \
        "$DATADIR"/block-signer-key
    echo "get account import complete"
fi
if [ ! -d "$GETH_CHAINDATA_DIR" ]; then
    echo "$GETH_CHAINDATA_DIR missing, running init"
    geth init --datadir="$DATADIR" "$L2GETH_GENESIS_URL" "$L2GETH_GENESIS_HASH"
    echo "geth init complete"
else
    echo "$GETH_CHAINDATA_DIR exists, checking for hardfork."
    echo "Chain config:"
    geth dump-chain-cfg --datadir="$DATADIR"
    if geth dump-chain-cfg --datadir="$DATADIR" | grep -q "\"berlinBlock\": $L2GETH_BERLIN_ACTIVATION_HEIGHT"; then
        echo "Hardfork already activated."
    else
        echo "Hardfork not activated, running init."
        geth init --datadir="$DATADIR" "$L2GETH_GENESIS_URL" "$L2GETH_GENESIS_HASH"
        echo "geth hardfork activation complete"
    fi
fi
