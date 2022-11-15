// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/b2970b96e5e2be297421cd7690e3502e49f7deff/contracts/token/ERC1155/IERC1155Receiver.sol"; 


import "../interfaces/ISEMintable.sol";
import "../interfaces/ISERegistry.sol";
import "../interfaces/ISEVersionedAddress.sol";
import "../interfaces/ISEAuditContract.sol";
import "../interfaces/ISEAuditManagerNotification.sol";


contract SEAuditContract is ISEAuditContract, ISEVersionedAddress, IERC1155Receiver { 
    
    address self; 
   
    mapping(PROOF=>Proof) proofByPROOF; 
    mapping(bool=>string[]) auditUriByPrivacy; 
    mapping(string=>AuditUri) auditUriByUri; 

    AUDIT_STATE state; 
    AUDIT_DECLARATION declaration;
    
    string auditReport; 
    string [] uris; 
    string notesUri;
    Seal seal; 


    string constant name = "SANTA ELENA AUDIT CONTRACT";
    uint256 constant version = 25; 

    string constant SANTA_ELENA_NOTIFICATION_CA             = "RESERVED_SANTA_ELENA_AUDIT_MANAGER"; 
    string constant SANTA_ELENA_MINTER_CA                   = "RESERVED_SANTA_ELENA_MINTER";
    string constant AUDIT_SUBMISSION_PROOF_MINTER_CA        = "RESERVED_AUDIT_SUBMISSION_PROOF_MINT_CONTRACT";
    string constant DECLARATION_MINTER_CA                   = "RESERVED_DECLARATION_SEAL_MINT_CONTRACT";

    AuditSeed seed; 
    ISERegistry registry; 

    constructor(AuditSeed memory _seed, 
                string[] memory _urisToAudit,
                string [] memory _uriLabels,  
                bool [] memory _uriPrivacy, 
                string memory _notesUri, 
                address _register, 
                address _uploadProofErc1155, 
                uint256 _uploadProofNftId) {

        self = address(this);
        seed = _seed; 
        registry = ISERegistry(_register);         
        uris = _urisToAudit; 
        mapAuditUris(_urisToAudit, _uriLabels, _uriPrivacy);
        notesUri = _notesUri;
        state = AUDIT_STATE.READY;        
        for(uint256 x =0; x < _urisToAudit.length; x++){
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

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getStatus() view external returns (string memory _status){
        return getStatusInternal(); 
    }
    
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4){
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4){
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool){
        return true; 
    }

    function getAuditReport() view external returns (string memory _auditReportUri, AUDIT_DECLARATION _declaration){
        return (auditReport, declaration); 
    }

    function getSeal() view external returns (Seal memory _seal) {
        return seal; 
    }

    function getProofs(PROOF _proof) view external returns (address _erc1155, uint256 _nftId){
        Proof memory proof_ = proofByPROOF[_proof];
        return (proof_.erc1155, proof_.nftId);
    }

    function declareAndSealReport(AUDIT_DECLARATION _declaration, string memory _auditorSealManifestUri) external returns (bool _sealed) {
        require(msg.sender == seed.auditor, " auditor only ");
        declaration = _declaration;        
        state = AUDIT_STATE.AUDIT_SEALED;
        ISEMintable mintable_ = ISEMintable(registry.getAddress(DECLARATION_MINTER_CA)); 
        uint256 nftIdSeal_ = mintable_.mint(self, _auditorSealManifestUri);
        seal = Seal({
                        erc1155 : address(mintable_),
                        nftId : nftIdSeal_
                    });
        ISEAuditManagerNotification(registry.getAddress(SANTA_ELENA_NOTIFICATION_CA)).notifyStatus(self, getStatusInternal());
        return true; 
    }

    function submitAuditReport( string memory _auditReportUri, string memory _auditSubmissionManifestUri) external returns (bool _submitted){
        require(msg.sender == seed.auditor, " auditor only ");
         // mint         
        ISEMintable mintable_       = ISEMintable(registry.getAddress(AUDIT_SUBMISSION_PROOF_MINTER_CA));                                
        uint256 nftIdSubmission_    = mintable_.mint(msg.sender, _auditSubmissionManifestUri);    
        Proof memory proof_         = Proof ({
                                            proof : PROOF.AUDIT,
                                            erc1155 : address(mintable_),
                                            nftId : nftIdSubmission_
                                        });
        proofByPROOF[PROOF.AUDIT]   = proof_;
        auditReport = _auditReportUri;        
        
        updateSeed(seed.ownerName, seed.owner, seed.auditTitle, seed.uploadDate, 
                    seed.maxAuditWindow, seed.auditStart, block.timestamp, 0, 
                    seed.expires, seed.auditor, seed.auditorName, seed.carbonOffSet); 

        state = AUDIT_STATE.AUDIT_COMPLETE;
        ISEAuditManagerNotification(registry.getAddress(SANTA_ELENA_NOTIFICATION_CA)).notifyStatus(self, getStatusInternal());

        return true; 
    }


    function getUrisToAudit() view external returns (AuditUri [] memory _auditUris, string memory _notesUri){
        require(msg.sender == seed.owner || msg.sender == seed.auditor, " auditor / owner only ");
        return (getAuditUris(uris), notesUri);
    }
 

    function getPublicData() view external returns (AuditUri [] memory _publicAuditUris){
        require(state == AUDIT_STATE.PUBLIC," audit not public " );
        return getAuditUris(auditUriByPrivacy[false]);
    }

    function makePublic() external returns (bool _done) {
        require(msg.sender == seed.owner, " owner only ");
        require(state == AUDIT_STATE.AUDIT_SEALED, " non-sealed audit ");
        state = AUDIT_STATE.PUBLIC;
        ISEAuditManagerNotification(registry.getAddress(SANTA_ELENA_NOTIFICATION_CA)).notifyStatus(self, getStatusInternal());
        return true; 
    }

    function bookForAudit(string memory _auditorName) external returns ( bool _booked) {
        require(state != AUDIT_STATE.AUDIT_COMPLETE, " audit already completed ");
        require(state != AUDIT_STATE.BOOKED_FOR_AUDIT || isAuditTimeExpired(), " booking not available ");
        state = AUDIT_STATE.BOOKED_FOR_AUDIT;
        uint256 expiry_ = block.timestamp + seed.maxAuditWindow;
        updateSeed(seed.ownerName, seed.owner, seed.auditTitle, seed.uploadDate, 
                    seed.maxAuditWindow, block.timestamp, 0, 0, expiry_, msg.sender, _auditorName, seed.carbonOffSet );

        
        string memory status_ = getStatusInternal(); 
        ISEAuditManagerNotification(registry.getAddress(SANTA_ELENA_NOTIFICATION_CA)).notifyStatus(self,status_ );
        return true; 
    }
  
    function withdraw() external returns (bool _withdrawn) {
        require(msg.sender == seed.owner, " owner only ");
        state = AUDIT_STATE.WITHDRAWN; 
        string memory status_ = getStatusInternal(); 
        ISEAuditManagerNotification(registry.getAddress(SANTA_ELENA_NOTIFICATION_CA)).notifyStatus(self,status_ );
        return true; 
    }

    function getEstimatedAuditEndTime() view external returns (uint256 _auditEndTime){
       return getAuditEndTimeInternal();
    }

    function getAuditSeed() view external returns (AuditSeed memory _seed){
        return seed; 
    }

    //==================================== INTERNAL ====================================================================================

    function updateSeed(string memory _ownerName, address _owner,  string memory _auditTitle, uint256 _uploadDate,        
                        uint256 _maxAuditWindow,  uint256 _auditStart,  uint256 _auditDate, 
                        uint256 _publishDate, uint256 _expires, address _auditor,  string memory _auditorName, uint256 _carbonOffSet ) internal returns (bool updated ){
        seed = AuditSeed({
                        ownerName      :  _ownerName,      
                        owner          :  _owner,       
                        auditTitle     :  _auditTitle,
                        uploadDate     :  _uploadDate,       
                        maxAuditWindow :  _maxAuditWindow,
                        auditStart     :  _auditStart,
                        auditDate      :  _auditDate,    
                        publishDate    :  _publishDate,
                        expires        :  _expires,        
                        auditor        :  _auditor, 
                        auditorName    :  _auditorName,
                        carbonOffSet   :  _carbonOffSet
        });
        return true; 
    }  

    function getStatusInternal() view internal returns ( string memory _status) {
        if(state == AUDIT_STATE.AUDIT_COMPLETE){
            return "AUDIT_COMPLETE";
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

        if(state == AUDIT_STATE.AUDIT_SEALED){
            return "SEALED";
        }

        if(state == AUDIT_STATE.PUBLIC){
            return "PUBLIC";
        }

        if(state == AUDIT_STATE.WITHDRAWN){
            return "WITHDRAWN";
        }
        
        return "UNKNOWN";
    }

    function getAuditUris(string [] memory _uris) view internal returns (AuditUri [] memory _auditUris) { 
        _auditUris = new AuditUri[](_uris.length);
        for(uint256 x = 0; x < _uris.length; x++) {
           _auditUris[x] = auditUriByUri[_uris[x]]; 
        }
        return _auditUris;                 
    }

    function mapAuditUris(string [] memory _uris, string [] memory _labels, bool [] memory _isPrivate) internal returns (bool _mapped) {        
        for(uint256 x = 0; x < _uris.length; x++) {
            string memory uri_ = _uris[x];
            AuditUri memory auditUri = AuditUri({
                                                    uri : uri_, 
                                                    label : _labels[x],
                                                    isPrivate : _isPrivate[x]
                                                });
            auditUriByUri[uri_] = auditUri; 
        }
        return true;         
    }

    function isAuditTimeExpired() view internal returns (bool _isExpired) {
        return getAuditEndTimeInternal() < block.timestamp; 
    }

    function getAuditEndTimeInternal() view internal returns (uint256 _endTime) {
        return seed.auditStart + seed.maxAuditWindow; 
    }

    function equal(string memory _a, string memory _b) pure internal returns (bool _equal) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }
}