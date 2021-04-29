pragma solidity ^0.8.3;

import "./OWallet.sol";

contract OWalletFactory {
  OWallet[] private _owallets;

  event CreatedWallet(address owner, address wallet);

  function createWallet() external {
    OWallet owallet = new OWallet();
    _owallets.push(owallet);
    emit CreatedWallet(msg.sender, address(owallet));
  }

  function getWallets() external view returns (OWallet[] memory) {
    return _owallets;
  }
}