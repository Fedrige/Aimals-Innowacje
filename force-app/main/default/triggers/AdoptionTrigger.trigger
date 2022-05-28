trigger AdoptionTrigger on Adoption__c (after insert, after update) {
	Set<Id> adoptionsId = new Set<Id>();
    if(Trigger.isinsert){
        for(Adoption__c adoptionId : Trigger.new){
            adoptionsId.add(adoptionId.Id);
        }
        CountAdoptionClass.countAndAddAdoptions(adoptionsId);
        CountingContactPoints.countPoints(adoptionsId);
    }else if(Trigger.isupdate){
        for(Id adoptionId : Trigger.newMap.keySet()){
        	if(Trigger.oldMap.get(adoptionId).Status__c != Trigger.newMap.get(adoptionId).Status__c){
            	adoptionsId.add(adoptionId);
        	}
    	}
        SendMailAfterAdoptionStatusChangedClass.sendMailWithSetOfAdoptionsId(adoptionsId);
        CountingContactPoints.countPoints(adoptionsId);
    }else if(Trigger.isdelete){
        for(Adoption__c adoptionId : Trigger.old){
            adoptionsId.add(adoptionId.Id);
        }
        CountAdoptionClass.countAndDeleteAdoptions(adoptionsId);
    }
}