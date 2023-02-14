//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface ERC20{
    //use to talk to other contract
    function transfer(address to, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);

    event Transfer(address indexed from,address indexed to,uint value);
}
contract Faucet {
    address payable owner;
    ERC20 public token;

    uint256 public withDrawlAmount; 
    uint256 public lockTime;
    uint256 public maxlimit;


    event WithDrawl(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime;
    mapping(address => uint256) totalToken;

    constructor(address tokenAddress) payable{
        token = ERC20(tokenAddress);
        owner = payable(msg.sender);
        withDrawlAmount =100 * (10**18);
        lockTime = 5 minutes;
        maxlimit = 500*(10**18);

    }

    function requestTokens() public {

        
        if(totalToken[msg.sender]!=0)
        {
            //old user
            if(totalToken[msg.sender]==maxlimit)
            {
                if( block.timestamp > nextAccessTime[msg.sender]+lockTime)
                {
                    totalToken[msg.sender]=0;
                    nextAccessTime[msg.sender]=block.timestamp;
                }
                else{
                    require(totalToken[msg.sender] > maxlimit,"today's maximum limit reached");
                }
                
            }
            // require(totalToken[msg.sender] > maxlimit,"today's maximum limit reached");
            // if time ends but maximum token limit still left
            if(nextAccessTime[msg.sender]+lockTime <= block.timestamp)
            {
                totalToken[msg.sender]=0;
                token.transfer(msg.sender,withDrawlAmount);
                totalToken[msg.sender]+=withDrawlAmount;
                nextAccessTime[msg.sender]=block.timestamp;
                
            }
            else
            {
                token.transfer(msg.sender,withDrawlAmount);
                totalToken[msg.sender]+=withDrawlAmount;
            }
            
        }
        else{
            //new user
            token.transfer(msg.sender,withDrawlAmount);
            nextAccessTime[msg.sender]=block.timestamp;
            totalToken[msg.sender]+=withDrawlAmount;

        }
    }

    // receive() external payable {
    //     emit Deposit(msg.sender, msg.value);
    // }

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