public class changeStatusOfAnimalClass {
public static Map<Id,Animal__c> changeStatus(Set<Id> adoptionsId){
    	Map<Id, Animal__c> statusMap = new Map<Id, Animal__c>();
        List<Adoption__c> adoptions=[SELECT Id,Animal__r.Id, Animal__r.ifAdapted__c, Status__c, Amount__c,
                Animal__r.Account__r.numberOfUnadapted__c FROM Adoption__c WHERE Id IN :adoptionsId];
        for(Adoption__c adoption:adoptions){
            if(adoption.Status__c=='Approved'){
                if (statusMap.containsKey(adoption.Animal__r.Id)) {
                    statusMap.get(adoption.Animal__r.Id).ifAdapted__c= 1;
                    //adoption.Animal__r.ifAdapted__c=adoption.Animal__r.ifAdapted__c+1;
                }else{
                    Animal__c animalToUpdate = new Animal__c();
                    animalToUpdate.Id = adoption.Animal__r.Id;
                    System.debug('TOOOOOOOOOOOOOOOOO');
                    //System.debug(adoption.Animal__r.Account__r.numberOfUnadapted__c);
                    animalToUpdate.ifAdapted__c = 1;
                    statusMap.put(animalToUpdate.Id, animalToUpdate);

                }
            }
        }
        return statusMap;
    }
}