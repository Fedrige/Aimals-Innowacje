/**
 * Created by Adam on 11.06.2022.
 */


public with sharing class lookForAnimalController {

    @AuraEnabled
    public static List<String> getShelterNames(){
        List<String> shelterNames = new List<String>();
        shelterNames.add('Any');

        List<Account> accounts = [SELECT Name FROM Account];

        for (Account acc : accounts){
            shelterNames.add(acc.Name);
        }

        return shelterNames;
    }

    @AuraEnabled
    public static List<String> getBreedNames(){
        List<String> breedNames = new List<String>();
        breedNames.add('Any');

        List<Animal__c> animals = [SELECT Breed__c FROM Animal__c];

        for (Animal__c ani : animals){
            if(!breedNames.contains(ani.Breed__c)){
                breedNames.add(ani.Breed__c);
            }
        }

        return breedNames;
    }

    @AuraEnabled
    public static List<String> getAge(){
        List<String> age = new List<String>();
        age.add('Any');

        List<Animal__c> animals = [SELECT Age__c FROM Animal__c];

        for (Animal__c ani : animals){
            if(!age.contains(String.valueOf(ani.Age__c))){
                age.add(String.valueOf(ani.Age__c));
            }
        }
        return age;
    }

    @AuraEnabled(cacheable=true)
    public static List<Animal__c> getAnimal(String shelterValue, String breedValue, String ageValue, String genderValue){
        String queryTemplate = 'SELECT Id, Name, Breed__c, Age__c, URLtoFoto__c, Account__r.Name FROM Animal__c {0} {1}';
        List<String> whereClauses = new List<String>();

        if(shelterValue != 'Any'){
            whereClauses.add('Account__r.Name = :shelterValue');
        }
        if(breedValue != 'Any'){
            whereClauses.add('Breed__c = :breedValue');
        }
        if(ageValue != 'Any'){
            Integer ageValueInt = Integer.valueOf(ageValue);
            whereClauses.add('Age__c = :ageValueInt');
        }
        if(genderValue != 'Any'){
            whereClauses.add('Sex__c = :genderValue');
        }


        List<Animal__c> animals = Database.query(
                String.format(
                        queryTemplate,
                        new List<String> {
                                whereClauses.size() > 0 ? 'WHERE' : '',
                                String.join(whereClauses, ' AND ')
                        }
                )
        );

        return animals;
    }

}