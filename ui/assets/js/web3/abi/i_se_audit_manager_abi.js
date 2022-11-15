iSEAuditManagerAbi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_status",
				"type": "string"
			}
		],
		"name": "getAuditContractsWithStatus",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_auditContracts",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_auditor",
				"type": "address"
			}
		],
		"name": "getContractsUnderAuditor",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_auditContracts",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPublicAuditContracts",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_auditContracts",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_user",
				"type": "address"
			}
		],
		"name": "getPublicAuditContractsForUser",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_auditContracts",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getUserAuditContracts",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_auditContracts",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_ownerName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_auditTitle",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_maxAuditWindow",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_carbonOffset",
				"type": "uint256"
			},
			{
				"internalType": "string[]",
				"name": "_urisToAudit",
				"type": "string[]"
			},
			{
				"internalType": "string[]",
				"name": "_uriLabels",
				"type": "string[]"
			},
			{
				"internalType": "bool[]",
				"name": "_private",
				"type": "bool[]"
			},
			{
				"internalType": "string",
				"name": "_notesUri",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_uploadManifestUri",
				"type": "string"
			}
		],
		"name": "uploadFiles",
		"outputs": [
			{
				"internalType": "address",
				"name": "_auditContract",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]