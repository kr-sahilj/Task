//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IERC20{
    //use to talk to other contract
    function transfer(address to, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);

    event Transfer(address indexed from,address indexed to,uint value);
}
contract Faucet {
    address payable owner;
    IERC20 public token;

    uint256 public withDrawlAmount; 
    uint256 public lockTime;


    event WithDrawl(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime;

    constructor(address tokenAddress) payable{
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
        withDrawlAmount =10 * (10**18);
        lockTime = 1 minutes;

    }

    function requestTokens() public {
        
        require(token.balanceOf(address(this)) >= withDrawlAmount , "Insufficient balance in faucet");
        require(block.timestamp >= nextAccessTime[msg.sender], "Wait for 24 hours after last withdrawl");

        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        token.transfer(msg.sender,withDrawlAmount);
        
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns(uint256) {
        return token.balanceOf(address(this));
    }


    function setLockTime(uint256 amount) public onlyOwner{
        lockTime = amount*1 minutes;
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