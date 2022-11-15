// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title ISEMintAuthRegistry 
 * @dev this interface represents the minting authorisation registry necessary to secure minting in Santa Elena 
 */
interface ISEMintAuthRegistry { 
    /** 
     * @dev this function returns whether the presented address is known to the registry 
     * @param _address to be checked 
     * @return _known true if the address is known 
     */
    function isKnown(address _address) view external returns (bool _known);

}