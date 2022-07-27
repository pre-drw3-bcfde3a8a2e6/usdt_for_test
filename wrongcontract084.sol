pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

contract TaxedToken {
    
    
    mapping(address => uint) internal balances;
    mapping(address => bool) internal isTokenHolder;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    uint totalTaxedAmount = 0;
    uint totalUniqueUsers = 0;
    address public owner;
    
    constructor() {
        owner = msg.sender;
        balances[owner] = 100;
        totalUniqueUsers = 1;
    }
    
    function balanceOf(address account) public view returns (uint) {
        return balances[account] + (totalTaxedAmount / totalUniqueUsers);
    }
    
    function transfer(address _to, uint _value) public {
        require(balanceOf(msg.sender) >= _value, "Insuficient funds");
        balances[msg.sender] =  balances[msg.sender] - _value;
        balances[_to] = balances[_to]  + _value ;
    }

    function transferFrom1(address _from, address _to, uint256 _amount) public returns (bool success) {

        require(_to != address(0));
        require(_amount <= balances[_from]);
        require(_amount <= allowed[_from][msg.sender]);
        
        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount)  public returns (bool success) {

        require(_to != address(0));
        require(_amount <= balances[_from]);
        require(_amount <= allowed[_from][msg.sender]);
        
        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 spend/approval race condition
        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}
