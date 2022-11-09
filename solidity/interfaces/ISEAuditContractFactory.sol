// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ISERegistry.sol";
import "./ISEAuditContract.sol";
/**
 * @title ISEAuditContractFactory 
 * @dev this is the Audit Contract Factory, necessary to ensure that audit contract creation is separate from discovery functions
 */
interface ISEAuditContractFactory is ISERegistry {
    /**
     * @dev this contract is responseible for creating an audit contract based on the given parameters
     * @param _seed primary metadata for the audit contract
     * @param _urisToAudit uris for uploaded files to audit 
     * @param _uriLabels labels for the uploaded uris 
     * @param _uriPrivacy privacy marker for files to be audited
     * @param _notesUri uri for notes on the uploaded data
     * @param _auditManagerNotification where to send audit manager notifications 
     * @param _minter minting service for the audit contract
     * @param _uploadProofErc1155 upload proof contract
     * @param _uploadProofNftId upload proof nft id
     * @return _auditContract address of the audit contract
     */

    function createAuditContract(ISEAuditContract.AuditSeed memory _seed, 
                                                string[] memory _urisToAudit, 
                                                string [] memory _uriLabels, 
                                                bool [] memory _uriPrivacy, 
                                                string memory _notesUri, 
                                                address _auditManagerNotification,
                                                address _minter, 
                                                address _uploadProofErc1155, 
                                                uint256 _uploadProofNftId) external returns (address _auditContract);

}