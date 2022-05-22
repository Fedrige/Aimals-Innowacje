trigger countingHowManyPointsContactHas on Adoption__c (after insert, after update) {
	Set<Id> adoptionsId = new Set<Id>();
    List<Contact> contactsToUpdate = new List<Contact>();
    Boolean ifAccountWasFound;
    if(Trigger.isinsert){
        for(Adoption__c adoptionId : Trigger.new){
            adoptionsId.add(adoptionId.Id);
        }
    }else if(Trigger.isupdate){
        for(Id adoptionId : Trigger.newMap.keySet()){
        	if(Trigger.oldMap.get(adoptionId).Status__c != Trigger.newMap.get(adoptionId).Status__c){
            	adoptionsId.add(adoptionId);
        	}
    	}
    }
    List<Adoption__c> adoptions=[SELECT Id,Animal__r.Account__r.Id, Animal__r.Account__r.SumOfAdoptions__c FROM Adoption__c WHERE Id IN :adoptionsId];
    for(Adoption__c adoption:adoptions){
        ifAccountWasFound=false;
        if(adoption.Status__c!='Approved')continue;
        for(Contact contactToCheck:contactsToUpdate){
            if(contactToCheck.Id == adoption.Contact__r.Id){
                if(adoption.Amount__c == null)contactToCheck.SumOfPoints__c=contactToCheck.SumOfPoints__c+20;
                else contactToCheck.SumOfPoints__c=contactToCheck.SumOfPoints__c+20;
                ifAccountWasFound=true;
            }
        }
        if(!ifAccountWasFound){
            Contact contactToUpdate = new Contact();
            contactToUpdate.Id=adoption.Contact__r.Id;
            if(adoption.Amount__c == null)contactToUpdate.SumOfPoints__c=contactToUpdate.SumOfPoints__c+20;
            else contactToUpdate.SumOfPoints__c=contactToUpdate.SumOfPoints__c+10;
            
            contactsToUpdate.add(contactToUpdate);
        }
    }
}