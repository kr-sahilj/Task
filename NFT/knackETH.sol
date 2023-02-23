// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract KnackNFT {
    address public owner;
    address public contractAddress;
    string public name;
    string public symbol;
    uint private count;
    uint256 public amount;
    mapping(uint256 => address) nftOwners;
    mapping(address => uint256) nftBalance;
    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    //events
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    constructor() {
        name = "KnackNFT";
        symbol = "KFT";
        count=0;
        owner = msg.sender;
        amount= 10000000000000000;
        contractAddress=address(this);
    }

    // function _approve(address to) public {
    //     return token.approve(to,amount);
    // }

    // function _allowance(address to) public returns(uint){
    //     return token.allowance(owner, to);
    // }
    
    function safeMint(address to) payable public {
        uint256 tokenId = count;
        count++;
        
        _mint(to, tokenId);
        sendETH(payable(owner));
    }

    function _mint(address to, uint256 tokenId) private {
        
        require(to != address(0), "Mint to the zero address");
        require(!exists(tokenId), "Token already minted");
        // require(nftBalance[to] == 0, "You have already minted token");
        // require()
        nftBalance[to]+= 1;

        nftOwners[tokenId] = to;
        

        emit Transfer(address(0), to, tokenId);
    }

    function sendETH(address payable receiver) public payable {
		require(msg.sender.balance >= msg.value, "You don't have enough funds"); // require that the sender has enough ether to send
        // uint require
        require(msg.value>=amount,"Enough ETH not send");

		bool success = receiver.send(amount); 
		require(success, "Transfer failed");
        if(msg.value>amount){
            payable(msg.sender).transfer(msg.value-amount);
        }
	}


    function _transfer(address from, address to, uint256 tokenId) external   {
        require(to != address(0), "transfer to the zero address");

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(_tokenApprovals[tokenId] == from || ownerOf(tokenId) == from, "You don't have permission or You're not the owner");

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];


        unchecked {
            require(nftBalance[from]>0,"You dont have nft");
            nftBalance[from] -= 1;
            nftBalance[to] += 1;
        }
        nftOwners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
    function _approve(address to, uint256 tokenId) external {
        require(msg.sender==ownerOf(tokenId),"only the owner can approve");
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    
    
    function checkBalance() public view returns(uint){
        return (msg.sender).balance;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return nftOwners[tokenId];
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return ownerOf(tokenId) != address(0);
    }
    

    
}
