@RestResource(urlMapping='/MissingAnimals/*')
global class RestMissingAnimalImage {
	@HttpGet
    global static String getMissingAnimalImage(){
        RestRequest request = RestContext.request;
        String animalId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        Animal__c result = [SELECT Id, URLtoFoto__c  FROM Animal__c WHERE Id = :animalId];
        return result.URLtoFoto__c;
    }
}