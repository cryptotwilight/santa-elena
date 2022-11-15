// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
/**
 * @title ISEAudit Contract 
 * @dev The ISEAuditContract is responsible for the audit coordination required between the documnt submitter and the auditor. 
 * It works by surfacing the documents that are to be audited and then enabling the auditor to submit their audit declaration and their audit report recieved as an ipfs uri 
 * In the background Proof NFTs are created on upload and on audit submission 
 * The audited entity has the right to withdraw the audit at any point except after publication. 
 * The audited entity also has the rright to decide whether to publish the audit or not. 
 * The auditor and the audited entity have access to all information presented for audit
 * The published audit only reveals data that has been declared public by the audited entity. 
 */

interface ISEAuditContract {
    /*@dev NFT proofs of upload and audit*/
    enum PROOF {UPLOAD, AUDIT}
    /*@dev audit state to transition to, "BOOKED_FOR_AUDIT" can be triggered by anyone, PUBLIC & WITHDRAWN can only be triggered by the audited entity*/
    enum AUDIT_STATE{READY, BOOKED_FOR_AUDIT, AUDIT_COMPLETE, AUDIT_SEALED, PUBLIC, WITHDRAWN}
    /*@dev audit declaration presented by the auditor*/
    enum AUDIT_DECLARATION {SATISFIED, NOT_SATISFIED}

    /*@dev primary metadata for the audit contract*/
    struct AuditSeed {
        /*@dev name of the audited entity*/
        string ownerName;
        /*@dev onchain address of the owner*/ 
        address owner; 
        /*@dev title of this audit */
        string auditTitle; 
        /*@dev date audit was uploaded*/
        uint256 uploadDate; 
        /*@dev maximum time allowed to audit after booking*/
        uint256 maxAuditWindow; 
        /*@dev date that audit was started*/
        uint256 auditStart; 
        /*@dev date that audit was completed*/
        uint256 auditDate;
        /*@dev date that this audit was published */
        uint256 publishDate; 
        /*dev date the validity of this audit expires */
        uint256 expires; 
        /*dev onchain address of the auditor */
        address auditor; 
        /*@dev name of the auditor */
        string auditorName; 
        /*@dev amount of carbon offset */
        uint256 carbonOffSet; 

    }
    /** @dev this is a representation of the uri that is audited */ 
    struct AuditUri { 
        /** @dev ipfs uri */
        string uri; 
        /** @dev label for the uri */
        string label; 
        /** @dev whether the uri is private or not */
        bool isPrivate; 
    }

    struct Proof {
        PROOF proof; 
        address erc1155;
        uint256 nftId;
    }

    /** @dev this is a representation of the Seal confered by the auditor to the report */
    struct Seal { 
        /* NFT contract containing the SEAL uri */
        address erc1155; 
        /* NFT id containing the SEAL manifest uri */
        uint256 nftId;
    }
    /**
     * @dev this returns the current status of the audit 
     * @return _status status of the audit  
     */
    function getStatus() view external returns (string memory _status);

    /** 
     * @dev this returns the URI for the audit report 
     * @return _auditReportUri uri for the audit report 
     * @return _declaration delaration as to whetehr this report is satisfactory or not
     */
    function getAuditReport() view external returns (string memory _auditReportUri, AUDIT_DECLARATION _declaration);

    /**
     * @dev this returns the erc1155 nfts where proofs have been minted 
     * @return _erc1155 contract where proof is stored 
     * @return _nftId NFT proof 
     */
    function getProofs(PROOF _proof) view external returns (address _erc1155, uint256 _nftId);

    /**
     * @dev this function enables the auditor to submit their audit report and their audit declaration
     * @param _auditReportUri audit report on data contained in this contract
     * @param _manifestUri manifest containing information about the audit report and used to mint proof
     * @return _submitted true if the report is successfully submitted
     */
    function submitAuditReport(string memory _auditReportUri, string memory _manifestUri) external returns (bool _submitted);

    /**
     * @dev this function returns all the URIs to audit as well as indications on data privacy.      
     * @return _auditUris that are to be audited both public and private
     * @return _notesUri notes on the presented data
     */
    function getUrisToAudit() view external returns (AuditUri [] memory _auditUris, string memory _notesUri);

    /**
     * @dev this function returns all public data for this audit 
     * @return _publicAuditUris data that is public for this audit
     */
    function getPublicData() view external returns (AuditUri [] memory _publicAuditUris);

    /** 
     * @dev this returns the audit seed which contains the primary metadata for this audit
     * @return _seed primary metadata for this audit 
     */
    function getAuditSeed() view external returns (AuditSeed memory _seed);

    /**
     * @dev this enables an auditor to book an audit 
     * @param _auditorName name of the auditor 
     * @return _booked true if successfully booked
     */
    function bookForAudit(string memory _auditorName) external returns ( bool _booked);

    /**
     * @dev this returns the end time for the audit based on the max window, the audit is expected to end well before this
     * @return _auditEndTime end time for the audit 
     */
    function getEstimatedAuditEndTime() view external returns (uint256 _auditEndTime);

    /** 
     * @dev this function is executed by the auditor when they move to SEAL the audit contract, and make a declaration on the contents
     * @param _declaration declaration as to whether the auditor is satisfied with the contents of the AuditContract for the claim 
     * @param _auditorSealManifestUri uri to manifest containing auditor SEAL information 
     * @return _sealed true if the audit contract is successfully sealed
     */
    function declareAndSealReport(AUDIT_DECLARATION _declaration, string memory _auditorSealManifestUri) external returns (bool _sealed);

    /**
     * @dev this makes this audit contract's public data public. This can only be executed by the owner and the contract must have a completed audit
     * @return _done if successfully made public 
     */
    function makePublic() external returns (bool _done);

    /**
     * @dev this withdraws this audit contract from Santa Elena. The contract cannot be reinstated 
     * return _withdrawn true if the contract is withdrawn 
     */ 
    function withdraw() external returns (bool _withdrawn);

}// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
/**
 * @title ISEAudit Contract 
 * @dev The ISEAuditContract is responsible for the audit coordination required between the documnt submitter and the auditor. 
 * It works by surfacing the documents that are to be audited and then enabling the auditor to submit their audit declaration and their audit report recieved as an ipfs uri 
 * In the background Proof NFTs are created on upload and on audit submission 
 * The audited entity has the right to withdraw the audit at any point except after publication. 
 * The audited entity also has the rright to decide whether to publish the audit or not. 
 * The auditor and the audited entity have access to all information presented for audit
 * The published audit only reveals data that has been declared public by the audited entity. 
 */

interface ISEAuditContract {
    /*@dev NFT proofs of upload and audit*/
    enum PROOF {UPLOAD, AUDIT}
    /*@dev audit state to transition to, "BOOKED_FOR_AUDIT" can be triggered by anyone, PUBLIC & WITHDRAWN can only be triggered by the audited entity*/
    enum AUDIT_STATE{READY, BOOKED_FOR_AUDIT, AUDIT_COMPLETE, AUDIT_SEALED, PUBLIC, WITHDRAWN}
    /*@dev audit declaration presented by the auditor*/
    enum AUDIT_DECLARATION {SATISFIED, NOT_SATISFIED}

    /*@dev primary metadata for the audit contract*/
    struct AuditSeed {
        /*@dev name of the audited entity*/
        string ownerName;
        /*@dev onchain address of the owner*/ 
        address owner; 
        /*@dev title of this audit */
        string auditTitle; 
        /*@dev date audit was uploaded*/
        uint256 uploadDate; 
        /*@dev maximum time allowed to audit after booking*/
        uint256 maxAuditWindow; 
        /*@dev date that audit was started*/
        uint256 auditStart; 
        /*@dev date that audit was completed*/
        uint256 auditDate;
        /*@dev date that this audit was published */
        uint256 publishDate; 
        /*dev date the validity of this audit expires */
        uint256 expires; 
        /*dev onchain address of the auditor */
        address auditor; 
        /*@dev name of the auditor */
        string auditorName; 
        /*@dev amount of carbon offset */
        uint256 carbonOffSet; 

    }
    /** @dev this is a representation of the uri that is audited */ 
    struct AuditUri { 
        /** @dev ipfs uri */
        string uri; 
        /** @dev label for the uri */
        string label; 
        /** @dev whether the uri is private or not */
        bool isPrivate; 
    }

    struct Proof {
        PROOF proof; 
        address erc1155;
        uint256 nftId;
    }

    /** @dev this is a representation of the Seal confered by the auditor to the report */
    struct Seal { 
        /* NFT contract containing the SEAL uri */
        address erc1155; 
        /* NFT id containing the SEAL manifest uri */
        uint256 nftId;
    }
    /**
     * @dev this returns the current status of the audit 
     * @return _status status of the audit  
     */
    function getStatus() view external returns (string memory _status);

    /** 
     * @dev this returns the URI for the audit report 
     * @return _auditReportUri uri for the audit report 
     * @return _declaration delaration as to whetehr this report is satisfactory or not
     */
    function getAuditReport() view external returns (string memory _auditReportUri, AUDIT_DECLARATION _declaration);

    /**
     * @dev this returns the erc1155 nfts where proofs have been minted 
     * @return _erc1155 contract where proof is stored 
     * @return _nftId NFT proof 
     */
    function getProofs(PROOF _proof) view external returns (address _erc1155, uint256 _nftId);

    /**
     * @dev this function enables the auditor to submit their audit report and their audit declaration
     * @param _auditReportUri audit report on data contained in this contract
     * @param _manifestUri manifest containing information about the audit report and used to mint proof
     * @return _submitted true if the report is successfully submitted
     */
    function submitAuditReport(string memory _auditReportUri, string memory _manifestUri) external returns (bool _submitted);

    /**
     * @dev this function returns all the URIs to audit as well as indications on data privacy.      
     * @return _auditUris that are to be audited both public and private
     * @return _notesUri notes on the presented data
     */
    function getUrisToAudit() view external returns (AuditUri [] memory _auditUris, string memory _notesUri);

    /**
     * @dev this function returns all public data for this audit 
     * @return _publicAuditUris data that is public for this audit
     */
    function getPublicData() view external returns (AuditUri [] memory _publicAuditUris);

    /** 
     * @dev this returns the audit seed which contains the primary metadata for this audit
     * @return _seed primary metadata for this audit 
     */
    function getAuditSeed() view external returns (AuditSeed memory _seed);

    /**
     * @dev this enables an auditor to book an audit 
     * @param _auditorName name of the auditor 
     * @return _booked true if successfully booked
     */
    function bookForAudit(string memory _auditorName) external returns ( bool _booked);

    /**
     * @dev this returns the end time for the audit based on the max window, the audit is expected to end well before this
     * @return _auditEndTime end time for the audit 
     */
    function getEstimatedAuditEndTime() view external returns (uint256 _auditEndTime);

    /** 
     * @dev this function is executed by the auditor when they move to SEAL the audit contract, and make a declaration on the contents
     * @param _declaration declaration as to whether the auditor is satisfied with the contents of the AuditContract for the claim 
     * @param _auditorSealManifestUri uri to manifest containing auditor SEAL information 
     * @return _sealed true if the audit contract is successfully sealed
     */
    function declareAndSealReport(AUDIT_DECLARATION _declaration, string memory _auditorSealManifestUri) external returns (bool _sealed);

    /**
     * @dev this makes this audit contract's public data public. This can only be executed by the owner and the contract must have a completed audit
     * @return _done if successfully made public 
     */
    function makePublic() external returns (bool _done);

    /**
     * @dev this withdraws this audit contract from Santa Elena. The contract cannot be reinstated 
     * return _withdrawn true if the contract is withdrawn 
     */ 
    function withdraw() external returns (bool _withdrawn);

}