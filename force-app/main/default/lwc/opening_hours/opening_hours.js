import { LightningElement, api, wire, track } from 'lwc';
import getOpeningHoursForAccount from '@salesforce/apex/FM_OpeningHours_ServiceEndpoint.getOpeningHoursForAccount';

export default class OpeningHours extends LightningElement {
    @track oHours = [];
    @api recordId;


    @wire(getOpeningHoursForAccount, {accountId: '$recordId'})
    wiredHours({ error, data }) {
            if (data) {
               for(let key in data) {
                   if (data.hasOwnProperty(key)) {
                        this.oHours.push({value:data[key], key:key});
                   }
               }
            } else if (error) {
                console.log(error)
            }
        }

}