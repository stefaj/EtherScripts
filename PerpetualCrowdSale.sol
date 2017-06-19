
contract ERC20 {
  function transfer(address _to, uint _value) returns (bool success);
}

contract Crowdsale {
    
    address public beneficiary;
    uint public amountRaised;
    uint public price;

    // token address yaeh boys
    address token;
    
    function Crowdsale(address _beneficiary, uint _price, address _token) {
        beneficiary = _beneficiary;
        price = _price;
        token = _token;
    }   
    
    function () {
        uint amount = msg.value;
        funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
        amountRaised += amount;
        ERC20(token).transfer(msg.sender, amount / price);
    }

    function retrieve(){
        beneficiary.send(amountRaised);
        suicide(beneficiary);
    }
}
