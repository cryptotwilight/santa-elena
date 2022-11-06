// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title ISERegistry 
 * @dev the registry interface is a light weight interface designed to accomodate derivative contracts so contracts created by contracts and allow them to operate in the Santa Elena dApp
 */
interface ISERegistry { 

    /**
     * @dev this function checks whether the given address is known to this registry
     * @param _address address to be checked
     * @return _isKnown true if the contract is known 
     */
    function isKnown(address _address) view external returns (bool _isKnown);

}