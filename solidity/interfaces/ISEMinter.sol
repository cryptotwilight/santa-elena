// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
/**
 * @title ISEMinter 
 * @dev The minter is responsible for minting all of the ERC1155 compliant NFTs that are used by Santa Elena. 
 * It relies on separate contracts to run the mints as these my need to be changed from time to time. 
 */
interface ISEMinter {
    /**
     * @dev this function mints the declaration made by the auditor on a specific project. It takes the auditor's seal as the uri for the token
     * @param _auditorSeal this is the unique seal given by the auditor, it is stored with the metadata of the declaration and the ipfs uri is presented for minting 
     * @param _auditContract this is the audit contract that will hold this minted seal 
     * @return _erc1155 the nft contract address 
     * @return _nftId the id of the NFT holding the minted declaration 
     */
    function mintDeclaration(string memory _auditorSeal, address _auditContract ) external returns (address _erc1155, uint256 _nftId);

    /** 
     * @dev this function mints the proof of upload by the uploader. it takes a manifest uri that holds a manifest of the files and data that was uploaded 
     * @param _uploader who will be the recipient of the nft 
     * @param _uploadManifestUri an immutable record of the files that were uploaded by the uploader 
     * @return _erc1155 the nft contract address 
     * @return _nftId the id of the NFT holding the minted upload proof
     */
    function mintUploadProof(address _uploader, string memory _uploadManifestUri) external returns (address _erc1155, uint256 _nftId);

    /** 
     * @dev this function mints the proof of audit submission by the given auditor. It takes a manifest uri that holds a manifest of the file that was submitted by the auditor
     * @param _auditor who will be the recipient of the proof 
     * @param _auditSubmissionManifestUri an immutable record of the file that was submitted by the auditor 
     * @return _erc1155 the nft contract address 
     * @return _nftId the id of the NFT holding the minted audit submission proof
     */
    function mintAuditSubmissionProof(address _auditor, string memory _auditSubmissionManifestUri) external returns (address _erc1155, uint256 _nftId);


    function mintSealAndProof(address _auditor, string memory _auditSubmissionManifestUri, string memory _auditorSeal, address _auditContract) external returns (address _erc1155Seal, uint256 _nftIdSeal, address _erc1155Submission, uint256 _nftIdSubmission );
}