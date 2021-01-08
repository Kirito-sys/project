// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract GameChain is ERC721  {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
      struct account {
        string name;
        string game;
        string url;
        uint256 price;
        string pass;
        address owner;
        uint256 id;
    }
    address  public owner = msg.sender;
  
     modifier onlyOwner {
    require(msg.sender == owner,"you not owner!");     
 _;  
}
 mapping (address => uint256) public balance;
 mapping(uint256 => account) public accounts;
 mapping (address => uint) pendingWithdraws;
    constructor() public ERC721("GameChain", "ITM") {}
    function addaccount(string memory tokenURl,string memory _name,uint256 _id,string memory _game,uint256 _price,string memory _pass)
        public onlyOwner
        returns (uint256)
    {   _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURl);
            accounts[tokenId].name = _name;
            accounts[tokenId].game = _game;
            accounts[tokenId].price = _price;
            accounts[tokenId].url = tokenURl;
            accounts[tokenId].pass = _pass;
            accounts[tokenId].owner = msg.sender;
            accounts[tokenId].id = _id;

        return tokenId;
    }
      function getAccountText(uint256 _tokenId) public view returns (
        string memory name,string memory game,uint256 price){return (          
            accounts[_tokenId].name,
            accounts[_tokenId].game,
            accounts[_tokenId].price
        );
    }
    function getProdId(uint256 _Index) public view returns (string memory r_token, uint256 r_index){
        uint256 _token = tokenOfOwnerByIndex(msg.sender, _Index);
        return (tokenURI(_token), _token);
    }
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
      _transfer(from, to, tokenId);
         accounts[tokenId].owner = to;
         accounts[tokenId].name;
            accounts[tokenId].id;
            accounts[tokenId].url;
            //_transfer(from, to, tokenId);
            accounts[tokenId].owner  = to;
    }
       function buyaccount(address buy , uint256 tokenId) public  payable returns (string memory name,string memory game,string memory url,uint256 price,string memory pass,address owner,uint256 id){
        require(msg.value == 2 ether,"u need 2ether");
             _transfer(buy, msg.sender, tokenId);
        return (
            accounts[tokenId].name,
            accounts[tokenId].game,
            accounts[tokenId].url,
            accounts[tokenId].price,
            accounts[tokenId].pass,
            accounts[tokenId].owner = msg.sender,
            accounts[tokenId].id
        );
    }
    function getonwer() public view returns(address){
        return owner;
    }
    function getUserBalance(address _user) public view returns (uint256) {
        return balanceOf(_user);
    }
      function getContractBalance() public view onlyOwner returns (uint256)  {
         return address(this).balance;
     }
       function getContractBalance2() public view  returns (uint256)  {
         return address(this).balance;
     } 
       function withdrawAmount(uint256 amount) public onlyOwner {
         require(amount <= getContractBalance());
         msg.sender.transfer(amount);
     }
        function withdrawAmount2(uint256 amount) public  {
         require(amount <= getContractBalance());
         msg.sender.transfer(amount);
     }
    function money() public payable {}
}