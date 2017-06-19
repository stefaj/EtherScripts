pragma solidity ^0.4.11;

contract ERC20 {
  function transfer(address _to, uint _value) returns (bool success);
}

contract CrowdsaleController {
  function contributeETH() payable returns (uint256 amount);
}

contract SNTBuyer {
  mapping (address => uint) public balances;
  uint public reward;
  bool public bought_tokens;
  uint public time_bought;

  address sale = 0xBbc79794599b19274850492394004087cBf89710;
  address token = 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C;
  
  function withdraw(){
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(amount);
  }
  
  function add_reward() payable {
    reward += msg.value;
  }
  
  function buy(){
    bought_tokens = true;
    time_bought = now;

    // Old
    // CrowdsaleController(sale).contributeETH.value(this.balance - reward)();

    if(sale.send(this.balance - reward)){
      msg.sender.transfer(reward);
    }
    else{
      throw;
    }

  }
  
  function default_helper() payable {
    if (!bought_tokens) {
      balances[msg.sender] += msg.value;
    }
    else {
      // 10000 SNT per 1 ETH
      uint amount = balances[msg.sender] * 10000;

      balances[msg.sender] = 0;

      uint fee = 0;

      ERC20(token).transfer(msg.sender, amount - fee);

      msg.sender.transfer(msg.value);
    }
  }
  
  function () payable {
    default_helper();
  }
}
