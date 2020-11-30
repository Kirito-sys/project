// SPDX-License-Identifier: yewenlong
pragma solidity >=0.5.0 <=0.7.3;
import "./ERC20.sol";
import "./ERC721.sol";
// import "./ERC20lnterface.sol";
// contract GLDToken is ERC20 {
//     constructor(uint256 initialSupply) public ERC20("Gold", "GLD") {
//         _mint(msg.sender, initialSupply);
//     }
//     function getbalanceOf(address account) public{
//         ERC20.balanceOf(account);
//     }
// }
// contract ERC20FixedSupply is ERC20 {
//     constructor() public ERC20("Fixed", "FIX") {}
//         function _mintMinerReward() internal {
//         _mint(block.coinbase, 1000);
//     }
//     function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
//         _mintMinerReward();
//         super._beforeTokenTransfer(from, to, value);
//     }

// }

contract gameChain is ERC20{
    // mapping (address => uint256) public balance;
    //  uint256 _initialAmout;
   constructor() public ERC20("Fixed", "FIX") {
        _mint(msg.sender, 10000);
    //   balance[msg.sender] = 10000;
    }
    // function getbalanceOf(address account) public view returns(uint256){
    //     return balanceOf(account);
    // }
    // // transfer(address recipient, uint256 amount) → bool
    // function FIXtransfer(address recipient,uint amount) public returns(bool) {
    //      transfer(recipient,amount);
    //      return true;
    // }
    // // approve(address spender, uint256 amount) → bool
    // function FIXapprove(address spender, uint256 amount) public  returns(bool) {
    //     ERC20.approve(spender,amount);
    // }
    
    
    uint32 public game_id = 0;
    uint32 public join_id = 0;
    uint32 public owner_id = 0;
    uint32 public account_id = 0;
    struct join {
        string userName;
        string password;
        // string identity;
        address userAdderss;
    }
    mapping(uint32 => join ) public joins;
    
    struct game {
        string gamename;
        string gametype;
        address gameOwner;
        // uint32 cost;
        uint32 TimeStamp;
    }
    mapping(uint32 => game ) public games;
    
    struct trangame {
        uint32 uid;
        string gamename;
        string accountname;
        address accountOwner;
        uint32 price;
        uint32 TimeStamp;
    }
    mapping(uint32 => trangame ) public trangames;
    
    struct account {
        uint key;
        uint uid;
        uint password;
        string Email;
    }
    mapping(uint32 => account ) public accounts;
    struct ownership {
        uint32 accountId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address accountOwner;
    }
    
    mapping(uint32 => ownership) public ownerships;
    mapping(uint32 => uint32[]) public gameTrack;
    
    
    event TransferOwnership(uint32 accountId);
    
    function addjoin(string memory _name, string memory _pass, address _pAdd, string memory _pType) public returns (uint32) {
     uint32 userId = join_id++;
     joins[userId].userName = _name;
     joins[userId].password = _pass;
     joins[userId].userAdderss = _pAdd;
    //  joins[userId].identity = _pType;
    
     return userId;
    }
    function getjoin(uint32 _join_id) public view returns (string memory, address) {
        return (joins[_join_id].userName,
                joins[_join_id].userAdderss
                // joins[_join_id].identity);
                );
    }
    function addGame(uint32 _ownerId,string memory _gamename, string memory _gametype, uint32 _gameCost) public returns (uint32) {
        // if(keccak256(abi.encodePacked(joins[_ownerId].identity)) == keccak256("Manufacturer")) {
          
            uint32 gameId = game_id++;
            
            games[gameId].gamename = _gamename;
            games[gameId].gametype = _gametype;
            // games[gameId].cost = _gameCost;
            games[gameId].gameOwner = joins[_ownerId].userAdderss;
            games[gameId].TimeStamp = uint32(block.timestamp);
            
            return gameId;
        // }
        
        //  return 0;
    }
    function addaccount(uint32 _ownerId,uint32 _uid,string memory _accountname, uint32 _price,string memory _gamename, uint32 _uid2,uint32 _password,string memory _Email) public returns (uint32) {
        // if(keccak256(abi.encodePacked(joins[_ownerId].identity)) == keccak256("Player")) {
             uint32 accountId = account_id++;
            
            trangames[accountId].uid = _uid;
            trangames[accountId].accountname = _accountname;
            trangames[accountId].price = _price;
            trangames[accountId].gamename = _gamename;
            trangames[accountId].accountOwner = joins[_ownerId].userAdderss;
            trangames[accountId].TimeStamp = uint32(block.timestamp);
            uint256 key = uint256(keccak256(abi.encodePacked(block.difficulty,block.timestamp)));
            accounts[accountId].key = key;
            accounts[accountId].uid = _uid2;
            accounts[accountId].password = _password;
            accounts[accountId].Email = _Email;
            
            
            return accountId;
        // }
        
        // return 0;
    }
    
    function getaccount(uint32 _accountId) public view returns (uint32, address, uint32, string memory, string memory,uint256,uint256) {
        return (trangames[_accountId].uid,
                trangames[_accountId].accountOwner,
                trangames[_accountId].price,
                trangames[_accountId].gamename,
                accounts[_accountId].Email,
                accounts[_accountId].key,
                accounts[_accountId].password
                );
    }
    //  function transfer(address _addr,uint32 _value) public payable {
  
    //   address(uint160(_addr)).transfer(_value);
    // }
   
    

    
    modifier onlyOwner(uint32 _accountId) {
        require(msg.sender == trangames[_accountId].accountOwner, "");
        _;
        
    }
    
    function getgame(uint32 _gameId) public view returns (string memory, string memory,address,uint32){
        return (games[_gameId].gamename,
                games[_gameId].gametype,
                // games[_gameId].cost,
                games[_gameId].gameOwner,
                games[_gameId].TimeStamp);
    }
    
    function verifyjoin(uint32 _uid,string memory _uname,string memory _pass,string memory _utype) public view returns (bool){
        // if(keccak256(abi.encodePacked(joins[_uid].identity)) == keccak256(abi.encodePacked(_utype))) {
            if(keccak256(abi.encodePacked(joins[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                if(keccak256(abi.encodePacked(joins[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                    return (true);
                }
            }
        // }
        return (false);
    }
    function newOwner(uint32 _user1Id, uint32 _user2Id, uint32 _accountId) onlyOwner(_accountId) public returns (bool,uint32,uint256) {
        join memory p1 = joins[_user1Id];
        join memory p2 = joins[_user2Id];
        uint32 ownership_id = owner_id++;
        
        // if(keccak256(abi.encodePacked(p1.identity)) == keccak256("Manufacturer")
        //   && keccak256(abi.encodePacked(p2.identity)) == keccak256("Supplier")){
        //   ownerships[ownership_id].gameId = _gameId;
        //   ownerships[ownership_id].gameOwner = p2.userAdderss;
        //   ownerships[ownership_id].ownerId = _user2Id;
        //   ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);
        //   games[_gameId].gameOwner = p2.userAdderss;
        //   gameTrack[_gameId].push(ownership_id);
        //   emit TransferOwnership(_gameId);
           
        //   return (true);
        //  }
        //  if(keccak256(abi.encodePacked(p1.identity)) == keccak256("Player")
        //   && keccak256(abi.encodePacked(p2.identity)) == keccak256("Player")) {
          ownerships[ownership_id].accountId = _accountId;
          ownerships[ownership_id].accountOwner = p2.userAdderss;
          ownerships[ownership_id].ownerId = _user2Id;
          ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);
          trangames[_accountId].accountOwner = p2.userAdderss;
          gameTrack[_accountId].push(ownership_id);
          emit TransferOwnership(_accountId);
        //   address(_user1Id).transfer(_price);
              transfer(p2.userAdderss,trangames[_accountId].price);
          return (true,
                  trangames[_accountId].uid,
                  accounts[_accountId].key
                  );
        //  }
        //  else if(keccak256(abi.encodePacked(p1.identity)) == keccak256("Player")
        //   && keccak256(abi.encodePacked(p2.identity)) == keccak256("Player")) {
        //   ownerships[ownership_id].accountId = _accountId;
        //   ownerships[ownership_id].accountOwner = p2.userAdderss;
        //   ownerships[ownership_id].ownerId = _user2Id;
        //   ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);
        //   trangames[_accountId].accountOwner = p2.userAdderss;
        //   gameTrack[_accountId].push(ownership_id);
        //   emit TransferOwnership(_accountId);
           
        //   return (true);
        //   }
           
    //   return (false);
    }
    
    function getProvenance(uint32 _accountId) external view returns (uint32[] memory) {
        
        return gameTrack[_accountId];
    }
    
    function getOwnership(uint32 _regId) public view returns (uint32,uint32,address,uint32) {
        
        ownership memory r = ownerships[_regId];
        
         return (r.accountId, r.ownerId, r.accountOwner, r.trxTimeStamp);
    }
 
    
}