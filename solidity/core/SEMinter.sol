// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SEERC1155.sol";
import "../interfaces/ISEMinter.sol";
import "../interfaces/ISERegistry.sol";
import "../interfaces/ISEAuditContractRegistry.sol";
import "../interfaces/ISEVersionedAddress.sol";

contract SEMinter is ISEMinter, ISEVersionedAddress {

    address administrator; 

    string constant name                                    = "RESERVED_SANTA_ELENA_MINTER";
    uint256 constant version                                = 11; 

    string constant SANTA_ELENA_REGISTRY_CA                 = "RESERVED_SANTA_ELENA_REGISTRY";
    string constant SANTA_ELENA_AUDIT_CONTRACT_REGISTRY_CA  = "RESERVED_SANTA_ELENA_AUDIT_CONTRACT_FACTORY"; // audit contract registry implementation
    string constant SANTA_ELENA_AUDIT_MANAGER_CA            = "RESERVED_SANTA_ELENA_AUDIT_MANAGER";

    string constant AUDIT_SUBMISSION_PROOF_MINTER_CA        = "RESERVED_AUDIT_SUBMISSION_PROOF_MINT_CONTRACT";
    string constant UPLOAD_MINTER_CA                        = "RESERVED_UPLOAD_PROOF_MINT_CONTRACT";
    string constant DECLARATION_MINTER_CA                   = "RESERVED_DECLARATION_SEAL_MINT_CONTRACT";

    string [] MINT_CONTRACTS = [AUDIT_SUBMISSION_PROOF_MINTER_CA, UPLOAD_MINTER_CA, DECLARATION_MINTER_CA];

    ISERegistry registry; 
    ISEAuditContractRegistry auditContractRegistry; 
    
    string [] minterName; 
    mapping(string=>bool) minterConfigured; 
    mapping(string=>address) mintContractByName; 
    mapping(address=>bool) authorisedMinters; 

    constructor(address _admin, address _registry) {
        
        administrator = _admin; 
        
        registry = ISERegistry(_registry);        
        auditContractRegistry = ISEAuditContractRegistry(registry.getAddress(SANTA_ELENA_AUDIT_CONTRACT_REGISTRY_CA));

        for(uint256 x = 0; x < MINT_CONTRACTS.length; x++) {
            string memory n = MINT_CONTRACTS[x];
            setMintContract(n, registry.getAddress(n));
        }
    }
    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }
    function getAdministrator() view external returns (address _admin) {
        return administrator; 
    }

    function getMinters() view external returns (address [] memory _minterAddress, string [] memory _minterName) {
        _minterAddress = new  address[](minterName.length);
        for(uint256 x = 0; x < minterName.length; x++) {
            string memory name_ = minterName[x];
            if(minterConfigured[name_]){
                _minterAddress[x] = mintContractByName[name_];
            }
            else { 
                _minterAddress[x] = address(0);
            }
        }
        return (_minterAddress, minterName);
    }

    function mintDeclaration(string memory _auditorSealManifestUri, address _auditContract ) external returns (address _erc1155, uint256 _nftId){
        require(authorisedMinters[msg.sender] || auditContractRegistry.isKnown(msg.sender), " registered only ");
        _erc1155 = mintContractByName[DECLARATION_MINTER_CA];        
        SEERC1155 seerc1155_ = SEERC1155(_erc1155);
     //   _nftId = seerc1155_.mint(_auditContract, _auditorSealManifestUri);
        return(_erc1155, _nftId);
    }

    function mintUploadProof(address _uploader, string memory _uploadManifestUri) external returns (address _erc1155, uint256 _nftId){
        require(authorisedMinters[msg.sender] || registry.getAddress(SANTA_ELENA_AUDIT_MANAGER_CA) == msg.sender, " authorised only ");
        _erc1155 = mintContractByName[UPLOAD_MINTER_CA]; 
        SEERC1155 seerc1155_ = SEERC1155(_erc1155);
        _nftId = seerc1155_.mint(_uploader, _uploadManifestUri);
        return(_erc1155, _nftId);
    }

    function mintAuditSubmissionProof(address _auditor, string memory _auditSubmissionManifestUri) external returns (address _erc1155, uint256 _nftId){
        require(authorisedMinters[msg.sender] || auditContractRegistry.isKnown(msg.sender), " registered only ");
        _erc1155 = mintContractByName[AUDIT_SUBMISSION_PROOF_MINTER_CA]; 
        SEERC1155 seerc1155_ = SEERC1155(_erc1155);
       // _nftId = seerc1155_.mint(_auditor, _auditSubmissionManifestUri); 
        return(_erc1155, _nftId);
    }


    function mintSealAndProof(address _auditor, string memory _auditSubmissionManifestUri, string memory _auditorSealManifestUri, address _auditContract) external returns (address _erc1155Seal, uint256 _nftIdSeal, address _erc1155Submission, uint256 _nftIdSubmission ){
        require(authorisedMinters[msg.sender] || auditContractRegistry.isKnown(msg.sender), " registered only ");
        _erc1155Submission = mintContractByName[AUDIT_SUBMISSION_PROOF_MINTER_CA]; 
        SEERC1155 seerc1155Submission_ = SEERC1155(_erc1155Submission);
        _nftIdSubmission = seerc1155Submission_.mint(_auditor, _auditSubmissionManifestUri); 

        _erc1155Seal = mintContractByName[DECLARATION_MINTER_CA];        
        SEERC1155 seerc1155Seal_ = SEERC1155(_erc1155Seal);
        _nftIdSeal = seerc1155Seal_.mint(_auditContract, _auditorSealManifestUri);
        return ( _erc1155Seal, _nftIdSeal, _erc1155Submission, _nftIdSubmission );
    }


    function addAuthorisedMinter(address _minter) external returns (bool _removed){
        adminOnly();
        authorisedMinters[_minter] = true; 
        return true; 

    }

    function removeAuthorisedMinter(address _minter) external returns (bool _removed) {
        adminOnly();
        delete authorisedMinters[_minter];
        return true; 
    }

    function setAdministrator(address _address) external returns (bool) {
        adminOnly();
        administrator = _address; 
        return true; 
    }

    function notifyChangeOfAddress() external returns (bool){
        adminOnly();
        registry = ISERegistry(registry.getAddress(SANTA_ELENA_REGISTRY_CA));
        auditContractRegistry = ISEAuditContractRegistry(registry.getAddress(SANTA_ELENA_AUDIT_CONTRACT_REGISTRY_CA));
        for(uint256 x = 0; x < MINT_CONTRACTS.length; x++) {
            string memory n = MINT_CONTRACTS[x];
            setMintContract(n, registry.getAddress(n));
        }
        return true; 
    }

    //============================================= INTERNAL ===================================================

    function setMintContract(string memory _name, address _mintContract) internal returns (bool _set){        
        if(_mintContract != address(0)) {
            if(!minterConfigured[_name] ){
                minterName.push(_name);
                minterConfigured[_name] = true; 
            }

            mintContractByName[_name] = _mintContract;        
            return true; 
        }
        return false; 
    }

    function adminOnly() view internal returns (bool _admin) { 
        require(msg.sender == administrator, " admin only ");
        return true; 
    }
}