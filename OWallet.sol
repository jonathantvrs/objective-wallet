pragma solidity ^0.8.3;

contract OWallet {
  
  address payable owner;
  
  struct Objective {
    string name;
    uint goal;
    uint amount;
  }

  Objective[] objectives;
  address[] stakeholders;

  constructor() {
    owner = payable(msg.sender);
  }

  function addStakeholder(address _stakeholder) public {
    stakeholders.push(_stakeholder);
  }

  function _checkStakeholder() private returns (bool) {
    bool exists = false;
    for (uint i = 0; i < stakeholders.length; i++) {
      if (msg.sender == stakeholders[i]) {
        exists = true;
        break;
      }
    }
    
    return exists;
  }

  modifier onlyOwner {
    require(owner == msg.sender);
    _;
  }

  modifier onlyStakeholders {
    require(_checkStakeholder());
    _;
  }

  function _checkObjectiveName(string memory _name) private returns (bool) {
    bool nameExists = false;
    for (uint i = 0; i < objectives.length; i++) {
      if (keccak256(bytes(objectives[i].name)) == 
          keccak256(bytes(_name))) 
      {
        nameExists = true;
        break;
      }
    }

    return nameExists; 
  }

  function createObjective(string memory _name, uint _goal) public onlyOwner {
    require(!_checkObjectiveName(_name));
    objectives.push(Objective(_name, _goal, 0));
  }

  function deposit() public onlyStakeholders payable {
    require(objectives.length > 0);
    uint value = msg.value / objectives.length;
    for (uint i = 0; i < objectives.length; i++) {
      objectives[i].amount += value;
    }
  }

  function withdraw(uint _index) public onlyOwner {
    require(objectives[_index].amount >= objectives[_index].goal);
    owner.transfer(objectives[_index].amount);
    Objective storage obj = objectives[_index];
    obj.amount = 0;
  }  

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}

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