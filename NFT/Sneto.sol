//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";//** */

contract SneTo is ERC20 {
  
    constructor() ERC20("SneTo", "SNT"){
        _mint(msg.sender, 5000*10**18);
    }

}