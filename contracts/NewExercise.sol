// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title New Exercise
 * @author anakvad.base.eth
 *
 * https://docs.base.org/base-learn/docs/new-keyword/new-keyword-exercise
 */

contract AddressBook is Ownable {

    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    // contact id => Contact
    mapping(uint => Contact) internal contacts;
    // contact id => is exists
    mapping(uint => bool) internal contactIdExists;
    uint[] internal contactIds;

    error ContactNotFound(uint id);

    constructor(address _owner) Ownable(_owner) {}

    modifier contactExists(uint _id) {
        if (!contactIdExists[_id]) {
            revert ContactNotFound(_id);
        }
        _;
    }

    function addContact(
        uint _id,
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers
    )
        external onlyOwner
    {
        Contact memory newContact = Contact({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        });

        contacts[_id] = newContact;
        contactIdExists[_id] = true;
        contactIds.push(_id);
    }

    function _deleteContactId(uint _id) internal {
        // In this solution, I replace the desired element in the array with the last element
        // and then delete the last element. The sequence of elements is not important in our case.
        uint contactsLength = contactIds.length;
        for (uint i = 0; i < contactsLength; i++) {
            if (contactIds[i] == _id) {
                if (i != contactsLength - 1) {
                    contactIds[i] = contactIds[contactsLength - 1];
                }
                contactIds.pop();
            }
        }
    }

    function deleteContact(uint _id) external onlyOwner contactExists(_id) {
        delete contacts[_id];
        contactIdExists[_id] = false;
        _deleteContactId(_id);
    }

    function getContact(uint _id) external view contactExists(_id) returns(Contact memory) {
        return contacts[_id];
    }

    function getAllContacts() external view returns(Contact[] memory) {

    }
}

contract AddressBookFactory {

    function deploy() external returns(address) {
        AddressBook newAddressBook = new AddressBook(msg.sender);
        return address(newAddressBook);
    }

}