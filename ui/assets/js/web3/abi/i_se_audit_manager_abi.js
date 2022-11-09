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
				"components": [
					{
						"internalType": "string",
						"name": "ownerName",
						"type": "string"
					},
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "auditTitle",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "uploadDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "maxAuditWindow",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "auditStart",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "auditDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "publishDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "expires",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "auditor",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "auditorName",
						"type": "string"
					}
				],
				"internalType": "struct ISEAuditContract.AuditSeed",
				"name": "_seed",
				"type": "tuple"
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
				"name": "_manifestUri",
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