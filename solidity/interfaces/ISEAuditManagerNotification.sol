// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
/**
 * @title ISEAuditManagerNotification 
 * @dev this interface provides a notification system for audit contracts.
 */
interface ISEAuditManagerNotification {

   /**
     * @dev this enables audit contracts to notify the ISEManager of changes in status 
     * @param _auditContract audit contract with status change 
     * @param _status status change of audit contract 
     * @return _recieved true if the notification is successfully recieved
     */
    function notifyStatus(address _auditContract, string memory _status) external returns (bool _recieved);
}