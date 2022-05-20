import {LightningElement, wire, api} from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';

import CITY_FIELD from "@salesforce/schema/Account.BillingCity";
import COUNTRY_FIELD from "@salesforce/schema/Account.BillingCountry";
import STREET_FIELD from "@salesforce/schema/Account.BillingStreet";
import POSTALCODE_FIELD from "@salesforce/schema/Account.BillingPostalCode";
import STATE_FIELD from "@salesforce/schema/Account.BillingState";
import ACCOUNTNAME_FIELD from "@salesforce/schema/Account.Name";

const strings = [CITY_FIELD, COUNTRY_FIELD, STREET_FIELD, POSTALCODE_FIELD, STATE_FIELD, ACCOUNTNAME_FIELD];

export default class MapComponent extends LightningElement {
    @api recordId;
    mapMarkers;
    mapOptions = {
        disableDefaultUI: true,
        draggable: false,
    };
    succesWithLocation = false;

    @wire(getRecord, {recordId: "$recordId", fields: strings})
    wiredRecord({error, data}){
            if(data){
                const marker = {
                    location: {
                        Street: data.fields.BillingStreet.value ? data.fields.BillingStreet.value : '',
                        City: data.fields.BillingCity.value ? data.fields.BillingCity.value : '',
                        State: data.fields.BillingState.value ? data.fields.BillingState.value : '',
                        PostalCode: data.fields.BillingPostalCode.value ? data.fields.BillingPostalCode.value : '',
                        Country: data.fields.BillingCountry.value ? data.fields.BillingCountry.value : ''
                    },
                    title: data.fields.Name.value,
                    icon: 'standard:account'
                };

                this.mapMarkers = [marker];
                this.error = undefined;
                this.succesWithLocation = true;
            }
            else if(error){
                this.mapMarkers = undefined;
                this.error = error;
                this.succesWithLocation = false;
            }
        }
}