public with sharing class RestMissingAnimal {
    static String calloutString = 'callout:Missing_Animal_Rest';

    @AuraEnabled(cacheable=true)
    public static List<Id> getMissingAnimals(Integer dayDelta){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<Id> missingAnimalsIdList = new List<Id>();

        if (dayDelta == null || dayDelta < 0) {
            dayDelta = 0;
        }

        request.setEndpoint(calloutString + '?dayDelta=' + dayDelta);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        missingAnimalsIdList = response.getBody().replaceAll('\\[', '').replaceAll('\\]', '').replaceAll('\\"', '').split('\\,');

        return missingAnimalsIdList;
    }

    @AuraEnabled(cacheable=true)
    public static String getMissingAnimalImage(Id animalId){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(calloutString + '/' + animalId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Blob image = response.getBodyAsBlob();
        String imageUrl =  'data:'+response.getHeader('Content-Type')+';base64,'+EncodingUtil.base64Encode(image);
        return imageUrl;
    }
    
    public static String getMissingAnimalImageRestFlow(Id animalId){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(calloutString + '/' + animalId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Blob image = response.getBodyAsBlob();
        String imageUrl = EncodingUtil.base64Encode(image);
        return imageUrl;
    }
}