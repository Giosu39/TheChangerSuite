/* eslint-disable no-alert */
import { LightningElement, track, wire } from "lwc";

import getUser from "@salesforce/apex/ChangeOwnerController.getUser";
import changeOwner from "@salesforce/apex/ChangeOwnerController.changeOwner";
import getAccounts from "@salesforce/apex/ChangeOwnerController.getAccounts";
import getContacts from "@salesforce/apex/ChangeOwnerController.getContacts";
import getOpportunities from "@salesforce/apex/ChangeOwnerController.getOpportunities";
import getUsersWithoutRecordOwner from "@salesforce/apex/ChangeOwnerController.getUsersWithoutRecordOwner";

export default class ChangeOwner extends LightningElement {
  /* User Picklist */

  @track userOptions = []; // Key, Value
  @track userPicklistValue = ""; // initialize combo box value
  @track selectedUser = "";

  @wire(getUser) loadUsers({ data }) {
    if (data) {
      for (let i = 0; i < data.length; i++) {
        this.userOptions = [
          ...this.userOptions,
          { value: data[i].Id, label: data[i].Name }
        ];
      }
    }
  }

  handleChange(event) {
    const selectedOption = event.detail.value;
    this.selectedUser = selectedOption;
  }

  /* Data Table for Account, Contact, Opportunity */

  accountColumns = [{ label: "Account ID", fieldName: "Id", type: "id" }];
  contactColumns = [{ label: "Contact ID", fieldName: "Id", type: "id" }];
  opportunityColumns = [
    { label: "Opportunity ID", fieldName: "Id", type: "id" }
  ];

  @track accountData = [];
  @track contactData = [];
  @track opportunityData = [];

  loadAccounts() {
    getAccounts({
      ownerId: this.selectedUser
    }).then((result) => {
      this.accountData = result;
    });
  }

  loadContacts() {
    getContacts({
      ownerId: this.selectedUser
    }).then((result) => {
      this.contactData = result;
    });
  }

  loadOpportunities() {
    getOpportunities({
      ownerId: this.selectedUser
    }).then((result) => {
      this.opportunityData = result;
    });
  }

  loadRecords() {
    this.loadAccounts();
    this.loadContacts();
    this.loadOpportunities();
  }

  /* Cambio utente, sezione destra */

  @track userToChangeOptions = []; // Key, Value
  @track userToChange = "";
  @track selectedUserToChange = "";
  @track recordToChange = ""; // Id del record

  handleUserToChange(event) {
    const selectedOption = event.detail.value;
    this.selectedUserToChange = selectedOption;
  }

  @wire(getUsersWithoutRecordOwner, { recordId: "$recordToChange" })
  loadUsersToChange({ data }) {
    if (data) {
      this.userToChangeOptions = [];
      for (let i = 0; i < data.length; i++) {
        this.userToChangeOptions = [
          ...this.userToChangeOptions,
          { value: data[i].Id, label: data[i].Name }
        ];
      }
    }
  }

  handleRecordChange(event) {
    this.recordToChange = event.detail.value;
  }

  changeRecordOwner() {
    console.log("userId: " + this.selectedUserToChange);
    console.log("recordId: " + this.recordToChange);
    changeOwner({
      userId: this.selectedUserToChange,
      recordId: this.recordToChange
    }).then((result) => {
      if (result === "Success") {
        alert("Il proprietario è stato cambiato correttamente");
      } else {
        alert("Il proprietario non è stato cambiato");
      }
    });
  }
}
