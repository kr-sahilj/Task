//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface ERC20 {
    //use to talk to other contract
    function transfer(address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address payable owner;
    ERC20 public token;

    uint256 public withDrawlAmount;
    uint256 public lockTime;
    uint256 public maxlimit;

    event WithDrawl(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) firstAccessTime;
    mapping(address => uint256) totalToken;

    constructor(address tokenAddress) payable {
        token = ERC20(tokenAddress);
        owner = payable(msg.sender);
        lockTime = 4 minutes;
        maxlimit = 500 * (10**18);
    }

    function requestTokens(uint256 _withDrawlAmount) public {
        _withDrawlAmount*=(10**18);
        if (block.timestamp > firstAccessTime[msg.sender] + lockTime) {
            totalToken[msg.sender] = 0;
            firstAccessTime[msg.sender] = block.timestamp;
        }
        require(totalToken[msg.sender] + _withDrawlAmount <= maxlimit,"today's maximum limit reached");
        
        token.transfer(msg.sender, _withDrawlAmount);
        totalToken[msg.sender] += _withDrawlAmount;
    }

    // receive() external payable {
    //     emit Deposit(msg.sender, msg.value);
    // }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setLockTime(uint256 amount) public onlyOwner {
        lockTime = amount * 1 minutes;
    }

    function withDrawl() external onlyOwner {
        emit WithDrawl(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract onwer can call this");
        _;
    }
}
