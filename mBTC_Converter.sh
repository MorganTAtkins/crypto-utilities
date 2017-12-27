#!/bin/bash

COIN=$1

blockchain_GBP="$(curl -s https://blockchain.info/ticker| jq '.GBP|.last'||echo '£0')"
blockchain_USD="$(curl -s https://blockchain.info/ticker| jq '.USD|.last'||echo '£0')"

coinbase_GBP="$(curl -s -H 'CB-VERSION: 2015-04-08' https:\/\/api.coinbase.com\/v2\/prices\/BTC-GBP\/spot | jq '.data|.amount' | tr -d '"')" 
coinbase_USD="$(curl -s -H 'CB-VERSION: 2015-04-08' https:\/\/api.coinbase.com\/v2\/prices\/BTC-USD\/spot | jq '.data|.amount' | tr -d '"')" 

while getopts ":m:" opt; do
  case $opt in
    m)
      mCOIN=$(awk -v m=-$OPTARG 'BEGIN { print (m / 1000) }')
      COIN=$(echo $mCOIN | tr -d '-')
	  ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

line='-----------------------'

blockchain_value="$(echo "($COIN * $blockchain_GBP)" | bc -l)"
coinbase_value="$(echo "($COIN * $coinbase_GBP)" | bc -l)"

printf "%s %s %s \n\n" "[Bitcoin]" "${line:8}" $COIN

printf "%s %s %s \n" "[Blockchain]" "${line:11}" $blockchain_value

printf "[BTC:GBP] %s %s \n" "${line:${#blockchain_GBP}}" $blockchain_GBP

printf "[BTC:USD] %s %s \n\n" "${line:${#blockchain_USD}}" $blockchain_USD

printf "%s %s %s \n" "[Coinbase]" "${line:9}" $coinbase_value

printf "[BTC:GBP] %s %s \n" "${line:${#coinbase_GBP}}" $coinbase_GBP

printf "[BTC:USD] %s %s \n" "${line:${#coinbase_USD}}" $coinbase_USD





