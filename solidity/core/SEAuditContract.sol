// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/c7315e8779dd4ca363bef85d6c3a455e83fb574e/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";

import "../interfaces/ISEMinter.sol";

import "../interfaces/ISEAuditContract.sol";
import "../interfaces/ISEAuditManagerNotification.sol";


contract SEAuditContract is ISEAuditContract { 
    
    address self; 
    struct Proof {
        PROOF proof; 
        address erc1155;
        uint256 nftId;
    }

    mapping(PROOF=>Proof) proofByPROOF; 
    mapping(bool=>string[]) auditUriByPrivacy; 

    AUDIT_STATE state; 
    AUDIT_DECLARATION declaration;
    
    string auditReport; 
    string [] urisToAudit;
    bool [] uriPrivate; 
    string notesUri;

    AuditSeed seed; 
    ISEAuditManagerNotification notifier; 
    ISEMinter minter;

    constructor(AuditSeed memory _seed, 
                string[] memory _urisToAudit, 
                bool [] memory _uriPrivacy, 
                string memory _notesUri, 
                address _auditManagerNotification,
                address _minter, 
                address _uploadProofErc1155, 
                uint256 _uploadProofNftId) {
        self = address(this);
        seed = _seed; 
        notifier = ISEAuditManagerNotification(_auditManagerNotification);
        urisToAudit = _urisToAudit;
        uriPrivate = _uriPrivacy;
        notesUri = _notesUri;
        state = AUDIT_STATE.READY;
        minter = ISEMinter(_minter);
        for(uint256 x =0; x < urisToAudit.length; x++){
            if(_uriPrivacy[x]) {
                auditUriByPrivacy[true].push(_urisToAudit[x]);
            }
            else {
                auditUriByPrivacy[false].push(_urisToAudit[x]);
            }
        }
        Proof memory proof_ = Proof ({
                                    proof : PROOF.UPLOAD,
                                    erc1155 : _uploadProofErc1155,
                                    nftId : _uploadProofNftId
                                });
        proofByPROOF[PROOF.UPLOAD] = proof_;
    }

    function getStatus() view external returns (string memory _status){
        return getStatusInternal(); 
    }


    function getAuditReport() view external returns (string memory _auditReportUri, AUDIT_DECLARATION _declaration){
        return (auditReport, declaration); 
    }


    function getProofs(PROOF _proof) view external returns (address _erc1155, uint256 _nftId){
        Proof memory proof_ = proofByPROOF[_proof];
        return (proof_.erc1155, proof_.nftId);
    }

    function submitAuditReport( string memory _auditReportUri, 
                                AUDIT_DECLARATION _declaration, 
                                string memory _auditorSealUri, string memory _manifestUri) external returns (bool _submitted){
        require(msg.sender == seed.auditor, " auditor only ");
        auditReport = _auditReportUri;
        declaration = _declaration;
        seed.auditDate = block.timestamp; 
        state = AUDIT_STATE.AUDIT_COMPLETE;
        // mint 
        minter.mintDeclaration(_auditorSealUri, self);
        (address erc1155_, uint256 nftId_) = minter.mintAuditSubmissionProof(msg.sender, _manifestUri);
        Proof memory proof_ = Proof ({
                                    proof : PROOF.AUDIT,
                                    erc1155 : erc1155_,
                                    nftId : nftId_
                                });
        proofByPROOF[PROOF.AUDIT] = proof_;
        notifier.notifyStatus(self, getStatusInternal());
        return true; 
    }


    function getUrisToAudit() view external returns (string [] memory _urisToAudit, bool [] memory _private, string memory _notesUri){
        require(msg.sender == seed.owner || msg.sender == seed.auditor, " auditor / owner only ");
        return (urisToAudit, uriPrivate, notesUri);
    }


    function getPublicData() view external returns (string [] memory _publicDataUris){
        require(state == AUDIT_STATE.PUBLIC," audit not public " );
        return auditUriByPrivacy[false];
    }

    function makePublic() external returns (bool _done) {
        require(msg.sender == seed.owner, " owner only ");
        require(state == AUDIT_STATE.AUDIT_COMPLETE, " no complete audit ");
        state = AUDIT_STATE.PUBLIC;
        notifier.notifyStatus(self, getStatusInternal());
        return true; 
    }

    function bookForAudit(string memory _auditorName) external returns ( bool _booked) {
        require(state != AUDIT_STATE.AUDIT_COMPLETE, " audit already completed ");
        require(state != AUDIT_STATE.BOOKED_FOR_AUDIT || isAuditTimeExpired(), " booking not available ");
        state = AUDIT_STATE.BOOKED_FOR_AUDIT;
        seed.auditorName = _auditorName; 
        seed.auditor = msg.sender;
        seed.auditStart = block.timestamp; 
        notifier.notifyStatus(self, getStatusInternal());
        return true; 
    }
  
    function getAuditEndTime() view external returns (uint256 _auditEndTime){
       return getAuditEndTimeInternal();
    }

    function getAuditSeed() view external returns (AuditSeed memory _seed){
        return seed; 
    }

    //==================================== INTERNAL ====================================================================================

    function getStatusInternal() view internal returns ( string memory _status) {
        if(state == AUDIT_STATE.AUDIT_COMPLETE){
            return "AUDIT_COMPETE";
        }

        if(state == AUDIT_STATE.BOOKED_FOR_AUDIT){
            if(isAuditTimeExpired()){
                return "AUDIT_TIME_EXPIRED";
            }
            return "BOOKED_FOR_AUDIT";
        }

        if(state == AUDIT_STATE.READY){
            return "AWAITING_AUDIT";
        }

        if(state == AUDIT_STATE.PUBLIC){
            return "PUBLIC";
        }

        if(state == AUDIT_STATE.WITHDRAWN){
            return "WITHDRAWN";
        }
        
        return "UNKNOWN";
    }

    function isAuditTimeExpired() view internal returns (bool _isExpired) {
        return getAuditEndTimeInternal() < block.timestamp; 
    }

    function getAuditEndTimeInternal() view internal returns (uint256 _endTime) {
         require(seed.auditStart > 0 , "audit not started");
        return seed.auditStart + seed.maxAuditWindow; 
    }

    function equal(string memory _a, string memory _b) pure internal returns (bool _equal) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }
}