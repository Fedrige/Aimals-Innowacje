trigger CountAdoption on Adoption__c (after insert, after delete) {
    Set<Id> adoptionsId = new Set<Id>();
    List<Account> accountsToUpdate = new List<Account>();
    if(Trigger.isinsert){
        for(Adoption__c adoptionId : Trigger.new){
            adoptionsId.add(adoptionId.Id);
        }
        List<Adoption__c> adoptions=[SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c FROM Adoption__c WHERE Id IN :adoptionsId];
        Boolean ifAccountWasFound;
        for(Adoption__c adoption:adoptions){
            ifAccountWasFound=false;
            for(Account account:accountsToUpdate){
                if(account.Id == adoption.Animal__r.Account__r.Id){
                    account.SumOfAdoptions__c=account.SumOfAdoptions__c+1;
                    ifAccountWasFound=true;
                }
            }
            if(!ifAccountWasFound){
            	Account shelterToUpdate = new Account();
            	shelterToUpdate.Id=adoption.Animal__r.Account__r.Id;
            	shelterToUpdate.SumOfAdoptions__c=adoption.Animal__r.Account__r.SumOfAdoptions__c+1;
            	accountsToUpdate.add(ShelterToUpdate);
            }
        }
    }else if(Trigger.isdelete){
        for(Adoption__c adoptionId : Trigger.old){
            adoptionsId.add(adoptionId.Id);
        }
        List<Adoption__c> ListofAllRecords = [SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c, Animal__r.Account__r.Name FROM Adoption__c WHERE ID != NULL];
        List<Adoption__c> AdoptionsDeleted = [SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c, Animal__r.Account__r.Name FROM Adoption__c WHERE Id IN :adoptionsId AND ID NOT IN : ListofAllRecords ALL ROWS];
        Boolean ifAccountWasFound;
        for(Adoption__c adoption:AdoptionsDeleted){
            ifAccountWasFound=false;
            for(Account account:accountsToUpdate){
                if(account.Id == adoption.Animal__r.Account__r.Id){
                    account.SumOfAdoptions__c=account.SumOfAdoptions__c-1;
                    ifAccountWasFound=true;
                }
            }
            if(!ifAccountWasFound){
            	Account shelterToUpdate = new Account();
            	shelterToUpdate.Id=adoption.Animal__r.Account__r.Id;
            	shelterToUpdate.SumOfAdoptions__c=adoption.Animal__r.Account__r.SumOfAdoptions__c-1;
            	accountsToUpdate.add(shelterToUpdate);
            }
        }
    }
    update accountsToUpdate;
}