// import data
const challengeData =			require("./challenge2.json");

const ENDPOINT =			challengeData["RPC endpoint"];

// setup
const Web3 = require("web3");

// connect
const web3 = new Web3(ENDPOINT);

async function main() {

	try {	

		// get attacker account so I can check my loot
		var ATTACKACCT = await web3.eth.getAccounts();
		ATTACKACCT = ATTACKACCT.toString();
		console.log("ATTACK ACCT:	" + ATTACKACCT);

		// create second attack account
		const AttackDouble = web3.eth.accounts.create();
		console.log(AttackDouble);

		// get second attack account
		const ATTACKDBL = AttackDouble["address"];
		const ATTACKDBLPRIKEY = AttackDouble["privateKey"];

		// split funds with attack double
		const balance = await web3.eth.getBalance(ATTACKACCT);
    		const transferTX = {
			to: ATTACKDBL,
       			from: ATTACKACCT,
			value: Math.floor(balance/2),
		};
		await web3.eth.sendTransaction(transferTX, function(error, hash) {
  			if (!error) {console.log("Transfer TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);

	}
}

main();


