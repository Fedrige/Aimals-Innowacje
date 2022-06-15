public class CountingContactPointsClass {
	public static Map<Id,Contact> countPoints(Set<Id> adoptionsId){
        Map<Id,Contact> contactsMap = new Map<Id,Contact>();
    	List<Adoption__c> adoptions=[SELECT Id,Contact__r.Id, Contact__r.SumOfPoints__c, Status__c, Amount__c FROM Adoption__c WHERE Id IN :adoptionsId];
    	for(Adoption__c adoption:adoptions){
        	if(adoption.Status__c!='Approved')continue;
        	if(contactsMap.containsKey(adoption.Contact__r.Id)){
                if(adoption.Amount__c == null)contactsMap.get(adoption.Contact__r.Id).SumOfPoints__c-=20;
            	else contactsMap.get(adoption.Contact__r.Id).SumOfPoints__c-=10;
            	if(contactsMap.get(adoption.Contact__r.Id).SumOfPoints__c<0) contactsMap.get(adoption.Contact__r.Id).SumOfPoints__c=0;
        	}
        	else{
            	Contact contactToUpdate = new Contact();
            	contactToUpdate.Id=adoption.Contact__r.Id;
            	if(adoption.Amount__c == null )contactToUpdate.SumOfPoints__c=adoption.Contact__r.SumOfPoints__c-20;
                //else contactToUpdate.SumOfPoints__c=adoption.Contact__r.SumOfPoints__c-10;
            	if(contactToUpdate.SumOfPoints__c<0) contactToUpdate.SumOfPoints__c=0;
            	contactsMap.put(contactToUpdate.Id,contactToUpdate);
        	}
    	}
    	return contactsMap;
    }
}