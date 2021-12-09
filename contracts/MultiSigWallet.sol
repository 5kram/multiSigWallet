pragma solidity ^0.8.10;

contract MultiSigWallet {
    address private _owner;
    mapping(address => uint8) private _owners;

    mapping (uint => Transaction) private _transactions;
    uint[] private _pendingTransactions;

    // auto incrememnting transaction ID
    uint private _transactionIndex;
    // constant: we need x amount of signatures to sign Transaction
    uint constant MIN_SIGNATURES = 2;

    struct Transaction {
        address source;
        address destination;
        uint value;
        //add how many people signed and who
        uint signatureCount;
        //need to keep record of who signed
        mapping (address => uint8) signatures;
    }

    modifier isOwner() {
        require(msg.sender == _owner);
        _;
    }

    modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender] == 1);
        _;
    }

    /// @dev logged events
    event DepositFunds(address source, uint amount);
    /// @dev full sequence of the transaction event logged
    event TransactionCreated(address source, address destination, uint value, uint transactionID);
    event TransactionCompleted(address source, address destination, uint value, uint transactionID);
    /// @dev keeps track of who is signing the transactions
    event TransactionSigned(address by, uint transactionID);


    /// @dev Contract constructor sets initial owners
    constructor() {
        _owner = msg.sender;
    }

    /// @dev add new owner to have access, enables the ability to create more than one owner to manage the wallet
    function addOwner(address newOwner) isOwner public {
      //YOUR CODE HERE
    }

    /// @dev remove suspicious owners
    function removeOwner(address existingOwner) isOwner public {
      //YOUR CODE HERE
    }

    /// @dev Fallback function, which accepts ether when sent to contract
    fallback() external payable {
        DepositFunds(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
      require(address(this).balance >= value);
      //YOUR CODE HERE

    }

    /// @dev Send ether to specific a transaction
    /// @param destination Transaction target address.
    /// @param value Transaction ether value.
    ///
    /// Start by creating your transaction. Since we defined it as a struct,
    /// we need to define it in a memory context. Update the member attributes.
    ///
    /// note, keep transactionID updated
    function transferTo(address destination, uint value) validOwner public {
      require(address(this).balance >= value);
      //YOUR CODE HERE

      //create the transaction
      //YOUR CODE HERE





      //add transaction to the data structures
      //YOUR CODE HERE


      //log that the transaction was created to a specific address
      //YOUR CODE HERE
    }

    //returns pending transcations
    function getPendingTransactions() constant validOwner public returns (uint[]) {
      //YOUR CODE HERE
    }

    /// @dev Allows an owner to confirm a transaction.
    /// @param transactionId Transaction ID.
    /// Sign and Execute transaction.
    function signTransaction(uint transactionID) validOwner public {
      //Use Transaction Structure. Above in TransferTo function, because
      //we created the structure, we had to specify the keyword memory.
      //Now, we are pulling in the structure from a storage mechanism
      //Basically, 'storage' will stop the EVM from duplicating the actual
      //object, and instead will reference it directly.

      //Create variable transaction using storage (which creates a reference point)
      //YOUR CODE HERE

      // Transaction must exist, note: use require(), but can't do require(transaction), .
      //YOUR CODE HERE

      // Creator cannot sign the transaction, use require()
      //YOUR CODE HERE

      // Cannot sign a transaction more than once, use require()
      //YOUR CODE HERE

      // assign the transaction = 1, so that when the function is called again it will fail
      //YOUR CODE HERE

      // increment signatureCount
      //YOUR CODE HERE

      // log transaction
      //YOUR CODE HERE

      //  check to see if transaction has enough signatures so that it can actually be completed
      // if true, make the transaction. Don't forget to log the transaction was completed.
      if (transaction.signatureCount >= MIN_SIGNATURES) {
        require(address(this).balance >= transaction.value); //validate transaction
        //YOUR CODE HERE

        //log that the transaction was complete
        //YOUR CODE HERE

        //end with a call to deleteTransaction
        deleteTransaction(transactionId);
      }
    }

    /// @dev clean up function
    function deleteTransaction(uint transactionId) validOwner public {
      uint8 replace = 0;
      for(uint i = 0; i < _pendingTransactions.length; i++) {
        if (1 == replace) {
          _pendingTransactions[i-1] = _pendingTransactions[i];
        } else if (transactionId == _pendingTransactions[i]) {
          replace = 1;
        }
      }
      delete _pendingTransactions[_pendingTransactions.length - 1];
      _pendingTransactions.length--;
      delete _transactions[transactionId];
    }

    /// @return Returns balance
    function walletBalance() constant public returns (uint) {
      //YOUR CODE HERE
    }

 }
