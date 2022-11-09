// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ERC1155.sol";

import "../interfaces/ISEVersionedAddress.sol";

contract SEERC1155 is ERC1155, ISEVersionedAddress { 
    uint256 constant version  = 1;
    string name; 
    string symbol; 
    bool uriSwitchEnabled; 
    address administrator; 
    mapping(uint256=>string) uriByNftId; 
    address authorisedMinter; 

    constructor(address _administrator, 
                string memory _defaultUri, 
                bool _uriSwitchEnabled, string memory _name, string memory _symbol) ERC1155(_defaultUri) {
        
        administrator = _administrator; 
        uriSwitchEnabled = _uriSwitchEnabled; 
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
        if(uriSwitchEnabled){
            return uriByNftId[_nftId];
        }
        return super.uri(_nftId);
    }

    function mint(address _to, string memory _uri) external returns(uint256 _nftId) {
        authorisedMinterOnly();
        require(uriSwitchEnabled, "URI switching NOT enabled");
        _nftId = getIndex(); 
        uriByNftId[_nftId] = _uri; 
        super._mint(_to,_nftId, 1, bytes(_uri)); 
        return _nftId; 
    }   

    function mint(address _to) external returns (uint256 _nftId){
        authorisedMinterOnly();
        require(!uriSwitchEnabled, "URI switching ENABLED");
        _nftId = getIndex(); 
        super._mint(_to,_nftId, 1, bytes(""));       
        return _nftId; 
    }

    function setAuthorisedMinter(address _minter) external returns (bool _set) {
        adminOnly(); 
        authorisedMinter = _minter; 
        return true; 
    }

    //======================================= INTERNAL =============================================
    function adminOnly() view internal returns (bool _admin) {
        require(msg.sender == administrator, " admin only ");
        return true; 
    }

    function authorisedMinterOnly() view internal returns (bool _admin) {
        require(msg.sender == authorisedMinter, " authorised minter only ");
        return true; 
    }

    uint256 index = 0; 

    function getIndex() internal returns (uint256 _index){
        _index = index; 
        index++; 
        return _index; 
    }

}