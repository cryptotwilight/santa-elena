// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "../interfaces/ISERegistryLite.sol";
import "../interfaces/ISEVersionedAddress.sol";
import "../interfaces/ISEAuditContractFactory.sol";

import "./SEAuditContract.sol";


contract SEAuditContractFactory is ISEAuditContractFactory, ISEVersionedAddress { 

    address administrator; 
    ISERegistryLite registry; 
 
    mapping(address=>bool) knownAuditContract; 

    string constant name = "SANTA_ELENA_AUDIT_CONTRACT_FACTORY"; 
    uint256 constant version = 1;

    constructor(address _administrator, address _registry){
        administrator = _administrator; 
        registry = ISERegistryLite(_registry);
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function isKnown(address _auditContract) view  external returns (bool _isKnown) {
        return knownAuditContract[_auditContract];
    }

    function createAuditContract(ISEAuditContract.AuditSeed memory _seed, 
                                                    string [] memory _urisToAudit, 
                                                    string [] memory _uriLabels, 
                                                    bool [] memory _uriPrivacy,                                                     
                                                    string memory _notesUri, 
                                                    address _auditManagerNotification,
                                                    address _minter, 
                                                    address _uploadProofErc1155, 
                                                    uint256 _uploadProofNftId) external returns (address _auditContract){
                    require(msg.sender == registry.getAddress("SANTA_ELENA_AUDIT_MANAGER"), "Santa Elena Audit Manager only");
                    _auditContract = address(new SEAuditContract( _seed, 
                                                            _urisToAudit,
                                                            _uriLabels, 
                                                            _uriPrivacy, 
                                                            _notesUri,
                                                            _auditManagerNotification,
                                                            _minter, 
                                                            _uploadProofErc1155,
                                                            _uploadProofNftId));  
                    knownAuditContract[_auditContract] = true;    
                    return _auditContract;                     
    }
    
    function notifyChangeOfAddress() external returns (bool _notified) {
        adminOnly(); 
        registry = ISERegistryLite(registry.getAddress("SANTA_ELENA_REGISTRY")); 
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
