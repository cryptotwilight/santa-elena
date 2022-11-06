// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SEERC1155.sol";
import "../interfaces/ISEMinter.sol";
import "../interfaces/ISERegistry.sol";

contract SEMinter is ISEMinter {

    address administrator; 

    string constant AUDIT_SUBMISSION_PROOF_MINTER = "AUDIT_SUBMISSION_PROOF_MINTER";
    string constant UPLOAD_MINTER                 = "UPLOAD_MINTER";
    string constant DECLARATION_MINTER            = "DECLARATION_MINTER";

    ISERegistry registry; 

    string [] minterName; 
    mapping(string=>bool) minterConfigured; 
    mapping(string=>address) mintContractByName; 
    mapping(address=>bool) authorisedMinters; 

    constructor(address _admin) {
        administrator = _admin; 
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

    function setRegistry(address _registry) external returns (bool _set) {
        adminOnly();
        registry = ISERegistry(_registry);
        return true; 
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

    function setMintContract(string memory _name, address _mintContract) external returns (bool _set){
        adminOnly();
        if(!minterConfigured[_name]){
             minterName.push(_name);
             minterConfigured[_name] = true; 
        }
        mintContractByName[_name] = _mintContract;
        return true; 
    }

    function setAdministrator(address _address) external returns (bool) {
        adminOnly();
        administrator = _address; 
        return true; 
    }

    //============================================= INTERNAL ===================================================

    function adminOnly() view internal returns (bool _admin) { 
        require(msg.sender == administrator, " admin only ");
        return true; 
    }
}