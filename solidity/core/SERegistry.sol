// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../interfaces/ISEVersionedAddress.sol";
import "../interfaces/ISERegistryLite.sol";

contract SERegistry is ISERegistryLite { 

    string constant name = "SANTA_ELENA_REGISTRY"; 
    uint256 constant version = 1; 

    address administrator; 
    mapping(string=>bool) isKnownName; 
    mapping(address=>bool) isKnownAddress; 
    mapping(string=>address) addressByName; 
    mapping(address=>string) nameByAddress; 

    address[] validAddresses; 
    address[] allAddresses; 
    mapping(address=>VersionedEntry) versionedEntryByAddress;

    constructor(address _administrator) {
        administrator = _administrator; 
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function isKnown(string memory _name) view external returns (bool _isKnown){
        return isKnownName[_name];
    }

    function isKnown(address _address) view external returns (bool _isKnown){
        return isKnownAddress[_address];
    }

    function getAddress(string memory _name)view external returns (address _address){
        return addressByName[_name];
    }
    
    function getName(address _address)view external returns (string memory _name){
        return nameByAddress[_address];
    }

    function listAddresses() view external returns (VersionedEntry [] memory _versionedEntries){
        return getVersionedEntries(validAddresses);
    }

    function addVersionedAddress(address _address) external returns (bool _added){
        adminOnly(); 
        require(!isKnownAddress[_address], " known address ");
        ISEVersionedAddress va_ = ISEVersionedAddress(_address);
        VersionedEntry memory ve_ = VersionedEntry({
                                                veAddress : _address,
                                                name : va_.getName(),
                                                version : va_.getVersion()
                                            });
        versionedEntryByAddress[_address] = ve_; 

        if(!isKnownName[va_.getName()]) {
            isKnownName[va_.getName()] = true; 
        }
        else { 
           validAddresses = remove(addressByName[va_.getName()],validAddresses);
        }
        isKnownAddress[_address] = true; 
        nameByAddress[_address] = va_.getName(); 
        addressByName[va_.getName()] = _address; 
        validAddresses.push(_address);
        allAddresses.push(_address);
        return true; 
    }

    function removeVersionedAddress(address _address) external returns (bool _removed){
        adminOnly(); 
        VersionedEntry memory  ve_ = versionedEntryByAddress[_address];
        
        delete versionedEntryByAddress[_address];
        delete isKnownAddress[_address];
        
        if(isKnownName[ve_.name]){
            if(addressByName[ve_.name] == _address){
                // valid 
                delete addressByName[ve_.name];
                delete isKnownName[ve_.name];                
                delete nameByAddress[_address];
                validAddresses = remove(_address, validAddresses);
            }
            else {
                // not valid 
            }
        }
        return true; 
    }


    function setAdministrator(address _address) external returns (bool) {
        adminOnly();
        administrator = _address; 
        return true; 
    }
    //======================================== INTERNAL ============================================

    function remove(address a, address [] memory b) pure internal returns (address [] memory c) {
        c = new address[](b.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < b.length; x++) {
            if(a != b[x]){
                c[y] = b[x];
                y++;
            }
        }
        return c; 
    }

    function getVersionedEntries(address [] memory _addresses)view  internal returns (VersionedEntry [] memory _versionedEntries) {
        _versionedEntries = new VersionedEntry[](_addresses.length);
        for(uint256 x = 0; x < _addresses.length; x++) {
            _versionedEntries[x] = versionedEntryByAddress[_addresses[x]];
        }
        return _versionedEntries; 
    }

    function adminOnly() view internal returns (bool _adminOnly){
        require(msg.sender == administrator, " admin only ");
        return true; 
    }
}