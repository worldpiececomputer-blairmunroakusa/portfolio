// import data
const challengeData =			require("./challenge2.json");
const setupABIsetup =			require("./setupABIsetup.json");
const lenderABIlender =			require("./lenderABIlender.json");
const lenderABIerc20like =		require("./lenderABIerc20like.json");
const lenderABIweth9 =			require("./lenderABIweth9.json");

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
		const {attackdouble} = 	require("./attackdouble.js");
		const ATTACKDBL = attackdouble.address;
		const ATTACKDBLPRIKEY = attackdouble.privateKey;
		
		// init Setup contract
		const Setup =		new web3.eth.Contract(setupABIsetup, SETUPACCT);
		
		// get addresses for other contract objects
		const token = await Setup.methods.token().call();
		const weth = await Setup.methods.weth().call();
		const lender = await Setup.methods.lender().call();

		// init Lender contracts
		const Lender =		new web3.eth.Contract(lenderABIlender, lender);
		const LenderERC20 =	new web3.eth.Contract(lenderABIerc20like, token);
		const LenderWeth9 =	new web3.eth.Contract(lenderABIweth9, weth);

		// print key account balance data
		console.log("ETH balance (attack/double)")
		await web3.eth.getBalance(ATTACKACCT).then(console.log);
		await web3.eth.getBalance(ATTACKDBL).then(console.log);
		
		console.log("safedebt (attack/double)");
		await Lender.methods.safeDebt(ATTACKACCT).call().then(console.log);
		await Lender.methods.safeDebt(ATTACKDBL).call().then(console.log);

		console.log("deposited (attack/double)");
		await Lender.methods.deposited(ATTACKACCT).call().then(console.log);
		await Lender.methods.deposited(ATTACKDBL).call().then(console.log);

		console.log("debt (attack/double)");
		await Lender.methods.debt(ATTACKACCT).call().then(console.log);
		await Lender.methods.debt(ATTACKDBL).call().then(console.log);

		console.log("weth & token balance (attack/double)");
		await LenderWeth9.methods.balanceOf(ATTACKACCT).call().then(console.log);
		await LenderERC20.methods.balanceOf(ATTACKACCT).call().then(console.log);
		console.log("");
		await LenderWeth9.methods.balanceOf(ATTACKDBL).call().then(console.log);
		await LenderERC20.methods.balanceOf(ATTACKDBL).call().then(console.log);

		// print isSolved function
		console.log("Lender liquidation status:?");
		await Setup.methods.isSolved().call().then(console.log);

	} catch (error) {
		
		// catch any random errors
		console.log("Error: " + error);
	}
}

main();
