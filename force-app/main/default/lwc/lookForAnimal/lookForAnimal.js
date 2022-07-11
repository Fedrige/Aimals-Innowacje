import {LightningElement, wire, api, track} from 'lwc';
import ACCOUNT from '@salesforce/schema/Account'
import getShelterNames from '@salesforce/apex/lookForAnimalController.getShelterNames'
import getBreedNames from '@salesforce/apex/lookForAnimalController.getBreedNames'
import getAge from '@salesforce/apex/lookForAnimalController.getAge'
import getAnimal from '@salesforce/apex/lookForAnimalController.getAnimal'
import getBreedOfAnimal from '@salesforce/apex/Einstein.getBreedOfAnimal'


export default class LookForAnimal extends LightningElement {
    value = 'Any';
    shelterPicklistOptions = [];
    shelterValue = 'Any';
    @track
    breedPicklistOptions = [];
    breedValue = 'Any';
    agePicklistOptions = [];
    ageValue = 'Any';
    genderValue = 'Any';
    animalsList;
    base64String='';
    error;
    fileData;
    @api
    myRecordId;

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

    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.jpeg'];
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

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;

    }

    handleFilesChange(event){
        const file = event.detail.files[0]
        console.log(file)
        const reader = new FileReader();
        reader.onload =()=>{
            const Base64 = reader.result.split(',')[1];

            //this.breedValue = getBreedOfAnimal(base64)
            getBreedOfAnimal({strBase64: Base64}).then(result =>{
                const pickListBreed = this.template.querySelector('.breed')
                if (pickListBreed){
                    pickListBreed.value = result
                }
                this.breedValue = result
                console.log(result)
            })
            this.fileData = {
                'filename':file.name,
                'base64':Base64,
                'recordId':this.myRecordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }


//function imageUploaded(imageToConvert) {
//    var file = imageToConvert;
//
//    var reader = new FileReader();
//
//    reader.onload = function () {
//        this.base64String = reader.result.replace('data:', '')
//            .replace(/^.+,/, '');
//
//
//        console.log(this.base64String);
//    }
//    reader.readAsDataURL(file);
//}
}