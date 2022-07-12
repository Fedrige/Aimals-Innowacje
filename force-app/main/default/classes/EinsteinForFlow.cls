public class EinsteinForFlow {
    @InvocableMethod(label='einstein for flow')
	public static List<String> getBreedOfAnimal(List<String> strBase64){
        String modelId='W37CRWEAGCDS3XPN2X72ASAHJ4';
        String sampleId='';
        List<String>listOfOneBreed = new List<String>();
        einsteinplay.Einstein_PredictionService einsteinService = new einsteinplay.Einstein_PredictionService(
                einsteinplay.Einstein_PredictionService.Types.IMAGE
            );
        einsteinplay.Einstein_PredictionResult einstein = new einsteinplay.Einstein_PredictionResult();
        einstein=einsteinService.predictImageBase64(modelId,strBase64.get(0),1,sampleId);
    
        Integer thresholdValue = (Integer)ProbabilityOfBreedSetting__mdt.getInstance('prob').ProbabilityThreshold__c;
        Double probability = einstein.probabilities.get(0).probability;
        if (thresholdValue > (Integer)(probability * 100)) {
            return null;
        }
        
        String breed = einstein.probabilities.get(0).label;
        listOfOneBreed.add(breed);
        return listOfOneBreed;
    }
}