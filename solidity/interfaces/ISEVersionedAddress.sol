// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
/** 
 * @title ISEVersionedAddress 
 * @dev this interface enables smart contracts to declare their name and version which is essential for automated registration with the registry
 */ 
interface ISEVersionedAddress { 

    /**
     * @dev this function returns the name of the contract 
     * @return _name the name of the contract
     */
    function getName() view external returns (string memory _name);

    /** 
     * @dev this functioin returns teh version of the contract 
     * @return _version the version of this contract 
     */
    function getVersion() view external returns (uint256 _version);

}