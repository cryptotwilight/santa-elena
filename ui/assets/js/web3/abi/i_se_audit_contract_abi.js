iSEAuditContractAbi = [
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
					},
					{
						"internalType": "uint256",
						"name": "carbonOffSet",
						"type": "uint256"
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
				"name": "_uriPrivacy",
				"type": "bool[]"
			},
			{
				"internalType": "string",
				"name": "_notesUri",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_register",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_uploadProofErc1155",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_uploadProofNftId",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_auditorName",
				"type": "string"
			}
		],
		"name": "bookForAudit",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_booked",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAuditReport",
		"outputs": [
			{
				"internalType": "string",
				"name": "_auditReportUri",
				"type": "string"
			},
			{
				"internalType": "enum ISEAuditContract.AUDIT_DECLARATION",
				"name": "_declaration",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAuditSeed",
		"outputs": [
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
					},
					{
						"internalType": "uint256",
						"name": "carbonOffSet",
						"type": "uint256"
					}
				],
				"internalType": "struct ISEAuditContract.AuditSeed",
				"name": "_seed",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getEstimatedAuditEndTime",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_auditEndTime",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getName",
		"outputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "enum ISEAuditContract.PROOF",
				"name": "_proof",
				"type": "uint8"
			}
		],
		"name": "getProofs",
		"outputs": [
			{
				"internalType": "address",
				"name": "_erc1155",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_nftId",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPublicData",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "uri",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "label",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isPrivate",
						"type": "bool"
					}
				],
				"internalType": "struct ISEAuditContract.AuditUri[]",
				"name": "_publicAuditUris",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getStatus",
		"outputs": [
			{
				"internalType": "string",
				"name": "_status",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getUrisToAudit",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "uri",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "label",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isPrivate",
						"type": "bool"
					}
				],
				"internalType": "struct ISEAuditContract.AuditUri[]",
				"name": "_auditUris",
				"type": "tuple[]"
			},
			{
				"internalType": "string",
				"name": "_notesUri",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getVersion",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_version",
				"type": "uint256"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "makePublic",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_done",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operator",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "uint256[]",
				"name": "ids",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256[]",
				"name": "values",
				"type": "uint256[]"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			}
		],
		"name": "onERC1155BatchReceived",
		"outputs": [
			{
				"internalType": "bytes4",
				"name": "",
				"type": "bytes4"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operator",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "data",
				"type": "bytes"
			}
		],
		"name": "onERC1155Received",
		"outputs": [
			{
				"internalType": "bytes4",
				"name": "",
				"type": "bytes4"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_auditReportUri",
				"type": "string"
			},
			{
				"internalType": "enum ISEAuditContract.AUDIT_DECLARATION",
				"name": "_declaration",
				"type": "uint8"
			},
			{
				"internalType": "string",
				"name": "_auditorSealUri",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_auditSubmissionManifestUri",
				"type": "string"
			}
		],
		"name": "submitAuditReport",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_submitted",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes4",
				"name": "interfaceId",
				"type": "bytes4"
			}
		],
		"name": "supportsInterface",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "withdraw",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_withdrawn",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]