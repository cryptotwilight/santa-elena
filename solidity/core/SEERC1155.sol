// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ERC1155.sol";

import "../interfaces/ISEVersionedAddress.sol";
import "../interfaces/ISERegistry.sol";

contract SEERC1155 is ERC1155, ISEVersionedAddress { 
    uint256 constant version  = 3;
    string name; 

    string constant SANTA_ELENA_REGISTRY_CA = "RESERVED_SANTA_ELENA_REGISTRY";
    string constant SANTA_ELENA_AUTHORISED_MINTER_CA = "RESERVED_SANTA_ELENA_MINTER";

    string symbol; 
    
    address administrator; 

    ISERegistry registry; 

    mapping(uint256=>string) uriByNftId; 
    address authorisedMinter; 

    constructor(address _administrator, address _registry, 
                string memory _defaultUri, 
                string memory _name, string memory _symbol) ERC1155(_defaultUri) {
        
        registry = ISERegistry(_registry);
        administrator = _administrator; 
        name = _name; 
        symbol = _symbol; 
    }

    function getCurrentIndex() view external returns (uint256 _index) {
        return index; 
    }

    function getName() view external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getAdministrator() view external returns (address _administrator) {
        return administrator;
    }

    function getSymbol() view external returns (string memory _symbol) {
        return symbol; 
    }

    function uri(uint256 _nftId) public view override returns (string memory){ 
        return uriByNftId[_nftId];            
    }

    function mint(address _to, string memory _uri) external returns(uint256 _nftId) {       
        authorisedMinterOnly();   
        require(_to != address(0), " zero address ");
        require(!equal(_uri, ""), " empty uri ");     
        _nftId = getIndex(); 
        uriByNftId[_nftId] = _uri; 
        super._mint(_to,_nftId, 1, bytes(hex"01020304")); 
        return _nftId; 
    }   

    //======================================= INTERNAL =============================================
    function adminOnly() view internal returns (bool _admin) {
        require(msg.sender == administrator, " admin only ");
        return true; 
    }

    function equal(string memory _a, string memory _b) pure internal returns (bool _equal) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    function authorisedMinterOnly() view internal returns (bool _admin) {
        require(msg.sender == registry.getAddress(SANTA_ELENA_AUTHORISED_MINTER_CA), " authorised minter only ");
        return true; 
    }

    uint256 index = 0; 

    function getIndex() internal returns (uint256 _index){
        _index = index; 
        index++; 
        return _index; 
    }

}