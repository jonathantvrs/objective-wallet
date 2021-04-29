var contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";

document.addEventListener("DOMContentLoaded", onDocumentLoad);
function onDocumentLoad() {
  DApp.init();
}

const DApp = {
  web3: null,
  contracts: {},
  account: null,

  init: function () {
    return DApp.initWeb3();
  },

  initWeb3: async function () {
    if (typeof window.ethereum !== "undefined") {
      try {
        const accounts = await window.ethereum.request({ 
          method: "eth_requestAccounts",
        });
        DApp.account = accounts[0];
        window.ethereum.on('accountsChanged', DApp.updateAccount); 
      } catch (error) {
        console.error("Usuário negou acesso ao web3!");
        return;
      }
      DApp.web3 = new Web3(window.ethereum);
    } else {
      console.error("Instalar MetaMask!");
      return;
    }
    return DApp.initContract();
  },

  updateAccount: async function() {
    DApp.account = (await DApp.web3.eth.getAccounts())[0];
    atualizaInterface();
  },

  initContract: async function () {
    DApp.contracts.OWalletFactory = new DApp.web3.eth.Contract(abi, contractAddress);
    return DApp.render();
  },

  render: async function () {
    inicializaInterface();
  },
};

function getWallets() {
  return DApp.contracts.OWalletFactory.methods.getWallets().call();
}

function createWallet() {
  DApp.contracts.OWalletFactory.methods.createWallet().call();
}
