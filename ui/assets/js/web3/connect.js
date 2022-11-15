const connectBlockchainButton = ge("connect_web3");
const showWallet = ge("show_wallet");
const web3 = new Web3(window.ethereum);

// const iSERegistryAddress = "0xF5C41b43F1E7B39Ae5b5B01194f1a6E6D40955A4"; // Goerli

const iSERegistryAddress = "0x1d012AE2340C058D1473ACC911c0B3144B7F5EF2"; // Testnet Wallaby 

var iSERegistryContract;
var iSEAuditManagerAddress;
var sEAuditManagerContract; 

var account;
//Created check function to see if the MetaMask extension is installed
const isMetaMaskInstalled = () => {

	const {
		ethereum
	} = window;
	return Boolean(ethereum && ethereum.isMetaMask);
};

const MetaMaskClientCheck = () => {
	//Now we check to see if Metmask is installed
	if (!isMetaMaskInstalled()) {
		console.log("metamask not installed");
		//If it isn't installed we ask the user to click to install it
		connectBlockchainButton.innerText = 'Click here to install MetaMask!';
		//When the button is clicked we call this function
		connectBlockchainButton.onclick = onClickInstall;
		//The button is now disabled
		connectBlockchainButton.disabled = false;
	} else {
		//If it is installed we change our button text
		connectBlockchainButton.innerText = 'Click to Connect Metamask';

		console.log("metamask installed");
		connectBlockchainButton.addEventListener('click', () => {
			getAccount();
			connectBlockchainButton.innerText = "Web 3 Connected";

		});
	}
};
const initialize = () => {
	MetaMaskClientCheck();

};

window.addEventListener('DOMContentLoaded', initialize);

async function getAccount() {
	const accounts = await ethereum.request({
		method: 'eth_requestAccounts'
	});
	account = accounts[0];
	showWallet.innerHTML = "<small>Wallet :: " + account + "</small>";
	loadContracts();
}

//We create a new MetaMask onboarding object to use in our app
//const onboarding = new MetaMaskOnboarding({ forwarderOrigin });

//This will start the onboarding proccess
const onClickInstall = () => {
	connectBlockchainButton.innerText = 'Onboarding in progress';
	connectBlockchainButton.disabled = true;
	//On this object we have startOnboarding which will start the onboarding process for our end user
	// open link to download metamask
};

const onClickConnect = async() => {
	try {
		// Will open the MetaMask UI
		// You should disable this button while the request is pending!
		await ethereum.request({
			method: 'eth_requestAccounts'
		});
	} catch (error) {
		console.error(error);
	}
};
function loadContracts() {
	iSERegistryContract = getContract(iSERegistryAbi, iSERegistryAddress);

	iSERegistryContract.methods.getAddress("RESERVED_SANTA_ELENA_AUDIT_MANAGER").call({from : account})
	.then(function(response){
		console.log(response);
		console.log("loading audit manager")
		iSEAuditManagerAddress = response; 
		sEAuditManagerContract = getContract(iSEAuditManagerAbi, iSEAuditManagerAddress);
		loadPage(); 		
	})
	.catch(function(err){
		console.log(err);
	})
}

function getContract(abi, address) {
	return new web3.eth.Contract(abi, address);
}

function ge(element) {
	return document.getElementById(element);
}

function ce(element) {
	return document.createElement(element);
}

function text(txt) {
	return document.createTextNode(txt);
}