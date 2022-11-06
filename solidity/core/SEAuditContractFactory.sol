// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "../interfaces/ISEAuditContractFactory.sol";
import "./SEAuditContract.sol";

contract SEAuditContractFactory is ISEAuditContractFactory { 

    address administrator; 
    address santaElenaManagerAddress; 
 
    mapping(address=>bool) knownAuditContract; 

    constructor(address _admin){
        administrator = _admin; 
    }

    function isKnown(address _auditContract) view  external returns (bool _isKnown) {
        return knownAuditContract[_auditContract];
    }

    function getSantaElenaManager() view external returns (address _santaElenaManager) {
        return santaElenaManagerAddress;
    }

    function createAuditContract(ISEAuditContract.AuditSeed memory _seed, 
                                                    string [] memory _urisToAudit, 
                                                    bool [] memory _uriPrivacy, 
                                                    string memory _notesUri, 
                                                    address _auditManagerNotification,
                                                    address _minter, 
                                                    address _uploadProofErc1155, 
                                                    uint256 _uploadProofNftId) external returns (address _auditContract){
                    require(msg.sender == santaElenaManagerAddress, "Santa Elena only");
                    _auditContract = address(new SEAuditContract( _seed, 
                                                            _urisToAudit, 
                                                            _uriPrivacy, 
                                                            _notesUri,
                                                            _auditManagerNotification,
                                                            _minter, 
                                                            _uploadProofErc1155,
                                                            _uploadProofNftId));  
                    knownAuditContract[_auditContract] = true;    
                    return _auditContract;                     
    }

    function setSantaElenaManager(address _santaElenaManager) external returns (bool _set) {
        require(msg.sender == administrator, " administrator only ");
        santaElenaManagerAddress = _santaElenaManager; 
        return true; 
    }
}
