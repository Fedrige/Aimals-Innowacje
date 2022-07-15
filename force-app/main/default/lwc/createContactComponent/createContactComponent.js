/**
 * Created by aniesmialek on 12/07/2022.
 */

import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import conObject from '@salesforce/schema/Contact';
import conFirstName from '@salesforce/schema/Contact.FirstName';
import conLastName from '@salesforce/schema/Contact.LastName';
import conBday from '@salesforce/schema/Contact.Birthdate';
import conEmail from '@salesforce/schema/Contact.Email';
import conIDCard from '@salesforce/schema/Contact.idCardNumber__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOCRFromImage from '@salesforce/apex/CreateContactFromIDCard.getOCRFromImage'
import {NavigationMixin} from "lightning/navigation";

export default class ContactForm extends NavigationMixin(LightningElement) {
    firstName = '';
    lastName = '';
    bday= '';
    emailId='';
    IDCardNumber = '';
    isLoaded = true;
    contactChangeVal(event) {
        if(event.target.label=='First Name'){
            this.firstName = event.target.value;
        }
        if(event.target.label=='Last Name'){
            this.lastName = event.target.value;
        }
        if(event.target.label=='Birth Date'){
            this.bday = event.target.value;
        }
        if(event.target.label=='Email'){
            this.emailId = event.target.value;
        }
        if(event.target.label=='ID Card Number'){
            this.IDCardNumber = event.target.value;
        }
    }
    insertContactAction(){
        const fields = {};
        fields[conFirstName.fieldApiName] = this.firstName;
        fields[conLastName.fieldApiName] = this.lastName;
        fields[conBday.fieldApiName] = this.bday;
        fields[conEmail.fieldApiName] = this.emailId;
        fields[conIDCard.fieldApiName] = this.IDCardNumber;
        const recordInput = { apiName: conObject.objectApiName, fields };
        createRecord(recordInput)
            .then(contactobj=> {
                this.contactId = contactobj.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact record has been created',
                        variant: 'success',
                    }),
                );
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: contactobj.id,
                        objectApiName: 'Contact',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }

    handleFilesChange(event) {
        this.isLoaded = false
        const file = event.detail.files[0]
        const reader = new FileReader();
        reader.onload = () => {
            const Base64 = reader.result.split(',')[1];
            getOCRFromImage({strBase64: Base64}).then(result => {
                this.lastName = result[0]
                this.firstName = result[1]
                this.bday = result[2]
                this.IDCardNumber = result[3]
                this.isLoaded = true;
            })
            this.fileData = {
                'filename': file.name,
                'base64': Base64,
                'recordId': this.myRecordId
            }
        }
        reader.readAsDataURL(file)
    }
}