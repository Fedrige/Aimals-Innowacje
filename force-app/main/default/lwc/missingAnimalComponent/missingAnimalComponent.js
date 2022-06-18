import {LightningElement, track} from 'lwc';
import getMissingAnimals from '@salesforce/apex/RestMissingAnimal.getMissingAnimals';
import getMissingAnimalImage from '@salesforce/apex/RestMissingAnimal.getMissingAnimalImage';

export default class MissingAnimalComponent extends LightningElement {
    dayDelta = 0
    @track missingAnimalImage = []

    handleDayDeltaChange(event){
        this.dayDelta = event.target.value;
    }

    handleSearch(event){

        if(this.dayDelta < 0 || this.dayDelta == null){
            return;
        }

        getMissingAnimals({
            dayDelta: this.dayDelta
        })
            .then(missingAnimalId => {
                this.missingAnimalImage = []
                missingAnimalId.forEach((animalId) => this.getImage(animalId))
            })


    }

    getImage(ID){
        getMissingAnimalImage({
            animalId: ID
        })
        .then(missingAnimalImage =>{
            this.missingAnimalImage.push({key: ID, value: missingAnimalImage});
        })

    }

}