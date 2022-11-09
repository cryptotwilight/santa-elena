// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SEERC1155.sol";
import "../interfaces/ISEMinter.sol";
import "../interfaces/ISERegistry.sol";
import "../interfaces/ISERegistryLite.sol";
import "../interfaces/ISEVersionedAddress.sol";

contract SEMinter is ISEMinter, ISEVersionedAddress {

    address administrator; 

    string constant name = "SANTA_ELENA_NFT_MINTER";
    uint256 constant version = 1; 

    string constant AUDIT_SUBMISSION_PROOF_MINTER = "AUDIT_SUBMISSION_PROOF_MINT_CONTRACT";
    string constant UPLOAD_MINTER                 = "UPLOAD_MINT_CONTRACT";
    string constant DECLARATION_MINTER            = "DECLARATION_MINT_CONTRACT";

    string [] MINT_CONTRACTS = [AUDIT_SUBMISSION_PROOF_MINTER, UPLOAD_MINTER, DECLARATION_MINTER];

    ISERegistryLite registry; 
    ISERegistry mintRegistry; 
    
    string [] minterName; 
    mapping(string=>bool) minterConfigured; 
    mapping(string=>address) mintContractByName; 
    mapping(address=>bool) authorisedMinters; 

    constructor(address _admin, address _registry) {
        administrator = _admin; 
        registry = ISERegistryLite(_registry);
        for(uint256 x = 0; x < MINT_CONTRACTS.length; x++) {
            string memory n = MINT_CONTRACTS[x];
            setMintContract(n, registry.getAddress(name));
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

    function mintDeclaration(string memory _auditorSeal, address _holder ) external returns (address _erc1155, uint256 _nftId){
        require(registry.isKnown(msg.sender), " registered only ");
        _erc1155 = mintContractByName[DECLARATION_MINTER];        
        SEERC1155 seerc1155_ = SEERC1155(_erc1155);
        _nftId = seerc1155_.mint(_holder, _auditorSeal);
        return(_erc1155, _nftId);
    }

    function mintUploadProof(address _uploader, string memory _manifestUri) external returns (address _erc1155, uint256 _nftId){
        require(authorisedMinters[msg.sender], " authorised only ");
        _erc1155 = mintContractByName[UPLOAD_MINTER]; 
        SEERC1155 seerc1155_ = SEERC1155(_erc1155);
        _nftId = seerc1155_.mint(_uploader, _manifestUri);
        return(_erc1155, _nftId);
    }

    function mintAuditSubmissionProof(address _auditor, string memory _manifestUri) external returns (address _erc1155, uint256 _nftId){
        require(registry.isKnown(msg.sender), " registered only ");
        _erc1155 = mintContractByName[AUDIT_SUBMISSION_PROOF_MINTER]; 
        SEERC1155 seerc1155_ = SEERC1155(_erc1155);
        _nftId = seerc1155_.mint(_auditor, _manifestUri);
        return(_erc1155, _nftId);
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
        registry = ISERegistryLite(registry.getAddress("SANTA_ELENA_REGISTRY"));
        for(uint256 x = 0; x < MINT_CONTRACTS.length; x++) {
            string memory n = MINT_CONTRACTS[x];
            setMintContract(n, registry.getAddress(name));
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