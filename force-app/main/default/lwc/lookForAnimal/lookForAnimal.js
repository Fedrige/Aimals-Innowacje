/**
 * Created by Adam on 11.06.2022.
 */

import {LightningElement, wire} from 'lwc';
import ACCOUNT from '@salesforce/schema/Account'
import getShelterNames from '@salesforce/apex/lookForAnimalController.getShelterNames'
import getBreedNames from '@salesforce/apex/lookForAnimalController.getBreedNames'
import getAge from '@salesforce/apex/lookForAnimalController.getAge'
import getAnimal from '@salesforce/apex/lookForAnimalController.getAnimal'


export default class LookForAnimal extends LightningElement {
    value = 'Any';
    shelterPicklistOptions = [];
    shelterValue = 'Any';
    breedPicklistOptions = [];
    breedValue = 'Any';
    agePicklistOptions = [];
    ageValue = 'Any';
    genderValue = 'Any';
    animalsList;
    error;

    @wire(getAnimal, {shelterValue: '$shelterValue', breedValue: '$breedValue', ageValue: '$ageValue', genderValue: '$genderValue'})
    wiredAnimals({error, data}){
        if (data) {
            this.animalsList = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.animalsList = undefined;
        }
    }

    get shelterOptions() {
        return this.shelterPicklistOptions.map(el => ({label: el, value: el}));
    }

    get breedOptions(){
        return this.breedPicklistOptions.map(el => ({label: el, value: el}));
    }

    get ageOptions(){
        return this.agePicklistOptions.map(el => ({label: el, value: el}));
    }

    get genderOptions(){
        return [
            { label: 'Any', value: 'Any' },
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
        ];
    }

    connectedCallback() {
        getShelterNames()
            .then(result => {
                this.shelterPicklistOptions = result;
            })
        getBreedNames()
            .then(result => {
                this.breedPicklistOptions = result;
            })
        getAge()
            .then(result => {
                this.agePicklistOptions = result;
            })
    }

    handlePicklistShelterChange(event){
        this.shelterValue = event.target.value;
    }

    handlePicklistBreedChange(event){
        this.breedValue = event.target.value;
    }

    handlePicklistAgeChange(event){
        this.ageValue = event.target.value;
    }

    handlePicklistGenderChange(event){
        this.genderValue = event.target.value;
    }
    handleClick(event){
        //EINSTEIN VISSION
    }
}