import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import OpenHours_FIELD from '@salesforce/schema/Account.OpenHours__c';
const fields = [OpenHours_FIELD];


export default class openHours extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields })
    account;
    get openHoursTime() {
        return getFieldValue(this.account.data, OpenHours_FIELD);
    }
}