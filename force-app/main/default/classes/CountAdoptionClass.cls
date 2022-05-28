public class CountAdoptionClass {
	public static Map<Id,Account> countAndAddAdoptions(Set<Id> adoptionsId){
        Map<Id,Account> accountMap = new Map<Id,Account>();
    	List<Adoption__c> adoptions=[SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c FROM Adoption__c WHERE Id IN :adoptionsId];
        for(Adoption__c adoption:adoptions){
            if(accountMap.containsKey(adoption.Animal__r.Account__r.Id)){
                accountMap.get(adoption.Animal__r.Account__r.Id).SumOfAdoptions__c=accountMap.get(adoption.Animal__r.Account__r.Id).SumOfAdoptions__c+1;
            }
            else{
            	Account shelterToUpdate = new Account();
            	shelterToUpdate.Id=adoption.Animal__r.Account__r.Id;
            	shelterToUpdate.SumOfAdoptions__c=adoption.Animal__r.Account__r.SumOfAdoptions__c+1;
            	accountMap.put(ShelterToUpdate.Id,ShelterToUpdate);
            }
        }
        return accountMap;
    }
    public static Map<Id,Account> countAndDeleteAdoptions(Set<Id> adoptionsId){
        Map<Id,Account> accountMap = new Map<Id,Account>();
        List<Adoption__c> ListofAllRecords = [SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c, Animal__r.Account__r.Name FROM Adoption__c WHERE ID != NULL];
        List<Adoption__c> AdoptionsDeleted = [SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c, Animal__r.Account__r.Name FROM Adoption__c WHERE Id IN :adoptionsId AND ID NOT IN : ListofAllRecords ALL ROWS];
        for(Adoption__c adoption:AdoptionsDeleted){
            if(accountMap.containsKey(adoption.Animal__r.Account__r.Id)){
                 accountMap.get(adoption.Animal__r.Account__r.Id).SumOfAdoptions__c=accountMap.get(adoption.Animal__r.Account__r.Id).SumOfAdoptions__c-1;
            }else{
            	Account shelterToUpdate = new Account();
            	shelterToUpdate.Id=adoption.Animal__r.Account__r.Id;
            	shelterToUpdate.SumOfAdoptions__c=adoption.Animal__r.Account__r.SumOfAdoptions__c-1;
            	accountMap.put(ShelterToUpdate.Id,ShelterToUpdate);
            }
        }
        return accountMap;
    }
}