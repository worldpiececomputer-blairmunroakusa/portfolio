// import data
const challengeData =			require("./challenge2.json");
const setupABIsetup =			require("./setupABIsetup.json");
const lenderABIweth9 =			require("./lenderABIweth9.json");

const {attackdouble} = 			require("./attackdouble.js");

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

		// get weth, and lender account addresses
		const weth = await Setup.methods.weth().call();
		const lender = await Setup.methods.lender().call();

		// init Lender contracts
		const LenderWeth9 = new web3.eth.Contract(lenderABIweth9, lender);

		// wrap majority ether, leave rest for gas
		const Getweth = await LenderWeth9.methods.deposit().encodeABI();
    		var GetwethTX = {
			to: weth,
       			from: ATTACKACCT,
			value: 900000000000000000,
			gas: 1000000,
        		data: Getweth,
		};
		var signedTX = await web3.eth.accounts.signTransaction(GetwethTX, ATTACKPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Ether wrap TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

		// repeat for attack double account
    		GetwethTX = {
			to: weth,
       			from: ATTACKDBL,
			value: 900000000000000000,
			gas: 1000000,
        		data: Getweth,
		};
		signedTX = await web3.eth.accounts.signTransaction(GetwethTX, ATTACKDBLPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Ether wrap TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);
	}
}

main();
