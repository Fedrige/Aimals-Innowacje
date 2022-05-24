import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import OpenHoursMonday_FIELD from '@salesforce/schema/Account.OpenHoursMonday__c';
import CloseHoursMonday_FIELD from '@salesforce/schema/Account.CloseHoursMonday__c';

import OpenHoursTuesday_FIELD from '@salesforce/schema/Account.OpenHoursTuesday__c';
import CloseHoursTuesday_FIELD from '@salesforce/schema/Account.CloseHoursTuesday__c';

import OpenHoursWednesday_FIELD from '@salesforce/schema/Account.OpenHoursWednesday__c';
import CloseHoursWednesday_FIELD from '@salesforce/schema/Account.CloseHoursWednesday__c';

import OpenHoursThursday_FIELD from '@salesforce/schema/Account.OpenHoursThursday__c';
import CloseHoursThursday_FIELD from '@salesforce/schema/Account.CloseHoursThursday__c';

import OpenHoursFriday_FIELD from '@salesforce/schema/Account.OpenHoursFriday__c';
import CloseHoursFriday_FIELD from '@salesforce/schema/Account.CloseHoursFriday__c';

import OpenHoursSaturday_FIELD from '@salesforce/schema/Account.OpenHoursSaturday__c';
import CloseHoursSaturday_FIELD from '@salesforce/schema/Account.CloseHoursSaturday__c';

import OpenHoursSunday_FIELD from '@salesforce/schema/Account.OpenHoursSunday__c';
import CloseHoursSunday_FIELD from '@salesforce/schema/Account.CloseHoursSunday__c';

const fields = [OpenHoursMonday_FIELD, CloseHoursMonday_FIELD,OpenHoursTuesday_FIELD, CloseHoursTuesday_FIELD, OpenHoursWednesday_FIELD,
CloseHoursWednesday_FIELD, OpenHoursThursday_FIELD, CloseHoursThursday_FIELD, OpenHoursFriday_FIELD, CloseHoursFriday_FIELD,
OpenHoursSaturday_FIELD, CloseHoursSaturday_FIELD, OpenHoursSunday_FIELD, CloseHoursSunday_FIELD];

export default class openHours extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields })
    account;
    get openHoursTimeMonday() {
//        console.log("----------"+typeof getFieldValue(this.account.data, OpenHoursMonday_FIELD));

        let tmp = getFieldValue(this.account.data, OpenHoursMonday_FIELD);
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeMonday() {
        let tmp = getFieldValue(this.account.data, CloseHoursMonday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get openHoursTimeTuesday() {
        let tmp = getFieldValue(this.account.data, OpenHoursTuesday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeTuesday() {
        let tmp = getFieldValue(this.account.data, CloseHoursTuesday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get openHoursTimeWednesday() {
        let tmp = getFieldValue(this.account.data, OpenHoursWednesday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeWednesday() {
        let tmp = getFieldValue(this.account.data, CloseHoursWednesday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get openHoursTimeThursday() {
        let tmp = getFieldValue(this.account.data, OpenHoursThursday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeThursday() {
        let tmp = getFieldValue(this.account.data, CloseHoursThursday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get openHoursTimeFriday() {
        let tmp = getFieldValue(this.account.data, OpenHoursFriday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeFriday() {
        let tmp = getFieldValue(this.account.data, CloseHoursFriday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get openHoursTimeSaturday() {
        let tmp = getFieldValue(this.account.data, OpenHoursSaturday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeSaturday() {
        let tmp = getFieldValue(this.account.data, CloseHoursSaturday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get openHoursTimeSunday() {
        let tmp = getFieldValue(this.account.data, OpenHoursSunday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }

    get closeHoursTimeSunday() {
        let tmp = getFieldValue(this.account.data, CloseHoursSunday_FIELD)
        if(typeof tmp !== "undefined"){
            tmp = tmp.substr(0,5);
        }

        return tmp;
    }
}