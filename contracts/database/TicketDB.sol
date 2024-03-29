pragma solidity ^0.5.8;

import "./CommonDB.sol";
import "../container/Contained.sol";

/**
    @title TicketDB
    @dev Stores all ticket states and information
    @author karlptrck
 */
contract TicketDB is Contained {

    CommonDB commonDB;
    string constant CONTRACT_NAME_TICKET_DB = "TicketDB";
    uint256 public constant TICKET_STATE_FOR_SALE = 1;
    uint256 public constant TICKET_STATE_TRANSACTION_IN_PROGRESS = 2;
    uint256 public constant TICKET_STATE_SOLD = 3;

    constructor(CommonDB _commonDB) public {
        commonDB = _commonDB;
    }

    /**
        @dev Stores the ticket details
        @param refNo unique reference number
        @param amount ticket amount
     */
    function addTicket
    (
        string calldata refNo,
        uint256 amount,
        address payable seller,
        bool forDirectBuy
    )
    external
    onlyContract(CONTRACT_SWOP_MANAGER)
    {

        commonDB.setAddressPayable(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo)), seller);
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'amount')), amount);
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'state')), TICKET_STATE_FOR_SALE);
        commonDB.setBoolean(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'forDirectBuy')), forDirectBuy);
    }

    /**
        @dev Get the ticket amount
        @param refNo unique reference number
     */
    function getTicketAmount(string calldata refNo) external view onlyContract(CONTRACT_SWOP_MANAGER)
    returns (uint256) {
        return commonDB.getUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'amount')));
    }

    /**
        @dev Get the ticket seller
        @param refNo unique reference number
     */
    function getTicketSeller(string calldata refNo) external view onlyContract(CONTRACT_SWOP_MANAGER)
    returns (address) {
        return commonDB.getAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo)));
    }

    /**
        @dev Set Ticket Buyer
        @param refNo unique reference number
     */
    function setTicketBuyer(string calldata refNo, address buyer) external onlyContract(CONTRACT_SWOP_MANAGER) {
        commonDB.setAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'buyer')), buyer);
    }

    /**
        @dev UpdateTicketStatus
        @param refNo unique reference number
        @param value Ticket status
     */
    function updateTicketStatus(string calldata refNo, uint256 value) external onlyContract(CONTRACT_SWOP_MANAGER) {
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'state')), value);
    }

    function getTicketStatus(string calldata refNo) external view returns (uint256) {
        return commonDB.getUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'state')));
    }

    function getTicketBuyer(string calldata refNo) external view returns (address) {
        return commonDB.getAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'buyer')));
    }

}