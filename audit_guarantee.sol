pragma solidity ^0.4.2;

// one possible implementation of EIP 149
// https://github.com/ethereum/EIPs/issues/149
// by Simon Janin. Feel free to fork/pull-request/comment

// Short documentation:
// Functions should be called in this order
// C stands for the contract creator
// R stands for the security researcher
//
// (1) C calls add_contract(..)
// (2) If R is not yet on the auditorsList, he calls add_auditor(..) with possibly some ether 
// that are going to be bounded (not compulsory, but will be useful for the UI;
// because auditors with no ether will be shown last)
// (3) R audits the contract, write a document (if he wants), computes its hash,
// then calls add_audit(..) with the hash of the file and the grade he gives the current contract.
// (4) Anyone can now call the publicly available functions get_auditList(), get_auditNode(), etc.



contract audit_guarantee {
    
    struct auditor {
        string auditorName;
        uint depositAmount;
        uint depositStartBlock;
        uint depositEndBlock;
    }
    
    struct evaluation {
        bytes32 auditHash; // hash of the article (also corresponds to its IPFS address)
        uint auditNote; // 0<=x<=100
    }
    
    struct audits {
        string contractName;
        mapping (address => evaluation) evaluationsList;
    }
    
    mapping (address => audits) contractsList;
    mapping (address => auditor) auditorsList;
    
    uint MIN_BONDING_TIME = 1; // minimum number of blocks an auditor has to be bonded

    function add_auditor(string name, uint depositEndBlock) {
        //uint maxTime = block.number + MIN_BONDING_TIME;
        
        if (depositEndBlock <= block.number) {
            throw;
        }
        
        auditorsList[msg.sender].auditorName = name;
        auditorsList[msg.sender].depositAmount = msg.value;
        auditorsList[msg.sender].depositStartBlock = block.number;
        auditorsList[msg.sender].depositEndBlock = depositEndBlock;
    }
    
    function add_contract(address contractAddress, string contractName, uint contractNonce) {
        // TODO: verify that the contract was indeed created by the caller <!>
        // http://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed
        // https://github.com/ethereum/wiki/wiki/RLP
        
        contractsList[contractAddress].contractName = contractName;
        
        // TODO: design decision: should the contract owner be able to modify the fields (like the contractName)?
    }
    
    function add_audit(address contractAddress, bytes32 auditHash, uint auditNote) {
        // TODO: check the caller is in the auditorsList and that he is still bounded
        if (auditorsList[msg.sender].depositEndBlock == 0
            || auditorsList[msg.sender].depositEndBlock > block.number) throw;
        
        contractsList[contractAddress].evaluationsList[msg.sender].auditHash = auditHash;
        contractsList[contractAddress].evaluationsList[msg.sender].auditNote = auditNote;
        
    }
    
    // Queries
    // TODO: to be implemented
    
    function get_auditList() {}
    function get_contractsList() {}
    function get_auditNote() {}
    function get_auditHash() {}
}

