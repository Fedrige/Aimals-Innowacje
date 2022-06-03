@RestResource(urlMapping='/MissingAnimals')
global class RestMissingAnimal {
	@HttpGet
    global static List<Id> getMissingAnimals(){
        String dayDeltaString = RestContext.request.params.get('dayDelta');
        integer dayDelta = 0;
        
        if(dayDeltaString != null){
            dayDelta = Integer.ValueOf(dayDeltaString);
        }
        
        Date d = System.today() - (dayDelta-1);
		Date ddbb = System.today() - dayDelta;
		List<Missing_Animal__c> missingAnimalsList = [SELECT Id, Missing_Date__c From Missing_Animal__c WHERE Missing_Date__c < :d and Missing_Date__c >= :ddbb];
        List<Id> missingAnimalsId = new List<Id>();
        
        for(Missing_Animal__c animal : missingAnimalsList){
            missingAnimalsId.add(animal.Id);
        }
        return missingAnimalsId;
    }
}