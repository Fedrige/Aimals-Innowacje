trigger AdoptionTrigger on Adoption__c (after insert, after update) {
	Set<Id> adoptionsId = new Set<Id>();
    if(Trigger.isinsert){
        Map<Id,Contact> contactsMap = new Map<Id,Contact>();
        
        Map<Id, Animal__c> statusMap = new Map<Id, Animal__c>();
        
        Map<Id,Account> AnimalMap = new Map<Id,Account>();
        
        for(Adoption__c adoptionId : Trigger.new){
            adoptionsId.add(adoptionId.Id);
        }
        
        AnimalMap = unAdaptedClass.countUnadapted(adoptionsId);
        update AnimalMap.values();
        
        statusMap = changeStatusOfAnimalClass.changeStatus(adoptionsId);
        update statusMap.values();
        
        
        
        CountAdoptionClass.countAndAddAdoptions(adoptionsId);
        contactsMap=CountingContactPointsClass.countPoints(adoptionsId);
        update contactsMap.values();
        
        
    }else if(Trigger.isupdate){
        Map<Id, Animal__c> statusMap = new Map<Id, Animal__c>();
        
        Map<Id,Account> AnimalMap = new Map<Id,Account>();
        
        for(Id adoptionId : Trigger.newMap.keySet()){
        	if(Trigger.oldMap.get(adoptionId).Status__c != Trigger.newMap.get(adoptionId).Status__c){
            	adoptionsId.add(adoptionId);
        	}
    	}
        SendMailAfterAdoptionStatusChangedClass.sendMailWithSetOfAdoptionsId(adoptionsId);
        CountingContactPointsClass.countPoints(adoptionsId);
        
        AnimalMap = unAdaptedClass.countUnadapted(adoptionsId);
        update AnimalMap.values();
        
        statusMap = changeStatusOfAnimalClass.changeStatus(adoptionsId);
        update statusMap.values();
    }else if(Trigger.isdelete){
        for(Adoption__c adoptionId : Trigger.old){
            adoptionsId.add(adoptionId.Id);
        }
        CountAdoptionClass.countAndDeleteAdoptions(adoptionsId);
    }
}