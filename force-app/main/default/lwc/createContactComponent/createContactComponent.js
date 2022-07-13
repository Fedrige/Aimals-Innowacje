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
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOCRFromImage from '@salesforce/apex/CreateContactFromIDCard.getOCRFromImage'

export default class ContactForm extends LightningElement {
    firstName = '';
    lastName = '';
    bday= '';
    emailId='';
    isLoaded = true;
    contactChangeVal(event) {
        console.log(event.target.label);
        console.log(event.target.value);
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
    }
    insertContactAction(){
        console.log(this.selectedAccountId);
        const fields = {};
        fields[conFirstName.fieldApiName] = this.firstName;
        fields[conLastName.fieldApiName] = this.lastName;
        fields[conBday.fieldApiName] = this.bday;
        fields[conEmail.fieldApiName] = this.emailId;
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
        console.log(file)
        const reader = new FileReader();
        reader.onload = () => {
            const Base64 = reader.result.split(',')[1];

            //this.breedValue = getBreedOfAnimal(base64)
            getOCRFromImage({strBase64: Base64}).then(result => {
                 this.lastName = result[0]
                 this.firstName = result[1]
                 this.bday = result[2]
                console.log(result)
                this.isLoaded = true;
            })
            this.fileData = {
                'filename': file.name,
                'base64': Base64,
                'recordId': this.myRecordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
}