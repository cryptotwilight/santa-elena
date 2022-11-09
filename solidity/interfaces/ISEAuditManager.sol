// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ISEAuditContract.sol";
/**
 * @title ISEManager
 * @dev the Santa Elena ISEManager is responsible for enabling audit data upload and audit contract creation. It also provides a means by which to search for audit contracts 
 *
 */
interface ISEAuditManager {
    /**
     * @dev this enables the upload of URI's onto the FEVM with indicatioins as to the privacy of the data
     * @param _seed primary metadata for the audit contract 
     * @param _urisToAudit list of uris to be audited
     * @param _private true if the uri contains private data
     * @param _notesUri explanatory notes on the uploaded data
     * @return _auditContract address of the audit contract 
     */
    function uploadFiles(ISEAuditContract.AuditSeed memory _seed, string [] memory _urisToAudit, string [] memory _uriLabels, bool [] memory _private, string memory _notesUri, string memory _manifestUri) external returns (address _auditContract);

    /**
     * @dev this retrieves all the public audit contract managed by this manager 
     * @return _auditContracts published auditContracts held by this manager
     */
    function getPublicAuditContracts() view external returns (address [] memory _auditContracts);

    /**
     * @dev this retrieves all public audit contracts with a given status 
     * @return _auditContracts audit contracts with the given status 
     */
    function getAuditContractsWithStatus(string memory _status) view external returns (address [] memory _auditContracts);

    /** 
     * @dev this retrieves the published audit contracts for a given user 
     * @param _user user that owns the published contracts
     * @return _auditContracts audit contracts for owned by the stated user
     */
    function getPublicAuditContractsForUser(address _user) view external returns (address [] memory _auditContracts);

    /** 
     * @dev this retrieves all audit contract public  & private held by this manager
     * return _auditContracts public and non-public held by this manager 
     */
    function getUserAuditContracts() view external returns (address [] memory _auditContracts);
}