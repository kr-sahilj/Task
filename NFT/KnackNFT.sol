// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
interface ERC20 {
    //use to talk to other contract
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);    
}

contract KnackNFT {
    ERC20 public token;
    address public owner;
    address public contractAddress;
    string public name;
    string public symbol;
    uint private count;
    uint public amount;
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
        amount= 100*(10**18);
        token = ERC20(0x0fE7297c391362f6103e0a36566AF215FB87A168);
        contractAddress=address(this);
    }

    // function _approve(address to) public {
    //     return token.approve(to,amount);
    // }

    // function _allowance(address to) public returns(uint){
    //     return token.allowance(owner, to);
    // }
    
    function safeMint(address to) public {
        uint256 tokenId = count;
        count++;
        _mint(to, tokenId);
    }

    function _mint(address to, uint256 tokenId) private {
        
        require(to != address(0), "Mint to the zero address");
        require(!_exists(tokenId), "Token already minted");
        // require(nftBalance[to] == 0, "You have already minted token");
        // require()
        nftBalance[to]+= 1;

        nftOwners[tokenId] = to;
        

        token.transferFrom(to, owner, amount);

        emit Transfer(address(0), to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) external   {
        require(to != address(0), "transfer to the zero address");

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(_tokenApprovals[tokenId] == from || _ownerOf(tokenId) == from, "You don't have permission or You're not the owner");

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            nftBalance[from] -= 1;
            nftBalance[to] += 1;
        }
        nftOwners[tokenId] = to;

        emit Transfer(from, to, tokenId);

    }
    function _approve(address to, uint256 tokenId) external onlyOwner{
        _tokenApprovals[tokenId] = to;
        emit Approval(_ownerOf(tokenId), to, tokenId);
    }

    function _ownerOf(uint256 tokenId) private view returns (address) {
        return nftOwners[tokenId];
    }

    function _exists(uint256 tokenId) private view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract onwer can call this");
        _;
    }

    
}
