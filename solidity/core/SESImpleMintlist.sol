// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../interfaces/ISEAuditContractRegistry.sol";
import "../interfaces/ISEMintAuthRegistry.sol";
import "../interfaces/ISERegistry.sol";
import "../interfaces/ISEVersionedAddress.sol";


contract SESimpleMintList is ISEMintAuthRegistry, ISEVersionedAddress {

    string constant name = "RESERVED_SANTA_ELENA_MINT_AUTHORISATION_REGISTRY";
    uint256 constant version = 1; 

    address administrator; 
    ISEAuditContractRegistry auditContracts; 
    mapping(address=>bool) allowed; 
    ISERegistry registry; 

    string constant SANTA_ELENA_AUDIT_MANAGER_CA            = "RESERVED_SANTA_ELENA_AUDIT_MANAGER";
    string constant SANTA_ELENA_AUDIT_CONTRACT_FACTORY_CA   = "RESERVED_SANTA_ELENA_AUDIT_CONTRACT_FACTORY";
    
    constructor(address _administrator, address _registry){
        administrator = _administrator; 
        registry = ISERegistry(_registry);
        auditContracts = ISEAuditContractRegistry(registry.getAddress(SANTA_ELENA_AUDIT_CONTRACT_FACTORY_CA));
        allowed[registry.getAddress(SANTA_ELENA_AUDIT_MANAGER_CA)] = true;        
        allowed[administrator] = true;
    }

   function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function isKnown(address _address) view external returns (bool){
        if(auditContracts.isKnown(_address)){
            return true; 
        }

        if(allowed[_address]) {
            return true; 
        }

        return false; 
    }

    function addAdhoc(address _address) external returns (bool _added){
        adminOnly(); 
        allowed[_address] = true; 
        return true; 
    }

    function  removeAdhoc(address _address) external returns (bool _removed) {
        adminOnly();
        delete allowed[_address];
        return true; 
    }

    function notifyChangeOfAddress() external returns (bool) {
        adminOnly(); 
        auditContracts = ISEAuditContractRegistry(registry.getAddress(SANTA_ELENA_AUDIT_CONTRACT_FACTORY_CA));
        allowed[registry.getAddress(SANTA_ELENA_AUDIT_MANAGER_CA)] = true;        
        allowed[administrator] = true;
        return true; 
    }


    //========================= INTERNAL ===================================
    function adminOnly() view internal returns (bool _adminOnly){
        require(msg.sender == administrator, " admin only ");
        return true; 
    }
}
