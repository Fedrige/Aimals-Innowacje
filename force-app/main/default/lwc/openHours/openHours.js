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
        return getFieldValue(this.account.data, OpenHoursMonday_FIELD);
    }
    get closeHoursTimeMonday() {
            return getFieldValue(this.account.data, CloseHoursMonday_FIELD);
    }

    get openHoursTimeTuesday() {
        return getFieldValue(this.account.data, OpenHoursTuesday_FIELD);
    }
    get closeHoursTimeTuesday() {
            return getFieldValue(this.account.data, CloseHoursTuesday_FIELD);
    }

    get openHoursTimeWednesday() {
        return getFieldValue(this.account.data, OpenHoursWednesday_FIELD);
    }
    get closeHoursTimeWednesday() {
            return getFieldValue(this.account.data, CloseHoursWednesday_FIELD);
    }

    get openHoursTimeThursday() {
        return getFieldValue(this.account.data, OpenHoursThursday_FIELD);
    }
    get closeHoursTimeThursday() {
            return getFieldValue(this.account.data, CloseHoursThursday_FIELD);
    }

    get openHoursTimeFriday() {
        return getFieldValue(this.account.data, OpenHoursFriday_FIELD);
    }
    get closeHoursTimeFriday() {
            return getFieldValue(this.account.data, CloseHoursFriday_FIELD);
    }

    get openHoursTimeSaturday() {
        return getFieldValue(this.account.data, OpenHoursSaturday_FIELD);
    }
    get closeHoursTimeSaturday() {
            return getFieldValue(this.account.data, CloseHoursSaturday_FIELD);
    }

    get openHoursTimeSunday() {
        return getFieldValue(this.account.data, OpenHoursSunday_FIELD);
    }
    get closeHoursTimeSunday() {
            return getFieldValue(this.account.data, CloseHoursSunday_FIELD);
    }
}