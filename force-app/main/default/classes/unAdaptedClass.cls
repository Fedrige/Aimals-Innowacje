public class unAdaptedClass {
		public static Map<Id,Account> countUnadapted(Set<Id> adoptionsId){
        Map<Id,Account> AnimalMap = new Map<Id,Account>();
        List<Adoption__c> adoptions=[SELECT Id,Animal__r.Id, Animal__r.ifAdapted__c, Status__c, Amount__c,
                Animal__r.Account__r.numberOfUnadapted__c FROM Adoption__c WHERE Id IN :adoptionsId];
        for(Adoption__c adoption:adoptions){
            if(adoption.Status__c=='Approved'){
                if (AnimalMap.containsKey(adoption.Animal__r.Account__r.Id)) {
                    if(adoption.Animal__r.ifAdapted__c == 0){
                        AnimalMap.get(adoption.Animal__r.Account__r.Id).numberOfUnadapted__c=
                            AnimalMap.get(adoption.Animal__r.Account__r.Id).numberOfUnadapted__c-1;
                    }
                    
                   
                }else{
                    //Animal__c animalToUpdate = new Animal__c();
                    Account tmp = new Account();
                    tmp.Id = adoption.Animal__r.Account__r.Id;
                    //animalToUpdate.Id = adoption.Animal__r.Id;
                    System.debug('TOOOOOOOOOOOOOOOOO');
                    //System.debug(adoption.Animal__r.Account__r.numberOfUnadapted__c);
                    
                    if(adoption.Animal__r.ifAdapted__c == 0){
                        tmp.numberOfUnadapted__c = adoption.Animal__r.Account__r.numberOfUnadapted__c - 1;
                    }
                    
                    
                    AnimalMap.put(tmp.Id, tmp);
                    //animalToUpdate.Account__r.numberOfUnadapted__c = adoption.Animal__r.Account__r.numberOfUnadapted__c - 1;
                    //AnimalMap.put(animalToUpdate.Id, animalToUpdate);

                }
            }
        }
        return AnimalMap;
    }
}