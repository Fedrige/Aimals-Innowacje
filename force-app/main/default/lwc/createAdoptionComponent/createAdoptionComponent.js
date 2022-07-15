import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import conObject from '@salesforce/schema/Contact';
import adoptionObject from '@salesforce/schema/Adoption__c';
import conFirstName from '@salesforce/schema/Contact.FirstName';
import conLastName from '@salesforce/schema/Contact.LastName';
import animalName from '@salesforce/schema/Adoption__c.Animal__r.Name';
//import adoptionType from '@salesforce/schema/Adoption__c.RecordType';
import recordTypeID from '@salesforce/schema/Adoption__c.RecordTypeId';
import amount from '@salesforce/schema/Adoption__c.Amount__c';
import contact from '@salesforce/schema/Adoption__c.Contact__c';
import animal from '@salesforce/schema/Adoption__c.Animal__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getOCRFromPdf from '@salesforce/apex/CreateAdoptionFromOCRForm.createAdoptionData'
import einstein from '@salesforce/apex/Einstein.getOCRFromPDF'

import {NavigationMixin} from "lightning/navigation";

export default class ContactForm extends NavigationMixin(LightningElement) {
    firstName = '';
    lastName = '';
    animalName = '';
    adoptionType = '';
    amount = '';

    contactId = '';
    animalId = '';
    recordTypeID = '';
    isDisabled = false;
    isReal = false;


    isLoaded = true;
    adoptionChangeVal(event) {
        if(event.target.label=='First Name'){
            this.firstName = event.target.value;
        }
        if(event.target.label=='Last Name'){
            this.lastName = event.target.value;
        }
        if(event.target.label=='Animal Name'){
            this.animalName = event.target.value;
        }
        if(event.target.label=='Adoption Type'){
            this.adoptionType = event.target.value;
            this.isReal = this.adoptionType == 'Real';
        }
        if(event.target.label=='Amount'){
            this.amount = event.target.value;
        }
    }
    insertAdoptionAction(){
        const fields = {};
        const fields2 = {};
        if(this.contactId == 'empty'){
            fields[conFirstName.fieldApiName] = this.firstName;
            fields[conLastName.fieldApiName] = this.lastName;
            const recordInput = { apiName: conObject.objectApiName, fields };
                createRecord(recordInput)
                    .then(contactobj=> {
                        this.contactId = contactobj.id;
                        fields2[recordTypeID.fieldApiName] = this.recordTypeID;
                        fields2[animal.fieldApiName] = this.animalId;
                        fields2[amount.fieldApiName] = this.amount;
                        fields2[contact.fieldApiName] = this.contactId;

                        const recordInput2 = { apiName: adoptionObject.objectApiName, fields: fields2 };
                        createRecord(recordInput2)
                            .then(adoptionObject=> {
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Success',
                                        message: 'Adoption record has been created',
                                        variant: 'success',
                                    }),
                                );
                                this[NavigationMixin.Navigate]({
                                    type: 'standard__recordPage',
                                    attributes: {
                                        recordId: adoptionObject.id,
                                        objectApiName: 'Adoption__c',
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

        }else{
            fields[recordTypeID.fieldApiName] = this.recordTypeID;
            fields[animal.fieldApiName] = this.animalId;
            fields[amount.fieldApiName] = this.amount;
            fields[contact.fieldApiName] = this.contactId;

            const recordInput = { apiName: adoptionObject.objectApiName, fields };
                    createRecord(recordInput)
                        .then(adoptionObject=> {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: 'Adoption record has been created',
                                    variant: 'success',
                                }),
                            );
                            this[NavigationMixin.Navigate]({
                                type: 'standard__recordPage',
                                attributes: {
                                    recordId: adoptionObject.id,
                                    objectApiName: 'Adoption__c',
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
    }


    handleFilesChange(event) {
        this.isLoaded = false
        const file = event.detail.files[0]
        const reader = new FileReader();
        reader.onload = () => {
            const Base64 = reader.result.split(',')[1];

            getOCRFromPdf({strBase64: Base64}).then(result => {
                 this.firstName = result[0]
                 this.lastName = result[1]
                 this.contactId = result[2]
                 if (this.contactId !== 'empty'){
                    this.isDisabled = true;
                 }
                 this.animalName = result[3]
                 this.animalId = result[4]
                 this.adoptionType = result[5]
                 if(this.adoptionType === 'Real'){
                    this.isReal = true;
                 }
                 this.recordTypeID = result[6]
                 this.amount = result[7]
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