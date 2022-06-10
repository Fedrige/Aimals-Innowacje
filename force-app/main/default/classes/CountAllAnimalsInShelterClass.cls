public class CountAllAnimalsInShelterClass {
    public static Map<Id, Account> countAnimals(Set<Id> animalId){
        Map<Id, Account> accountMap = new Map<Id, Account>();
        List<Animal__c> animals = [SELECT Id, Account__r.Id, Account__r.NumberOfAnimals__c, Account__r.numberOfUnadapted__c FROM Animal__c WHERE Id IN :animalId];

        for (Animal__c animal : animals){
            if (accountMap.containsKey(animal.Account__r.Id)) {
                accountMap.get(animal.Account__r.Id).NumberOfAnimals__c = accountMap.get(animal.Account__r.Id).NumberOfAnimals__c+1;
                accountMap.get(animal.Account__r.Id).NumberOfAnimals__c = accountMap.get(animal.Account__r.Id).numberOfUnadapted__c+1;
            }else {
                Account shelter = new Account();
                shelter.Id = animal.Account__r.Id;
                shelter.NumberOfAnimals__c = animal.Account__r.NumberOfAnimals__c+1;
                shelter.numberOfUnadapted__c = animal.Account__r.numberOfUnadapted__c+1;
                accountMap.put(shelter.Id, shelter);
            }
        }
        return accountMap;
    }
    
    public static Map<Id, Account> countAnimalsDelete(Set<Id> animalId){
        Map<Id, Account> accountMap = new Map<Id, Account>();
        List<Animal__c> listAnimals = [SELECT Id, Account__r.Id, Account__r.NumberOfAnimals__c, Account__r.numberOfUnadapted__c FROM Animal__c WHERE Id != NULL];
		List<Animal__c> animals = [SELECT Id, Account__r.Id, Account__r.NumberOfAnimals__c, Account__r.numberOfUnadapted__c FROM Animal__c WHERE Id IN :animalId AND Id NOT IN : listAnimals ALL ROWS];
       
        for (Animal__c animal : animals){
            if (accountMap.containsKey(animal.Account__r.Id)) {
                accountMap.get(animal.Account__r.Id).NumberOfAnimals__c = accountMap.get(animal.Account__r.Id).NumberOfAnimals__c-1;
                accountMap.get(animal.Account__r.Id).numberOfUnadapted__c = accountMap.get(animal.Account__r.Id).numberOfUnadapted__c-1;
            }else {
                Account shelter = new Account();
                shelter.Id = animal.Account__r.Id;
                shelter.NumberOfAnimals__c = animal.Account__r.NumberOfAnimals__c-1;
                shelter.numberOfUnadapted__c = animal.Account__r.numberOfUnadapted__c-1;
                accountMap.put(shelter.Id, shelter);
            }
        }
        return accountMap;
    }
}