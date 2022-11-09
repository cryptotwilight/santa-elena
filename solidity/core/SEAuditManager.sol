// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../interfaces/ISEAuditManager.sol";
import "../interfaces/ISEAuditManagerNotification.sol";
import "../interfaces/ISEAuditContractFactory.sol";
import "../interfaces/ISEMinter.sol";
import "../interfaces/ISERegistryLite.sol";
import "../interfaces/ISEVersionedAddress.sol";

contract SEAuditManager is ISEAuditManager, ISEAuditManagerNotification, ISEVersionedAddress { 

    string constant name = "SANTA_ELENA_AUDIT_MANAGER";
    uint256 constant version = 1; 
    ISERegistryLite registry; 
    ISEAuditContractFactory factory; 
    ISEMinter minter;
    
    address self; 
    address administrator; 

    mapping(string=>address[]) auditContractsByStatus; 
    mapping(address=>address[]) auditContractsByUser;
    mapping(address=>string) currentStatusByAuditContractAddress;

    constructor(address _administrator, address _registry) {
        administrator = _administrator; 
        registry = ISERegistryLite(_registry); 
        factory = ISEAuditContractFactory(registry.getAddress("SANTA_ELENA_AUDIT_CONTRACT_FACTORY"));
        minter = ISEMinter(registry.getAddress("SANTA_ELENA_NFT_MINTER"));
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function uploadFiles(ISEAuditContract.AuditSeed memory _seed, string [] memory _urisToAudit, string [] memory _uriLabels, bool [] memory _private, string memory _notesUri, string memory manifestUri) external returns (address _auditContract){
        (address erc1155_, uint256 nftId_) = minter.mintUploadProof(msg.sender, manifestUri);
        _auditContract = factory.createAuditContract(_seed, _urisToAudit, _uriLabels,  _private, _notesUri, self, address(minter), erc1155_,nftId_ );    
        auditContractsByStatus["READY"].push(_auditContract);
        auditContractsByUser[msg.sender].push(_auditContract);
        return _auditContract;
    }

    function getPublicAuditContracts() view external returns (address [] memory _auditContracts){
        return auditContractsByStatus["PUBLIC"];
    }

    function getAuditContractsWithStatus(string memory _status) view external returns (address [] memory _auditContracts){
        return auditContractsByStatus[_status];
    }

    function getContractsUnderAuditor(address _auditor) view external returns (address [] memory _auditContracts) {
        address [] memory addresses = auditContractsByStatus["BOOKED_FOR_AUDIT"];
        uint256 y = 0;
        for(uint256 x = 0; x < addresses.length; x++) {
            ISEAuditContract iseac_ = ISEAuditContract(addresses[x]);
            if(iseac_.getAuditSeed().auditor == _auditor){
                _auditContracts[y] = addresses[x];
            }
        }
        return _auditContracts;
    }

    function getPublicAuditContractsForUser(address _user) view external returns (address [] memory _auditContracts){
        address [] memory addresses = auditContractsByUser[_user];
        _auditContracts = new address[](addresses.length);
        uint256 y = 0; 
        for(uint256 x = 0; x < addresses.length; x++){
            ISEAuditContract ac = ISEAuditContract(addresses[x]);
            if(equal(ac.getStatus(), "PUBLIC")){
                _auditContracts[y] = addresses[x];
                y++;
            }
        }
        return _auditContracts;
    }

    function getUserAuditContracts() view external returns (address [] memory _auditContracts){
        return auditContractsByUser[msg.sender];
    }

    function notifyStatus(address _auditContract, string memory _status) external returns (bool _recieved){
        require(factory.isKnown(msg.sender), " unknown address ");
        string memory status_ = currentStatusByAuditContractAddress[_auditContract];
        address [] memory acs_ = auditContractsByStatus[status_];
        auditContractsByStatus[status_] = remove(acs_, _auditContract);
        auditContractsByStatus[_status].push(_auditContract);
        return true; 
    }

    function notifyChangeOfAddress() external returns (bool _notified) {
        adminOnly(); 
        registry = ISERegistryLite(registry.getAddress("SANTA_ELENA_REGISTRY")); 
        factory = ISEAuditContractFactory(registry.getAddress("SANTA_ELENA_AUDIT_CONTRACT_FACTORY"));
        minter = ISEMinter(registry.getAddress("SANTA_ELENA_MINTER"));
        return true; 
    }

//================================================ INTERNAL =========================================================================================
    function adminOnly() view internal returns (bool _admin) { 
        require(msg.sender == administrator, " admin only ");
        return true; 
    }

    function equal(string memory _a, string memory _b) pure internal returns (bool _equal) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    function remove(address [] memory a, address b) pure internal returns ( address [] memory c) {
        c = new address[](a.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < a.length; x++){
            address d = a[x];
            if(d != b) {
                c[y] = d;
                y++;
            }
        }
        return c; 
    }
}