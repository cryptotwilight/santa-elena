// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ISEVersionedAddress.sol";
/** 
 * @title ISEMintable 
 * @dev this interface provides a way for minting NFTs within Santa Elena 
 */
interface ISEMintable is ISEVersionedAddress { 

    /**
     * @dev this function will mint an NFT with the given uri and nftid to the given address 
     * @param _to address to which NFT will be sent 
     * @param _uri uri containing data for the NFT
     * @return _nftId id of the NFT 
     */
    function mint(address _to, string memory _uri) external returns (uint256 _nftId);

}