// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "../interfaces/ISEAuditManager.sol";
import "../interfaces/ISEAuditManagerNotification.sol";
import "../interfaces/ISEAuditContractFactory.sol";
import "../interfaces/ISEMintable.sol";
import "../interfaces/ISERegistry.sol";
import "../interfaces/ISEVersionedAddress.sol";

contract SEAuditManager is ISEAuditManager, ISEAuditManagerNotification, ISEVersionedAddress { 

    string constant name = "RESERVED_SANTA_ELENA_AUDIT_MANAGER";
    uint256 constant version = 18; 

    string constant SANTA_ELENA_REGISTRY_CA                 = "RESERVED_SANTA_ELENA_REGISTRY";
    string constant SANTA_ELENA_AUDIT_CONTRACT_FACTORY_CA   = "RESERVED_SANTA_ELENA_AUDIT_CONTRACT_FACTORY";
    string constant UPLOAD_MINTER_CA                        = "RESERVED_UPLOAD_PROOF_MINT_CONTRACT";

    ISERegistry registry; 
    ISEAuditContractFactory factory; 
    
    
    address self; 
    address administrator; 

    mapping(string=>address[]) auditContractsByStatus; 
    mapping(address=>address[]) auditContractsByUser;
    mapping(address=>string) currentStatusByAuditContractAddress;

    constructor(address _administrator, address _registry) {
        administrator = _administrator; 
        registry = ISERegistry(_registry); 
        factory = ISEAuditContractFactory(registry.getAddress(SANTA_ELENA_AUDIT_CONTRACT_FACTORY_CA));        
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }


    function uploadFiles(string memory _ownerName, 
                        string memory _auditTitle, 
                        uint256 _maxAuditWindow, 
                        uint256 _carbonOffSet, 
                        string [] memory _urisToAudit, 
                        string [] memory _uriLabels, 
                        bool [] memory _private, 
                        string memory _notesUri, 
                        string memory _uploadManifestUri) external returns (address _auditContract){
        ISEAuditContract.AuditSeed memory _seed = generateSeed(_ownerName, 
                                                                msg.sender, 
                                                                _auditTitle, 
                                                                block.timestamp, 
                                                                _maxAuditWindow, 
                                                                _carbonOffSet);
        
        ISEMintable mintable_ = ISEMintable(registry.getAddress(UPLOAD_MINTER_CA));
        uint256 nftId_ = mintable_.mint(msg.sender, _uploadManifestUri);
        _auditContract = factory.createAuditContract(_seed, _urisToAudit, _uriLabels,  _private, _notesUri, address(mintable_),nftId_ );    
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
        address [] memory addresses_ = auditContractsByStatus["BOOKED_FOR_AUDIT"];
        _auditContracts = new address[](addresses_.length);
        uint256 y = 0;
        for(uint256 x = 0; x < addresses_.length; x++) {
            ISEAuditContract iseac_ = ISEAuditContract(addresses_[x]);
            if(iseac_.getAuditSeed().auditor == _auditor){
                _auditContracts[y] = addresses_[x];
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
        if(!equal(_status, "AWAITING_AUDIT")){        
            string memory status_ = currentStatusByAuditContractAddress[_auditContract];
            address [] memory acs_ = auditContractsByStatus[status_];
            auditContractsByStatus[status_] = remove(acs_, _auditContract);            
        }
        auditContractsByStatus[_status].push(_auditContract);        
        currentStatusByAuditContractAddress[_auditContract] = _status; 
        return true; 
    }

    function notifyChangeOfAddress() external returns (bool _notified) {
        adminOnly(); 
        registry = ISERegistry(registry.getAddress(SANTA_ELENA_REGISTRY_CA)); 
        factory = ISEAuditContractFactory(registry.getAddress(SANTA_ELENA_AUDIT_CONTRACT_FACTORY_CA));        
        return true; 
    }

//================================================ INTERNAL =========================================================================================
        function generateSeed(       
                                string memory _ownerName,
                                address _owner,        
                                string memory _auditTitle,        
                                uint256 _uploadDate,        
                                uint256 _maxAuditWindow,                                        
                                uint256 _carbonOffSet ) pure internal returns (ISEAuditContract.AuditSeed memory _seed){
            return  ISEAuditContract.AuditSeed({
                                                ownerName      : _ownerName,
                                                owner          :  _owner, 
                                                auditTitle     : _auditTitle, 
                                                uploadDate     : _uploadDate,         
                                                maxAuditWindow : _maxAuditWindow, 
                                                auditStart     : 0,  
                                                auditDate      : 0,         
                                                publishDate    : 0, 
                                                expires        : 0,
                                                auditor        : address(0),         
                                                auditorName    : "",
                                                carbonOffSet   : _carbonOffSet 
                                            });
                                
        }
    
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
                if(y == c.length){
                    return a; // element not found 
                }            
                c[y] = d;
                y++;
            }
        }
        return c; 
    }
}