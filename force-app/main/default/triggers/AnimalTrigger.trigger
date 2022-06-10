trigger AnimalTrigger on Animal__c (after insert, after delete) {
    Set<Id> animalsId = new Set<Id>();

    if(Trigger.isinsert){
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for(Animal__c animalId : Trigger.new){
            animalsId.add(animalId.Id);
        }
        accountMap = CountAllAnimalsInShelterClass.countAnimals(animalsId);
		update accountMap.values();
    } 
    else if(Trigger.isdelete){
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for(Animal__c animalId : Trigger.old){
            animalsId.add(animalId.Id);
        }
        accountMap = CountAllAnimalsInShelterClass.countAnimalsDelete(animalsId);
		update accountMap.values();
    }

}