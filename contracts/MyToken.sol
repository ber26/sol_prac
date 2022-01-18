// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/TokenTimelock.sol";

contract MyToken is ERC20 {

    uint256 private constant duration = 1 days;
    address private owner;

    mapping (address=>uint256) public whitelist;


    constructor(uint256 initialSupply) ERC20 ("MyToken", "MT") {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
    }

    function addToWhitelist(address _newAddress) public {
        require(msg.sender == owner);
        whitelist[_newAddress] = 1;
    }

    function claimWhitelist() public  {
        require(whitelist[msg.sender] == 1 );
        _transfer(owner, msg.sender, 10000);
        whitelist[msg.sender]=block.timestamp + duration;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        if ((whitelist[msg.sender] > block.timestamp) || !(whitelist[msg.sender] <= 1))
            revert("too early sir!");
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
}
