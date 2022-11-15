// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "../interfaces/ISERegistry.sol";
import "../interfaces/ISEVersionedAddress.sol";
import "../interfaces/ISEAuditContractFactory.sol";
import "../interfaces/ISEAuditManagerNotification.sol";

import "./SEAuditContract.sol";


contract SEAuditContractFactory is ISEAuditContractFactory, ISEVersionedAddress { 

    address administrator; 
    ISERegistry registry; 
    address self; 

    string constant SANTA_ELENA_REGISTRY_CA         = "RESERVED_SANTA_ELENA_REGISTRY";
    string constant SANTA_ELENA_AUDIT_MANAGER_CA    = "RESERVED_SANTA_ELENA_AUDIT_MANAGER";
 
    mapping(address=>bool) knownAuditContract; 

    string constant name                            = "RESERVED_SANTA_ELENA_AUDIT_CONTRACT_FACTORY"; 
    uint256 constant version = 23;
    constructor(address _administrator, address _registry){
        administrator = _administrator; 
        registry = ISERegistry(_registry);
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function isKnown(address _auditContract) view  external returns (bool _isKnown) {
        if(_auditContract == self) {
            return true; 
        }
        return knownAuditContract[_auditContract];
    }

    function createAuditContract(ISEAuditContract.AuditSeed memory _seed, 
                                                    string [] memory _urisToAudit, 
                                                    string [] memory _uriLabels, 
                                                    bool [] memory _uriPrivacy,                                                     
                                                    string memory _notesUri, 
                                                    address _uploadProofErc1155, 
                                                    uint256 _uploadProofNftId) external returns (address _auditContract){

                    address auditManagerAddress_ = registry.getAddress(SANTA_ELENA_AUDIT_MANAGER_CA);
                    require(msg.sender == auditManagerAddress_ || msg.sender == administrator, "Santa Elena Audit Manager only");
                    _auditContract = address(new SEAuditContract(   _seed, 
                                                                    _urisToAudit,
                                                                    _uriLabels, 
                                                                    _uriPrivacy, 
                                                                    _notesUri,
                                                                    address(registry),
                                                                    _uploadProofErc1155,
                                                                    _uploadProofNftId));  
                    knownAuditContract[_auditContract] = true;   
                    ISEAuditManagerNotification(auditManagerAddress_).notifyStatus(_auditContract, ISEAuditContract(_auditContract).getStatus());
                    return _auditContract;                     
    }
    
    function notifyChangeOfAddress() external returns (bool _notified) {
        adminOnly(); 
        registry = ISERegistry(registry.getAddress(SANTA_ELENA_REGISTRY_CA)); 
        return true; 
    }

    function setAdministrator(address _address) external returns (bool) {
        adminOnly();
        administrator = _address; 
        return true; 
    }

    //======================================== INTERNAL ============================================
    function adminOnly() view internal returns (bool _adminOnly){
        require(msg.sender == administrator, " admin only ");
        return true; 
    }
}
